//
//  TodoListTableViewCell.swift
//  Routine
//
//  Created by 김도현 on 2023/01/12.
//

import UIKit

final class TodoListTableViewCell: UITableViewCell {

    private let routineButton: UIButton = {
        let button = UIButton()
        button.setTitle("ToDo 제목", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(UIColor.black, for: .normal)
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.systemGray.cgColor
        return button
    }()
    
    private let checkButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "checkmark"), for: .normal)
        button.tintColor = .systemGray
        return button
    }()
    
    private let todo: Todo?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        self.todo = nil
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        viewAdd()
        autolayoutSetting()
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
            make.trailing.equalTo(checkButton.snp.leading)
        }
        
        checkButton.snp.makeConstraints { make in
            make.top.trailing.bottom.equalToSuperview()
            make.width.height.equalTo(56)
        }
    }

}
