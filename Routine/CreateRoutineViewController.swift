//
//  CreateRoutineViewController.swift
//  Routine
//
//  Created by 김도현 on 2023/01/14.
//

import UIKit
enum RoutineType: String {
    case check = "체크"
    case text = "글"
    case count = "카운트"
    
    static let allCases: [RoutineType] = [.check, .text, .count]
}

final class CreateRoutineViewController: UIViewController, UNUserNotificationCenterDelegate {
    
    private let routineLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.textColor = .black
        label.text = "루틴 이름"
        return label
    }()
    
    private let routineTextField: UITextField = {
        let textField = UITextField()
        textField.font = .systemFont(ofSize: 17, weight: .regular)
        textField.textColor = .black
        textField.attributedPlaceholder = NSAttributedString(string: "나의 루틴을 입력해주세요.", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        textField.textAlignment = .center
        textField.backgroundColor = .secondaryColor
        textField.clipsToBounds = true
        textField.layer.cornerRadius = 5
        return textField
    }()
    
    private let workDailyLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.textColor = .black
        label.text = "수행 요일"
        return label
    }()
    
    private let workDailyStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private let workDateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.textColor = .black
        label.text = "수행 일"
        return label
    }()
    
    private let startDateStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 12
        return stackView
    }()
    
    private let startDateTextField: DatePickerTextField = {
        let textField = DatePickerTextField()
        textField.text = Date().dateToString
        textField.textColor = .black
        textField.textAlignment = .center
        textField.tintColor = .clear
        textField.clipsToBounds = true
        textField.layer.cornerRadius = 5
        textField.backgroundColor = .mainColor
        return textField
    }()
    
    private let endDateStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 12
        return stackView
    }()
    
    private let endDateTextField: DatePickerTextField = {
        let textField = DatePickerTextField()
        textField.text = "설정안함"
        textField.textColor = .white
        textField.textAlignment = .center
        textField.tintColor = .clear
        textField.clipsToBounds = true
        textField.layer.cornerRadius = 5
        textField.backgroundColor = .secondaryColor
        return textField
    }()
    
    private let notificationLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.textColor = .black
        label.text = "알림"
        return label
    }()
    
    private let notificationStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 12
        return stackView
    }()
        
    private let notificationSwitch: UISwitch = {
        let toggle = UISwitch()
        toggle.onTintColor = .mainColor
        return toggle
    }()
    
    private let typeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.textColor = .black
        label.text = "타입:"
        return label
    }()
    
    private let typeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 12
        return stackView
    }()
    
    private let goalLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.textColor = .black
        label.text = "목표:"
        label.isHidden = true
        return label
    }()
    
    private let goalTextField: UITextField = {
        let textField: UITextField = UITextField()
        textField.font = .systemFont(ofSize: 17, weight: .regular)
        textField.text = "1"
        textField.keyboardType = .numberPad
        textField.textAlignment = .center
        textField.isHidden = true
        return textField
    }()
        
    private let doneButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGray4
        button.setTitleColor(.white, for: .disabled)
        button.setTitle("완료", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.clipsToBounds = true
        button.layer.cornerRadius = 10
        button.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        button.isEnabled = false
        return button
    }()
    
    private let startDatePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.locale = Locale(identifier: "ko-KR")
        picker.preferredDatePickerStyle = .inline
        picker.tag = 1
        picker.backgroundColor = .white
        return picker
    }()
    private let endDatePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.locale = Locale(identifier: "ko-KR")
        picker.preferredDatePickerStyle = .inline
        picker.tag = 2
        picker.backgroundColor = .white
        return picker
    }()
    private let notificationDatePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .time
        picker.preferredDatePickerStyle = .compact
        picker.locale = Locale(identifier: "ko-KR")
        picker.timeZone = .autoupdatingCurrent
        picker.contentHorizontalAlignment = .center
        picker.contentVerticalAlignment = .center
        picker.backgroundColor = .secondaryColor
        picker.layer.cornerRadius = 5
        picker.clipsToBounds = true
        picker.alpha = 0.01001
        return picker
    }()
    
    var routine: Routine? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)

        viewAdd()
        dailyStackViewSetting()
        dateStackViewSetting()
        notificationStackViewSetting()
        typeStackViewSetting()
        autolayoutSetting()
        textFieldSetting()
        notificationSwitchSetting()
        buttonSetting()
        update()
    }
    
    private func viewAdd() {
        view.addSubview(routineLabel)
        view.addSubview(routineTextField)
        view.addSubview(workDailyLabel)
        view.addSubview(workDailyStackView)
        view.addSubview(workDateLabel)
        view.addSubview(startDateStackView)
        view.addSubview(endDateStackView)
        view.addSubview(notificationLabel)
        view.addSubview(notificationStackView)
        view.addSubview(notificationSwitch)
        view.addSubview(typeLabel)
        view.addSubview(typeStackView)
        view.addSubview(goalLabel)
        view.addSubview(goalTextField)
        view.addSubview(doneButton)
    }
    
    private func autolayoutSetting() {
        routineLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(12)
            make.leading.equalToSuperview().inset(10)
        }
        
        routineTextField.snp.makeConstraints { make in
            make.top.equalTo(routineLabel.snp.bottom).inset(-12)
            make.centerX.equalToSuperview()
            make.width.equalTo(260)
            make.height.equalTo(36)
        }
        
        workDailyLabel.snp.makeConstraints { make in
            make.top.equalTo(routineTextField.snp.bottom).inset(-32)
            make.leading.equalToSuperview().inset(10)
        }
        
        workDailyStackView.snp.makeConstraints { make in
            make.top.equalTo(workDailyLabel.snp.bottom).inset(-12)
            make.leading.trailing.equalToSuperview().inset(12)
            make.height.equalTo(44)
        }
        
        workDateLabel.snp.makeConstraints { make in
            make.top.equalTo(workDailyStackView.snp.bottom).inset(-32)
            make.leading.equalToSuperview().inset(10)
        }
        
        startDateStackView.snp.makeConstraints { make in
            make.top.equalTo(workDateLabel.snp.bottom).inset(-16)
            make.leading.equalToSuperview().inset(10)
        }
        
        endDateStackView.snp.makeConstraints { make in
            make.top.equalTo(startDateStackView.snp.bottom).inset(-16)
            make.leading.equalToSuperview().inset(10)
        }
        
        notificationLabel.snp.makeConstraints { make in
            make.top.equalTo(endDateStackView.snp.bottom).inset(-32)
            make.leading.equalToSuperview().inset(10)
        }
        
        notificationStackView.snp.makeConstraints { make in
            make.top.equalTo(notificationLabel.snp.bottom).inset(-16)
            make.leading.equalToSuperview().inset(10)
        }
        
        notificationSwitch.snp.makeConstraints { make in
            make.centerY.equalTo(notificationStackView.snp.centerY)
            make.trailing.equalToSuperview().inset(12)
            make.width.equalTo(51)
            make.height.equalTo(30)
        }
        
        typeLabel.snp.makeConstraints { make in
            make.top.equalTo(notificationStackView.snp.bottom).inset(-32)
            make.leading.equalToSuperview().inset(10)
        }
        
        typeStackView.snp.makeConstraints { make in
            make.top.equalTo(typeLabel.snp.bottom).inset(-16)
            make.leading.equalToSuperview().inset(10)
            make.trailing.equalToSuperview().inset(22)
        }
        
        goalLabel.snp.makeConstraints { make in
            make.top.equalTo(typeStackView.snp.bottom).inset(-16)
            make.leading.equalToSuperview().inset(10)
        }
        
        goalTextField.snp.makeConstraints { make in
            make.top.equalTo(typeStackView.snp.bottom).inset(-16)
            make.width.equalTo(view.frame.width/2)
            make.centerX.equalToSuperview()
        }
                
        doneButton.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func update() {
        guard let routine = self.routine else { return }
        routineTextField.text = routine.description
        workDailyStackView.arrangedSubviews.forEach { view in
            guard let circleView = view as? CircleTextView else { return }
            if routine.dayOfWeek.contains(circleView.dayOfWeek) {
                circleView.isSelected = true
            } else {
                circleView.isSelected = false
            }
        }
        startDatePicker.date = routine.startDate
        if let endDate = routine.endDate {
            endDatePicker.date = endDate
            endDateTextField.backgroundColor = .mainColor
            endDateTextField.text = endDate.dateToString
            endDateTextField.textColor = .black
        }
        if let routineNotification = routine.notificationTime {
            notificationSwitch.isOn = true
            notificationStackView.bringSubviewToFront(notificationDatePicker)
            notificationDatePicker.date = routineNotification
            guard let notificationButton = notificationStackView.subviews.compactMap({ $0 as? UIButton }).first else { return }
            notificationButton.backgroundColor = .mainColor
            notificationButton.setTitle(routineNotification.timeToString, for: .normal)
            notificationButton.setTitleColor(.black, for: .normal)
        }
        
        if let countRoutine = routine as? CountRoutine {
            typeStackView.arrangedSubviews.forEach { view in
                guard let button = view as? UIButton,
                      let text = button.titleLabel?.text else { return }
                if text == RoutineType.count.rawValue {
                    button.isSelected = true
                    typeButtonClick(button)
                }
            }
            goalTextField.text = "\(countRoutine.goal)"
            goalAreaVisible()
        } else if let _ = routine as? CheckRoutine {
            typeStackView.arrangedSubviews.forEach { view in
                guard let button = view as? UIButton,
                      let text = button.titleLabel?.text else { return }
                if text == RoutineType.check.rawValue {
                    button.isSelected = true
                    typeButtonClick(button)
                }
            }
        } else if let _ = routine as? TextRoutine {
            typeStackView.arrangedSubviews.forEach { view in
                guard let button = view as? UIButton,
                      let text = button.titleLabel?.text else { return }
                if text == RoutineType.text.rawValue {
                    button.isSelected = true
                    typeButtonClick(button)
                }
            }
        }
        doneButton.isEnabled = true
        doneButton.backgroundColor = .mainColor
    }
    
    private func dailyStackViewSetting() {
        DayOfWeek.allCases.forEach { dayOfWeek in
            let circleView = CircleTextView()
            circleView.dayOfWeek = dayOfWeek
            circleView.backgroundColor = .secondaryColor
            circleView.snp.makeConstraints { make in
                make.width.height.equalTo(36)
            }
            circleView.isSelected = true
            workDailyStackView.addArrangedSubview(circleView)
        }
    }
    
    private func dateStackViewSetting() {
        startDatePicker.addTarget(self, action: #selector(dateFormatting), for: .valueChanged)
        endDatePicker.addTarget(self, action: #selector(dateFormatting), for: .valueChanged)
        endDateTextField.addTarget(self, action: #selector(setEndDatePicker), for: .touchDown)
        startDateStackView.addArrangedSubview(createLabel(text: "시작일:"))
        startDateTextField.snp.makeConstraints { make in
            make.width.equalTo(ButtonSize.medium.rawValue)
            make.height.equalTo(30)
        }
        startDateTextField.inputView = startDatePicker
        startDateTextField.inputAccessoryView = addInputAccessoryView(datePickerState: .start)
        startDateStackView.addArrangedSubview(startDateTextField)
        endDateTextField.snp.makeConstraints { make in
            make.width.equalTo(ButtonSize.medium.rawValue)
            make.height.equalTo(30)
        }
        endDateTextField.inputView = endDatePicker
        endDateTextField.inputAccessoryView = addInputAccessoryView(datePickerState: .end)
        endDateStackView.addArrangedSubview(createLabel(text: "종료일:"))
        endDateStackView.addArrangedSubview(endDateTextField)
    }
    
    @objc
    func setEndDatePicker() {
        endDateTextField.text = endDatePicker.date.dateToString
        endDateTextField.backgroundColor = .mainColor
        endDateTextField.textColor = .black
    }
    
    private func notificationStackViewSetting() {
        notificationStackView.addArrangedSubview(createLabel(text: "알림 시간:"))
        let notificationButton = createButton(type: .disable, size: .medium)
        notificationStackView.addArrangedSubview(notificationDatePicker)
        notificationStackView.addSubview(notificationButton)
        notificationStackView.sendSubviewToBack(notificationDatePicker)
        notificationButton.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalTo(notificationDatePicker)
        }
        notificationDatePicker.snp.makeConstraints { make in
            make.width.equalTo(ButtonSize.medium.rawValue)
            make.height.equalTo(30)
        }
        notificationDatePicker.addTarget(self, action: #selector(notificationPicker), for: .valueChanged)
    }
    
    private func typeStackViewSetting() {
        typeStackView.addArrangedSubview(createLabel(text: "타입"))
        let buttonTextList = RoutineType.allCases
        buttonTextList.forEach({ buttonType in
            let button = createButton(type: .disable, size: .small)
            button.setTitle(buttonType.rawValue, for: .normal)
            button.setTitleColor(.black, for: .selected)
            button.addTarget(self, action: #selector(typeButtonClick), for: .touchUpInside)
            if buttonType == .count {
                button.addTarget(self, action: #selector(goalAreaVisible), for: .touchUpInside)
            } else {
                button.addTarget(self, action: #selector(goalAreaHidden), for: .touchUpInside)
            }
            button.addTarget(self, action: #selector(doneButtonEnableSwitch), for: .touchUpInside)
            typeStackView.addArrangedSubview(button)
        })
        let typeButtonList = typeStackView.arrangedSubviews.compactMap { $0 as? UIButton }
        guard let checkButton = typeButtonList.first else { return }
        checkButton.isSelected = true
        checkButton.backgroundColor = .mainColor
    }
    
    private func createLabel(text: String) -> UILabel {
        let dateLabel = UILabel()
        dateLabel.font = .systemFont(ofSize: 15, weight: .regular)
        dateLabel.text = text
        dateLabel.textAlignment = .right
        dateLabel.snp.makeConstraints { make in
            make.width.equalTo(78)
        }
        return dateLabel
    }
        
    enum ButtonSize: CGFloat {
        case medium = 142
        case small = 70
    }
    
    enum ButtonType {
        case nomarl
        case disable
    }
    
    private func createButton(type: ButtonType, size: ButtonSize) -> UIButton {
        let button = UIButton()
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .regular)
        switch type {
        case .nomarl:
            button.setTitle(Date().dateToString, for: .normal)
            button.setTitleColor(.black, for: .normal)
        case .disable:
            button.setTitle("설정 안함", for: .normal)
            button.setTitleColor(.white, for: .normal)
        }
        
        button.snp.makeConstraints { make in
            make.width.equalTo(size.rawValue)
            make.height.equalTo(30)
        }
        button.clipsToBounds = true
        button.layer.cornerRadius = 5
        button.backgroundColor = .secondaryColor
        return button
    }
    
    enum DatePickerState {
        case start, end
    }
    
    func addInputAccessoryView(datePickerState: DatePickerState) -> UIView {
        let width = UIScreen.main.bounds.width
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: width, height: 44.0))
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        switch datePickerState {
        case .start:
            let barButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(startDatePickerDone))
            toolBar.setItems([flexible, barButton], animated: false)
        case .end:
            let barButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(endDatePickerDone))
            let noSettingButton = UIBarButtonItem(title: "설정안함", style: .plain, target: self, action: #selector(noSetting))
            toolBar.setItems([noSettingButton, flexible, barButton], animated: false)
        }
        return toolBar
        
    }
    
    @objc
    func startDatePickerDone() {
        view.endEditing(true)
    }
    
    @objc
    func endDatePickerDone() {
        view.endEditing(true)
        endDateTextField.backgroundColor = .mainColor
        endDateTextField.textColor = .black
    }
    
    @objc
    func noSetting() {
        endDateTextField.textColor = .white
        endDateTextField.text = "설정안함"
        endDateTextField.backgroundColor = .secondaryColor
        endDateTextField.resignFirstResponder()
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        guard let userInfo: NSDictionary = notification.userInfo as? NSDictionary else {
                return
        }
        guard let keyboardFrame = userInfo.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as? NSValue else {
            return
        }
        
        let keyboardHeight = keyboardFrame.cgRectValue.height
        doneButton.snp.updateConstraints { make in
            make.bottom.equalToSuperview().inset(keyboardHeight)
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        doneButton.snp.updateConstraints { make in
            make.bottom.equalToSuperview()
        }
    }
    
    private func textFieldSetting() {
        routineTextField.addTarget(self, action: #selector(routineNameChange), for: .editingChanged)
        goalTextField.delegate = self
    }
    
    private func buttonSetting() {
        doneButton.addTarget(self, action: #selector(doneButtonClick), for: .touchUpInside)
    }
    
    @objc
    func doneButtonClick() {
        if let routine = self.routine {
            let afterDescription = routine.description
            guard let updateRoutine = updateRoutine() else { return }
            updateNotification(routine: updateRoutine)
            RoutineManager.update(updateRoutine)
            dismiss(animated: true)
            return
        }
        guard let newRoutine = createRoutine() else {
            //TODO: 루틴 텍스트를 작성하지 않은 경우 에러 처리
            print("routine is nil")
            return
        }
        RoutineManager.create(newRoutine)
        addNotification(routine: newRoutine)
        dismiss(animated: true)
    }
    
    func createRoutine() -> Routine? {
        guard let description = routineTextField.text else { return nil }
        let dayOfWeeks = selectedDayOfWeeks()
        let startDate = fetchDate(to: startDateStackView) ?? Date()
        let endDate = fetchDate(to: endDateStackView)
        let notificationTime = selectedNotificationTime()
        let type = selectedType()
        switch type {
        case .check:
            return CheckRoutine(description: description, dayOfWeek: dayOfWeeks, startDate: startDate, endDate: endDate, notificationTime: notificationTime)
        case .text:
            return TextRoutine(description: description, dayOfWeek: dayOfWeeks, startDate: startDate, endDate: endDate, notificationTime: notificationTime)
        case .count:
            guard let goal = fetchGoal() else { return nil }
            return CountRoutine(description: description, dayOfWeek: dayOfWeeks, startDate: startDate, endDate: endDate, notificationTime: notificationTime, goal: goal)
        }
    }
    
    func updateRoutine() -> Routine? {
        guard var routine = routine,
              let description = routineTextField.text else { return nil }
        let dayOfWeeks = selectedDayOfWeeks()
        let startDate = fetchDate(to: startDateStackView) ?? Date()
        let endDate = fetchDate(to: endDateStackView)
        let notificationTime = selectedNotificationTime()
        routine.description = description
        routine.dayOfWeek = dayOfWeeks
        routine.startDate = startDate
        routine.endDate = endDate
        routine.notificationTime = notificationTime
        return routine
    }
    
    private func addNotification(routine: Routine) {
        let requestList = routine.notification()
        requestList.forEach { request in
            UNUserNotificationCenter.current().add(request) { error in
                if let error {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    private func removeNotification(routine: Routine) {
        let notificationCenter = UNUserNotificationCenter.current()
        let allDayOfWeek = DayOfWeek.allCases
        var identifiers = [String]()
        for index in 0..<allDayOfWeek.count where routine.dayOfWeek.contains(allDayOfWeek[index]) {
            identifiers.append(routine.identifier.uuidString + String(index + 1))
        }
        notificationCenter.removePendingNotificationRequests(withIdentifiers: identifiers)
    }
    
    private func updateNotification(routine: Routine) {
        removeNotification(routine: routine)
        addNotification(routine: routine)
    }
    
    private func selectedDayOfWeeks() -> [DayOfWeek] {
        var dayOfWeeks: [DayOfWeek] = []
        let selectedCircleView = workDailyStackView.arrangedSubviews
            .compactMap { $0 as? CircleTextView }
            .filter { $0.isSelected }
        selectedCircleView.forEach { view in
            dayOfWeeks.append(view.dayOfWeek)
        }
        return dayOfWeeks
    }
    
    private func notificationSwitchSetting() {
        notificationSwitch.addTarget(self, action: #selector(switchChange), for: .valueChanged)
    }
    
    private func fetchDate(to stackView: UIStackView) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일"
        if let dateTextField = stackView.arrangedSubviews.compactMap({ $0 as? UITextField }).first,
           let dateString = dateTextField.text {
            let gmtDate = formatter.date(from: dateString)
            guard let gmtDate = gmtDate else { return nil }
            let secondsFromGMT = TimeZone.autoupdatingCurrent.secondsFromGMT(for: gmtDate)
            guard let localizedDate = gmtDate.addingTimeInterval(TimeInterval(secondsFromGMT)).removeTimeStamp else { return nil }
            return localizedDate
        }
        return nil
    }
    
    private func selectedNotificationTime() -> Date? {
        guard notificationSwitch.isOn else { return nil }
        return notificationDatePicker.date
    }
    
    private func selectedType() -> RoutineType {
        let selectedButton = typeStackView.arrangedSubviews
            .compactMap { $0 as? UIButton }
            .first(where: { $0.isSelected })
        guard let title = selectedButton?.title(for: .selected),
              let type = RoutineType(rawValue: title) else { return RoutineType.check }
        return type
    }
    
    private func unSelectAllTypeButton() {
        let typeButtonList = typeStackView.arrangedSubviews.compactMap({ $0 as? UIButton })
        typeButtonList.forEach { button in
            button.isSelected = false
            button.backgroundColor = .secondaryColor
        }
    }
    
    // tag 1: StartDatePicker, tag 2: EndDatePicker
    @objc
    func dateFormatting(datePicker: UIDatePicker) {
        var textField = UITextField()
        if datePicker.tag == 1 {
            if startDatePicker.date > endDatePicker.date {
                let alert = UIAlertController(title: nil, message: "시작일과 종료일이 올바르지 않게 입력되었습니다.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "확인", style: .default)
                alert.addAction(okAction)
                present(alert, animated: false)
                startDatePicker.date = endDatePicker.date
                startDateTextField.text = endDatePicker.date.dateToString
                return
            }
            textField = startDateTextField
            textField.text = startDatePicker.date.dateToString
        } else if datePicker.tag == 2 {
            textField = endDateTextField
            if startDatePicker.date > endDatePicker.date {
                let alert = UIAlertController(title: nil, message: "시작일과 종료일이 올바르지 않게 입력되었습니다.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "확인", style: .default)
                alert.addAction(okAction)
                present(alert, animated: false)
                endDatePicker.date = startDatePicker.date
                endDateTextField.text = endDatePicker.date.dateToString
                return
            }
            textField.text = endDatePicker.date.dateToString
            textField.textColor = .black
            textField.backgroundColor = .mainColor
        }
    }
    
    @objc
    func switchChange(_ toggle: UISwitch) {
        guard let notificationButton = notificationStackView.subviews.compactMap({ $0 as? UIButton }).first else { return }
        if toggle.isOn {
            notificationStackView.bringSubviewToFront(notificationDatePicker)
            notificationDatePicker.date = Date()
            let date = Date().timeToString
            notificationButton.setTitle(date, for: .normal)
            notificationButton.backgroundColor = .mainColor
            notificationButton.setTitleColor(.black, for: .normal)
        } else {
            notificationStackView.sendSubviewToBack(notificationDatePicker)
            notificationButton.setTitle("설정 안함", for: .normal)
            notificationButton.backgroundColor = .secondaryColor
            notificationButton.setTitleColor(.white, for: .normal)
        }
    }
    
    @objc
    func notificationPicker(datePicker: UIDatePicker) {
        guard let notificationButton = notificationStackView.subviews.compactMap({ $0 as? UIButton }).first else { return }
        notificationButton.setTitle(notificationDatePicker.date.timeToString, for: .normal)
    }
    
    @objc
    func typeButtonClick(_ button: UIButton) {
        unSelectAllTypeButton()
        button.backgroundColor = .mainColor
        button.isSelected = true
    }
    
    @objc
    func goalAreaVisible() {
        self.goalLabel.isHidden = false
        self.goalTextField.isHidden = false
    }
    
    @objc
    func goalAreaHidden() {
        goalLabel.isHidden = true
        goalTextField.isHidden = true
    }
    
    func fetchGoal() -> Int? {
        guard let text = goalTextField.text,
              let textFieldGoal = Int(text) else { return nil }
        return textFieldGoal
    }
    
    @objc
    func doneButtonEnableSwitch() {
        let type = selectedType()
        guard let routinName = routineTextField.text,
              let goalText = goalTextField.text else { return }
        if false == routinName.isEmpty && type == .count && false == goalText.isEmpty {
            doneButton.isEnabled = true
            doneButton.backgroundColor = .mainColor
        } else if false == routinName.isEmpty && type == .count && goalText.isEmpty {
            doneButton.isEnabled = false
            doneButton.backgroundColor = .systemGray4
        } else if false == routinName.isEmpty {
            doneButton.isEnabled = true
            doneButton.backgroundColor = .mainColor
        } else {
            doneButton.isEnabled = false
            doneButton.backgroundColor = .systemGray4
        }
    }
    
    @objc
    func routineNameChange(_ textField: UITextField) {
        doneButtonEnableSwitch()
    }
}

extension CreateRoutineViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if range.location == 0 && string == "0" { return false }
        let set = NSCharacterSet(charactersIn: "0123456789").inverted
        var compSepByCharInSet = string.components(separatedBy: set)
        let numberFiltered = compSepByCharInSet.joined()
        return string == numberFiltered
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        doneButtonEnableSwitch()
    }
}
