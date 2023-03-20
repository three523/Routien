//
//  TextRoutineTableViewCell.swift
//  Routine
//
//  Created by 김도현 on 2023/01/12.
//

import UIKit

class TextRoutineTableViewCell: UITableViewCell {
    
    private let routineButton: UIButton = {
        let button = UIButton()
        button.setTitle("루틴 이름", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(UIColor.black, for: .normal)
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.systemGray.cgColor
        return button
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textAlignment = .center
        label.text = "상세 내용"
        return label
    }()
    
    weak var delegate: PresentTextProtocol? = nil
    
    var routineTextTask: RoutineTextTask? = nil {
        didSet {
            routineButton.setTitle(routineTextTask?.description, for: .normal)
            if false == routineTextTask?.text.isEmpty {
                routineTextTask?.isDone = true
                DispatchQueue.main.async {
                    self.descriptionLabel.text = self.routineTextTask?.text
                }
            } else {
                DispatchQueue.main.async {
                    self.descriptionLabel.text = "상세 내용"
                }
            }
            guard let isDone = routineTextTask?.isDone else { return }
            isDone ? setAll(color: UIColor.systemGray) : setAll(color: UIColor.black)
        }
    }
    
    var text: String = "" {
        didSet {
            if false == text.isEmpty { descriptionLabel.text = text }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        viewAdd()
        autolayoutSetting()
        actionSetting()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func viewAdd() {
        contentView.addSubview(routineButton)
        contentView.addSubview(descriptionLabel)
    }
    
    func autolayoutSetting() {
        routineButton.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview()
            make.width.equalToSuperview().dividedBy(3)
            make.height.equalTo(56).priority(999)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.trailing.bottom.equalToSuperview()
            make.leading.equalTo(routineButton.snp.trailing)
        }
        
    }
    
    func actionSetting() {
        descriptionLabel.isUserInteractionEnabled = true
        let descriptionTap = UITapGestureRecognizer(target: self, action: #selector(descriptionTap))
        descriptionLabel.addGestureRecognizer(descriptionTap)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setAll(color: UIColor) {
        DispatchQueue.main.async {
            self.routineButton.setTitleColor(color, for: .normal)
            self.routineButton.layer.borderColor = color.cgColor
            self.descriptionLabel.textColor = color
            self.descriptionLabel.layer.borderColor = color.cgColor
            self.layer.borderColor = color.cgColor
        }
    }
    
    @objc
    func descriptionTap() {
        guard let delegate = delegate,
            let routineTextTask = routineTextTask else { return }
        delegate.excute(task: routineTextTask)
    }

}
