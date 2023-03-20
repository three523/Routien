//
//  ListViewController.swift
//  Routine
//
//  Created by 김도현 on 2023/01/10.
//

import UIKit

protocol TaskAddProtocol: AnyObject {
    func textTaskIsDone(textTask: RoutineTextTask)
}

protocol PresentTextProtocol: AnyObject {
    func excute(task: RoutineTextTask)
}

final class ListViewController: UIViewController {
    
    let dailyCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width/7, height: 60)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isPagingEnabled = true
        return collectionView
    }()
    
    let listAddButton: UIButton = {
        let button = UIButton()
        button.setTitle("리스트 추가 +", for: .normal)
        button.backgroundColor = .mainColor
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 10, bottom: 8, right: 10)
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        return button
    }()
    
    private let filterButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "line.3.horizontal.decrease"), for: .normal)
        button.tintColor = .mainColor
        return button
    }()
    
    private let sortButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "arrow.up.arrow.down"), for: .normal)
        button.tintColor = .mainColor
        return button
    }()
    
    private let listTableView: UITableView = {
        let tableView = UITableView()
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        return tableView
    }()
    var todayIndex = 0
    private var beginPositionX: CGFloat = 0.0
    private var selectedDate = Date() {
        didSet {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy년 M월"
            DispatchQueue.main.async {
                self.navigationItem.title = formatter.string(from: self.selectedDate)
            }
        }
    }
    let listViewModel: ListViewModel
    var tasks: [Task] = []
    var dateList: [Date] = Date().defaultDays {
        didSet {
            DispatchQueue.main.async {
                self.dailyCollectionView.reloadData()
                self.dailyCollectionView.layer.addBorder([.top, .bottom], color: UIColor.secondaryColor, size: self.dailyCollectionView.contentSize, width: 1)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationSetting()
        viewAdd()
        autolayoutSetting()
        collectionViewSetting()
        tableViewSetting()
        buttonSetting()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        listTableView.reloadData()
    }
    
    init(viewModel: ListViewModel) {
        self.listViewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.listViewModel = ListViewModel()
        super.init(nibName: nil, bundle: nil)
        fatalError("init(coder:) has not been implemented")
    }
    
    private func viewAdd() {
        view.addSubview(dailyCollectionView)
        view.addSubview(listAddButton)
        view.addSubview(filterButton)
        view.addSubview(sortButton)
        view.addSubview(listTableView)
    }
    
    private func autolayoutSetting() {
        dailyCollectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(60)
        }
        
        listAddButton.snp.makeConstraints { make in
            make.top.equalTo(dailyCollectionView.snp.bottom).inset(-14)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(12)
        }
        
        filterButton.snp.makeConstraints { make in
            make.top.equalTo(listAddButton)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(12)
            make.width.height.equalTo(32)
        }
        
        sortButton.snp.makeConstraints { make in
            make.top.equalTo(listAddButton)
            make.trailing.equalTo(filterButton.snp.leading).inset(-12)
            make.width.height.equalTo(32)
        }
        
        listTableView.snp.makeConstraints { make in
            make.top.equalTo(listAddButton.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(12)
            make.bottom.equalToSuperview()
        }
    }
    
    private func collectionViewSetting() {
        dailyCollectionView.delegate = self
        dailyCollectionView.dataSource = self
        dailyCollectionView.register(DailyCollectionViewCell.self)
        dailyCollectionView.layoutIfNeeded()
        dailyCollectionView.layer.addBorder([.top, .bottom], color: UIColor.secondaryColor, size: dailyCollectionView.contentSize, width: 1)
        for (index, date) in dateList.enumerated() where date.isToday { todayIndex = index }
        let todayIndexPath = IndexPath(item: todayIndex, section: 0)
        dailyCollectionView.selectItem(at: todayIndexPath, animated: true, scrollPosition: .centeredHorizontally)
        guard let date = (dailyCollectionView.cellForItem(at: todayIndexPath) as? DailyCollectionViewCell)?.date else { return }
        selectedDate = date
        RoutineManager.update = listTableView.reloadData
    }
    
    private func tableViewSetting() {
        listViewModel.update = listTableView.reloadData
        listTableView.delegate = self
        listTableView.dataSource = self
        listTableView.register(TextRoutineTableViewCell.self)
        listTableView.register(CheckRoutineTableViewCell.self)
        listTableView.register(CountRoutineTableViewCell.self)
        listTableView.register(TodoListTableViewCell.self)
    }

    private func navigationSetting() {
        let todayDate = Date()
        self.navigationItem.title = "\(todayDate.year)년 \(todayDate.month)월"
    }
    
    private func buttonSetting() {
        listAddButton.addTarget(self, action: #selector(listAddButtonClick), for: .touchUpInside)
    }
    
    @objc
    func listAddButtonClick() {
        let addVC = CreateRoutineViewController()
        addVC.modalPresentationStyle = .fullScreen
        present(addVC, animated: true)
    }

}

extension ListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dateList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(DailyCollectionViewCell.self, for: indexPath)
        cell.layer.cornerRadius = 5
        cell.clipsToBounds = true
        let date = dateList[indexPath.item]
        cell.isToday = false
        if date.isToday {
            cell.isToday = true
        }
        cell.setDate(date: date)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedDate = dateList[indexPath.item]
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        guard let cell = dailyCollectionView.cellForItem(at: indexPath) as? DailyCollectionViewCell else { return true }
        selectedDate = cell.date
        listTableView.reloadData()
        return true
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        beginPositionX = scrollView.contentOffset.x
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let endPositionX = scrollView.contentOffset.x
        
        let visibleRect = CGRect(origin: dailyCollectionView.bounds.origin, size: dailyCollectionView.bounds.size)
        let visibleFirstCellPoint = CGPoint(x: visibleRect.minX + 10, y: visibleRect.midY)

        guard var visibleFirstCellIndexPath = dailyCollectionView.indexPathForItem(at: visibleFirstCellPoint) else { return }
        let visibleFirstCellIndexPathTemp = visibleFirstCellIndexPath
                
        if beginPositionX < endPositionX {
            appendDateList()
        } else if beginPositionX > endPositionX {
            insertFirstDateList()
            visibleFirstCellIndexPath.item += 7
        } else {
            return
        }
                
        DispatchQueue.main.async {
            self.dailyCollectionView.selectItem(at: visibleFirstCellIndexPath, animated: false, scrollPosition: .left)
        }
                
        guard let selectedCell = dailyCollectionView.cellForItem(at: visibleFirstCellIndexPathTemp) as? DailyCollectionViewCell else {
            print("cell is not DailyCollectionViewCell")
            return
        }
        selectedDate = selectedCell.date
    }
    
    func appendDateList() {
        guard let nextDates = dateList.last?.nextWeek else { return }
        dateList.append(contentsOf: nextDates)
    }
    
    func insertFirstDateList() {
        guard let previousDates = dateList.first?.previousWeek else { return }
        dateList.insert(contentsOf: previousDates, at: 0)
    }
}

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        tasks = listViewModel.fetchAllTask(to: selectedDate)
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell = UITableViewCell()
        
        let task = tasks[indexPath.section]
                
        if let textTask = task as? RoutineTextTask {
            guard let textCell = tableView.dequeueReusableCell(TextRoutineTableViewCell.self, for: indexPath) as? TextRoutineTableViewCell else { return cell }
            textCell.routineTextTask = textTask
            textCell.delegate = self
            cell = textCell
        } else if let countTask = task as? RoutineCountTask {
            guard let countCell = tableView.dequeueReusableCell(CountRoutineTableViewCell.self, for: indexPath) as? CountRoutineTableViewCell else { return cell }
            countCell.routineCountTask = countTask
            cell = countCell
        } else if let checkTask = task as? RoutineCheckTask {
            guard let checkCell = tableView.dequeueReusableCell(CheckRoutineTableViewCell.self, for: indexPath) as? CheckRoutineTableViewCell else { return cell }
            checkCell.routineCheckTask = checkTask
            cell = checkCell
        }
        
        cell.clipsToBounds = true
        cell.selectionStyle = .none
        cell.layer.cornerRadius = 5
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 0.5
        return cell
    }
    
}

extension ListViewController: PresentTextProtocol, TaskAddProtocol {
    
    func textTaskIsDone(textTask: RoutineTextTask) {
        listViewModel.append(routinTask: textTask)
    }
    
    func excute(task: RoutineTextTask) {
        let vc = TextAddViewController()
        vc.modalPresentationStyle = .overFullScreen
        vc.delegate = self
        vc.textTask = task
        present(vc, animated: true)
    }
}
