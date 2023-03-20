//
//  ButtonRoutineTableViewCell.swift
//  Routine
//
//  Created by 김도현 on 2023/01/12.
//

import UIKit

class CheckRoutineTableViewCell: UITableViewCell {
    
    private let routineButton: UIButton = {
        let button = UIButton()
        button.setTitle("루틴 이름", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(UIColor.black, for: .normal)
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.black.cgColor
        return button
    }()
    
    private let checkButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "checkmark"), for: .normal)
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.black.cgColor
        button.tintColor = .black
        return button
    }()
    
    var routineCheckTask: RoutineCheckTask? = nil
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        viewAdd()
        autolayoutSetting()
        addAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func viewAdd() {
        contentView.addSubview(routineButton)
        contentView.addSubview(checkButton)
    }
    
    func autolayoutSetting() {
        routineButton.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview()
            make.width.equalToSuperview().dividedBy(3)
        }
        
        checkButton.snp.makeConstraints { make in
            make.top.trailing.bottom.equalToSuperview()
            make.leading.equalTo(routineButton.snp.trailing)
            make.width.height.equalTo(56)
        }
    }
    
    func addAction() {
        checkButton.addTarget(self, action: #selector(checkButtonClick), for: .touchUpInside)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setAll(color: UIColor) {
        DispatchQueue.main.async {
            self.routineButton.setTitleColor(color, for: .normal)
            self.routineButton.layer.borderColor = color.cgColor
            self.checkButton.tintColor = color
            self.checkButton.layer.borderColor = color.cgColor
            self.layer.borderColor = color.cgColor
        }
    }
    
    @objc
    func checkButtonClick() {
        guard let isDone = routineCheckTask?.isDone else { return }
        self.routineCheckTask?.isDone = !isDone
        !isDone ? setAll(color: UIColor.systemGray) : setAll(color: UIColor.black)
    }

}
