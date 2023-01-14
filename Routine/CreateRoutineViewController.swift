//
//  CreateRoutineViewController.swift
//  Routine
//
//  Created by 김도현 on 2023/01/14.
//

import UIKit

final class CreateRoutineViewController: UIViewController {
    
    let routineLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.textColor = .black
        label.text = "루틴 이름"
        return label
    }()
    
    let routineTextField: UITextField = {
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
    
    let workDailyLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.textColor = .black
        label.text = "수행 요일"
        return label
    }()
    
    let workDailyStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    let workDateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.textColor = .black
        label.text = "수행 일"
        return label
    }()
    
    let startDateStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 12
        return stackView
    }()
    
    let endDateStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 12
        return stackView
    }()
    
    let notificationLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.textColor = .black
        label.text = "알림"
        return label
    }()
    
    let notificationStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 12
        return stackView
    }()
    
    let notificationSwitch: UISwitch = {
        let toggle = UISwitch()
        toggle.onTintColor = .mainColor
        return toggle
    }()
    
    let typeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.textColor = .black
        label.text = "타입:"
        return label
    }()
    
    let typeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 12
        return stackView
    }()
    
    let doneButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .mainColor
        button.setTitle("완료", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.clipsToBounds = true
        button.layer.cornerRadius = 10
        button.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return button
    }()

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
        
        doneButton.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func dailyStackViewSetting() {
        let days = ["월", "화", "수", "목", "금", "토", "일"]
        days.forEach { day in
            let circleView = CircleTextView()
            circleView.date = day
            circleView.backgroundColor = .secondaryColor
            circleView.snp.makeConstraints { make in
                make.width.height.equalTo(36)
            }
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
        let buttonTextList = ["체크", "글", "카운트"]
        buttonTextList.forEach({ buttonText in
            let button = createButton(type: .disable, size: .small)
            button.setTitle(buttonText, for: .normal)
            typeStackView.addArrangedSubview(button)
        })
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
            button.setTitle("2023년 01월 03일", for: .normal)
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
