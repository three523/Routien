//
//  TextAddViewController.swift
//  Routine
//
//  Created by 김도현 on 2023/02/14.
//

import UIKit
import SnapKit

final class TextAddViewController: UIViewController {
  
    let exitButton: UIButton = {
        let btn: UIButton = UIButton()
        btn.setTitle("X", for: .normal)
        btn.backgroundColor = .white
        btn.setTitleColor(UIColor.red, for: .normal)
        return btn
    }()
    
    let todoTextView: UITextView = {
        let textView: UITextView = UITextView()
        textView.font = .systemFont(ofSize: 16)
        textView.textColor = .black
        textView.layer.cornerRadius = 10
        textView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        textView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        textView.isScrollEnabled = false
        textView.sizeToFit()
        return textView
    }()
    
    let saveButton: UIButton = {
        let btn: UIButton = UIButton()
        btn.setTitle("저장", for: .normal)
        btn.backgroundColor = UIColor.mainColor
        btn.setTitleColor(UIColor.white, for: .normal)
        return btn
    }()
    
    var textTask: RoutineTextTask? = nil
    weak var delegate: TaskAddDelegate? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray.withAlphaComponent(0.5)
        todoTextView.delegate = self
        if let text = textTask?.text {
            todoTextView.text = text
        }
        todoTextView.becomeFirstResponder()
        exitButton.addTarget(self, action: #selector(exitClick), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(saveButtonClick), for: .touchUpInside)
        viewAdd()
        autolayoutSetting()
    }
    
    func viewAdd() {
        view.addSubview(exitButton)
        view.addSubview(todoTextView)
        view.addSubview(saveButton)
    }
    
    func autolayoutSetting() {
        exitButton.snp.makeConstraints { make in
            make.height.equalTo(38)
            make.width.equalTo(38)
            make.trailing.equalToSuperview().inset(12)
            make.top.equalToSuperview().inset(12)
        }
        
        saveButton.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        saveButton.layoutIfNeeded()
        
        let textViewMaxHeight = view.bounds.height - (saveButton.bounds.height + exitButton.bounds.height)

        todoTextView.snp.makeConstraints { make in
            make.height.lessThanOrEqualTo(textViewMaxHeight)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(saveButton.snp.top)
        }
    }
    
    @objc
    func exitClick() {
        dismiss(animated: true)
    }
    
    @objc
    func saveButtonClick() {
        guard let textTask = textTask else { return }
        textTask.text = todoTextView.text
        delegate?.textTaskIsUpdate()
        dismiss(animated: true)
    }

}

extension TextAddViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let textViewMaxHeight = view.bounds.height - (saveButton.bounds.height + exitButton.bounds.height)
        let size = CGSize(width: textView.frame.width, height: .infinity)
        let textViewHeight = textView.sizeThatFits(size).height
        textView.isScrollEnabled = textViewHeight >= textViewMaxHeight
    }
}
