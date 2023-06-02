//
//  Routine
//
//  Created by 김도현 on 2023/01/12.
//

import UIKit
import RealmSwift

final class CheckRoutineTableViewCell: UITableViewCell {
    
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
    
    weak var delegate: RoutineDelegate? = nil
    let routineManager = RoutineManager.shared

    var routineCheckTask: RoutineTask? = nil {
        didSet {
            routineButton.setTitle(routineCheckTask?.title, for: .normal)
            guard let isDone = routineCheckTask?.isDone else { return }
            isDone ? setAll(color: UIColor.systemGray) : setAll(color: UIColor.black)
        }
    }
    
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
            make.width.height.equalTo(56).priority(999)
        }
    }
    
    func addAction() {
        routineButton.addTarget(self, action: #selector(routineUpdate), for: .touchUpInside)
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
        
        do {
            let realm = try Realm(configuration: .defaultConfiguration)
            try realm.write({
                routineCheckTask?.isDone = !isDone
            })
        } catch let error {
            print(error.localizedDescription)
        }
        guard let routineCheckTask = routineCheckTask else { return }
        delegate?.taskUpdate(routineTask: routineCheckTask)
        !isDone ? setAll(color: UIColor.systemGray) : setAll(color: UIColor.black)
    }
    
    @objc
    func routineUpdate() {
        guard let routineIdentifier = routineCheckTask?.routineIdentifier,
              let routine = routineManager.fetch(routineIdentifier) else { return }
        delegate?.routineUpdate(routine: routine)
    }

}
