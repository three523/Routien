//
//  RoutineManager.swift
//  Routine
//
//  Created by 김도현 on 2023/01/18.
//

import UserNotifications
import RealmSwift

enum SortType: String, CaseIterable {
    case createTimeAscending = "생성시간순(오름차순)"
    case createTimeDescending = "생성시간순(내림차순)"
    case textAscending = "글자순(오름차순)"
    case textDescending = "글자순(내림차순)"
    case notificationTimeAscending = "알람시간순(오름차순)"
    case notificationTimeDescending = "알람시간순(내림차순)"
}

enum FilterType: String, CaseIterable {
    case none = "모두 보기"
    case unDoneRoutine = "완료되지 않은 루틴만 보기"
    case doneRoutine = "완료된 루틴만 보기"
    
}

final class RoutineManager {
    static let shared: RoutineManager = RoutineManager()
    var realm: Realm?
    var arrayViewUpdates: [() -> Void] = []
    
    
    //MARK: 루틴 필터랑 정렬 기능 UserDefaults 에 저장하고 가져오기
    var sortType: SortType = SortType(rawValue: UserDefaults.standard.string(forKey: "SortType") ?? SortType.createTimeAscending.rawValue) ?? SortType.createTimeAscending {
        didSet {
            UserDefaults.standard.set(sortType.rawValue, forKey: "SortType")
            viewUpdate()
        }
    }
    
    var filterType: FilterType = FilterType(rawValue: UserDefaults.standard.string(forKey: "FilterType") ?? FilterType.none.rawValue) ?? FilterType.none {
        didSet {
            UserDefaults.standard.set(filterType.rawValue, forKey: "FilterType")
            viewUpdate()
        }
    }
    
    private init() {
        let config = Realm.Configuration(schemaVersion: 2)
        Realm.Configuration.defaultConfiguration = config
        realm = try? Realm(configuration: config)
    }
    
    func viewUpdate() {
        RoutineManager.shared.arrayViewUpdates.forEach { viewUpdate in
            viewUpdate()
        }
    }
    
    func create(_ routine: Routine) {
        var typeCastingRoutine: Object & Routine
        if let checkRoutine = routine as? CheckRoutine {
            typeCastingRoutine = checkRoutine
        } else if let countRoutine = routine as? CountRoutine {
            typeCastingRoutine = countRoutine
        } else if let textRoutine = routine as? TextRoutine {
            typeCastingRoutine = textRoutine
        } else {
            print("routine: \(routine) type not found")
            return
        }
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(typeCastingRoutine, update: .modified)
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func append(_ task: RoutineTask) {
        guard var routine = fetch(task.routineIdentifier) else { return }
        guard let realm else { return }
        
        do {
            try realm.write {
                routine.myTasks.append(task)
                print("Task apeend")
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func update<T: Object & Routine>(routineType: T.Type, _ task: RoutineTask) {
        guard let realm else { return }
        do {
            guard var routine = realm.objects(routineType).first(where: { $0.identifier == task.routineIdentifier }),
                  let taskIndex = routine.myTasks.firstIndex(where: { $0.identifier == task.identifier }) else {
                print("routineTask identifier not found")
                print("identifier: \(task.identifier)")
                print("routine: \(realm.objects(routineType).first( where: { $0.identifier == task.routineIdentifier } )?.myTasks)")
                return
            }
            try realm.write {
                routine.myTasks[taskIndex] = task
                print("Task update")
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func update(_ routine: Routine) {
        //MARK: 완료한 루틴 이전의 내용도 바꿀것인지 현재 내용만 바꿀것인지, 특정날 이후로만 바꿀 것인지 선택 가능하게 하기
        var typeCastingRoutine: Object & Routine
        if let checkRoutine = routine as? CheckRoutine {
            typeCastingRoutine = checkRoutine
        } else if let countRoutine = routine as? CountRoutine {
            typeCastingRoutine = countRoutine
        } else if let textRoutine = routine as? TextRoutine {
            typeCastingRoutine = textRoutine
        } else {
            print("routine: \(routine) type not found")
            return
        }
        guard let _ = fetch(routine.identifier) else { return }
        guard let realm else { return }
        
        do {
            try realm.write {
                realm.add(typeCastingRoutine, update: .modified)
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func fetchAllRoutine() -> [Routine] {
        guard let realm else {
            print("Realm is nil")
            return []
        }
        var routine: [Routine] = []
        routine.append(contentsOf: realm.objects(CheckRoutine.self).toArray(type: CheckRoutine.self))
        routine.append(contentsOf: realm.objects(TextRoutine.self).toArray(type: TextRoutine.self))
        routine.append(contentsOf: realm.objects(CountRoutine.self).toArray(type: CountRoutine.self))
        routine.sort { $0.createTime < $1.createTime }
        return routine
    }
    
    func fetch(_ identifier: UUID) -> Routine? {
        guard let realm else {
            print("Realm is nil")
            return nil
        }
        guard let routine = fetchAllRoutine().first(where: { $0.identifier == identifier }) else {
            print("Routine: \(identifier) is not found")
            return nil }
        return routine
    }
    
    func fetch(routineTask: RoutineTask) -> RoutineTask? {
        guard realm != nil else {
            print("Realm is nil")
            return nil
        }
        guard let routine = fetch(routineTask.routineIdentifier) else { return nil }
        
        return routine.myTasks.filter{ $0.identifier == routineTask.identifier }.first
    }
    
    func fetchAllTask(to date: Date, isSortAndFilter: Bool) -> [Task] {
        guard realm != nil else { return [] }
        var routines = fetchAllRoutine()
        var tasks = [Task]()
        let calendar = Calendar.current
        if isSortAndFilter { routines = sorted(routines: routines) }
        for index in 0..<routines.count {
            if let routineTask = routines[index].myTasks.first(where: { calendar.isDate(date, equalTo: $0.taskDate, toGranularity: .day) }) {
                tasks.append(routineTask)
            } else if let newRoutineTask = routines[index].getTask(date: date) {
                tasks.append(newRoutineTask)
            }
        }
        if isSortAndFilter { tasks = filter(tasks: tasks) }
        return tasks
    }
    
    private func sorted(routines: [Routine]) -> [Routine] {
        switch sortType {
        case .createTimeAscending:
            return routines.sorted{ $0.createTime < $1.createTime }
        case .createTimeDescending:
            return routines.sorted{ $0.createTime > $1.createTime }
        case .notificationTimeAscending:
            return routines.sorted{ routine1, routine2 in
                guard let date1 = routine1.notificationTime else { return true }
                guard let date2 = routine2.notificationTime else { return false }
                return date1 < date2
            }
        case .notificationTimeDescending:
            return routines.sorted{ routine1, routine2 in
                guard let date1 = routine1.notificationTime else { return true }
                guard let date2 = routine2.notificationTime else { return false }
                return date1 > date2
            }
        case .textAscending:
            return routines.sorted{ $0.title < $1.title }
        case .textDescending:
            return routines.sorted{ $0.title > $1.title }
        }
    }
    
    private func filter(tasks: [Task]) -> [Task] {
        switch RoutineManager.shared.filterType {
        case .none:
            return tasks
        case .doneRoutine:
            return tasks.filter{ $0.isDone }
        case .unDoneRoutine:
            return tasks.filter{ false == $0.isDone }
        }
    }
    
    func delete(routineTask: RoutineTask) {
        guard let routine = fetchAllRoutine().first(where: { $0.identifier == routineTask.routineIdentifier }) else {
            print("Routine remove: routine not found")
            return
        }
        if let checkRoutine = routine as? CheckRoutine {
            delete(routine: checkRoutine)
        } else if let textRoutine = routine as? TextRoutine {
            delete(routine: textRoutine)
        } else if let countRoutine = routine as? CountRoutine {
            delete(routine: countRoutine)
        }
    }
    
    func delete(routineIdentifier: UUID) {
        guard let routine = fetchAllRoutine().first(where: { $0.identifier == routineIdentifier }) else {
            print("Routine remove: routine not found")
            return
        }
        if let checkRoutine = routine as? CheckRoutine {
            delete(routine: checkRoutine)
        } else if let textRoutine = routine as? TextRoutine {
            delete(routine: textRoutine)
        } else if let countRoutine = routine as? CountRoutine {
            delete(routine: countRoutine)
        }
    }
    
    func delete<T: Object & Routine>(routine: T) {
        guard let realm else {
            print("realm is nil")
            return
        }
        do {
            try realm.write({
                let deletedRoutineTitle = routine.title
                realm.delete(routine)
                print("Routine \(deletedRoutineTitle) delete")
                viewUpdate()
            })
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
