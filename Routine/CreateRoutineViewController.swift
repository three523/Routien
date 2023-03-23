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

final class CreateRoutineViewController: UIViewController {
    
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
    
    private let endDateStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 12
        return stackView
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
        startDateStackView.addArrangedSubview(createLabel(text: "시작일:"))
        startDateStackView.addArrangedSubview(createButton(type: .nomarl, size: .medium))
        endDateStackView.addArrangedSubview(createLabel(text: "종료일:"))
        endDateStackView.addArrangedSubview(createButton(type: .disable, size: .medium))
    }
    
    private func notificationStackViewSetting() {
        notificationStackView.addArrangedSubview(createLabel(text: "알림 시간:"))
        notificationStackView.addArrangedSubview(createButton(type: .disable, size: .small))
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
    
    @objc func keyboardWillShow(_ notification: Notification) {
        guard let userInfo: NSDictionary = notification.userInfo as? NSDictionary else {
                return
        }
        guard let keyboardFrame = userInfo.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as? NSValue else {
            return
        }
        
        let keyboardHeight = keyboardFrame.cgRectValue.height
        doneButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(keyboardHeight)
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        doneButton.snp.makeConstraints { make in
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
        if self.routine != nil {
            guard let updateRoutine = updateRoutine() else { return }
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
        let type = selectedType()
        routine.description = description
        routine.dayOfWeek = dayOfWeeks
        routine.startDate = startDate
        routine.endDate = endDate
        routine.notificationTime = notificationTime
        return routine
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
        formatter.dateFormat = "yyyy년MM월dd일"
        var date: Date?
        if let dateButton = stackView.arrangedSubviews.compactMap({ $0 as? UIButton }).first,
           let dateString = dateButton.title(for: .normal) {
            date = formatter.date(from: dateString)
        }
        return date
    }
    
    private func selectedNotificationTime() -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        var date: Date?
        if let dateButton = notificationStackView.arrangedSubviews.compactMap({ $0 as? UIButton }).first,
           let dateString = dateButton.title(for: .normal) {
            date = formatter.date(from: dateString)
        }
        return date
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
    
    @objc
    func switchChange(_ toggle: UISwitch) {
        guard let notificationButton = notificationStackView.arrangedSubviews.compactMap({ $0 as? UIButton }).first else { return }
        if toggle.isOn {
            notificationButton.isSelected = true
            notificationButton.setTitle(Date().timeToString, for: .normal)
            notificationButton.backgroundColor = .mainColor
        } else {
            notificationButton.isSelected = false
            notificationButton.setTitle("설정 안함", for: .normal)
            notificationButton.backgroundColor = .secondaryColor
        }
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
