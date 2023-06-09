//
//  MyRoutineTableViewCell.swift
//  Routine
//
//  Created by 김도현 on 2023/04/28.
//

import UIKit
import SnapKit

final class MyRoutineTableViewCell: UITableViewCell {
    
    var routine: Routine? = nil {
        didSet {
            routineUpdate()
        }
    }
    
    private let myRoutineLabel: UILabel = {
        let lb = UILabel()
        lb.font = .systemFont(ofSize: 18, weight: .bold)
        lb.text = "test"
        lb.textAlignment = .center
        lb.layer.borderColor = UIColor.systemGray.cgColor
        lb.layer.borderWidth = 0.5
        return lb
    }()
    
    private let countLabel: UILabel = {
        let lb = UILabel()
        lb.font = .systemFont(ofSize: 18, weight: .regular)
        lb.text = "카운트: 0"
        lb.textAlignment = .center
        lb.layer.borderColor = UIColor.systemGray.cgColor
        lb.layer.borderWidth = 0.5
        return lb
    }()
    
    private let goalRateLabel: UILabel = {
        let lb = UILabel()
        lb.font = .systemFont(ofSize: 18, weight: .regular)
        lb.text = "달성률: 0%"
        lb.textAlignment = .center
        lb.layer.borderColor = UIColor.systemGray.cgColor
        lb.layer.borderWidth = 0.5
        return lb
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(myRoutineLabel)
        contentView.addSubview(countLabel)
        contentView.addSubview(goalRateLabel)
        contentView.backgroundColor = .secondaryColor
        autoLayoutSetting()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func autoLayoutSetting() {
        myRoutineLabel.snp.makeConstraints { make in
            make.leading.centerY.height.equalToSuperview()
            make.width.equalTo(contentView.snp.width).dividedBy(3)
        }
        countLabel.snp.makeConstraints { make in
            make.leading.equalTo(myRoutineLabel.snp.trailing)
            make.center.height.equalToSuperview()
            make.width.equalTo(contentView.snp.width).dividedBy(3)
        }
        goalRateLabel.snp.makeConstraints { make in
            make.trailing.centerY.height.equalToSuperview()
            make.width.equalTo(contentView.snp.width).dividedBy(3)
        }
    }
    
    private func routineUpdate() {
        guard let routine = routine else { return }
        myRoutineLabel.text = routine.title
        countLabel.text = "\(routine.doneTasks().count)회"
        goalRateLabel.text = "\(routine.goalRate())%"
    }

}
