//
//  CountRoutineTableViewCell.swift
//  Routine
//
//  Created by 김도현 on 2023/02/14.
//

import UIKit

class CountRoutineTableViewCell: UITableViewCell {
        
    var routineCountTask: RoutineCountTask? = nil {
        didSet {
            routineButton.setTitle(routineCountTask?.description, for: .normal)
            guard let isDone = routineCountTask?.isDone else { return }
            isDone ? setAll(color: UIColor.systemGray) : setAll(color: UIColor.black)
        }
    }
    
    private let routineButton: UIButton = {
        let button = UIButton()
        button.setTitle("루틴 이름", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(UIColor.black, for: .normal)
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.black.cgColor
        return button
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textAlignment = .center
        label.text = "0"
        return label
    }()
    
    private let plusButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.black.cgColor
        button.tintColor = .black
        return button
    }()
    
    private let minusButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "minus"), for: .normal)
        button.tintColor = .black
        return button
    }()
        
    private var plusTimer: Timer? = nil
    private var minusTimer: Timer? = nil
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        viewAdd()
        autolayoutSetting()
        actionSetting()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func viewAdd() {
        contentView.addSubview(routineButton)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(plusButton)
        contentView.addSubview(minusButton)
    }
    
    private func autolayoutSetting() {
        routineButton.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalTo(routineButton.snp.trailing)
            make.width.equalTo(plusButton.snp.height)
        }
        
        plusButton.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalTo(descriptionLabel.snp.trailing)
            make.height.width.equalTo(56).priority(999)
        }
        
        minusButton.snp.makeConstraints { make in
            make.top.trailing.bottom.height.equalToSuperview()
            make.leading.equalTo(plusButton.snp.trailing)
            make.height.width.equalTo(plusButton.snp.height)
        }
    }
    
    private func actionSetting() {
        let plusLongPress = UILongPressGestureRecognizer(target: self, action: #selector(plusLongPress))
        plusLongPress.minimumPressDuration = 1.5
        let minusLongPress = UILongPressGestureRecognizer(target: self, action: #selector(minusLongPress))
        minusLongPress.minimumPressDuration = 1.5
        plusButton.addTarget(self, action: #selector(countIncrease), for: .touchUpInside)
        plusButton.addGestureRecognizer(plusLongPress)
        minusButton.addTarget(self, action: #selector(countDecrease), for: .touchUpInside)
        minusButton.addGestureRecognizer(minusLongPress)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setAll(color: UIColor) {
        DispatchQueue.main.async {
            self.routineButton.layer.borderColor = color.cgColor
            self.routineButton.setTitleColor(color, for: .normal)
            self.descriptionLabel.layer.borderColor = color.cgColor
            self.descriptionLabel.textColor = color
            self.plusButton.layer.borderColor = color.cgColor
            self.plusButton.tintColor = color
            self.minusButton.layer.borderColor = color.cgColor
            self.minusButton.tintColor = color
            self.layer.borderColor = color.cgColor
        }
    }
    
    @objc
    func plusLongPress(recognizer: UILongPressGestureRecognizer) {
        switch recognizer.state {
        case .began:
            plusTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(countIncrease), userInfo: nil, repeats: true)
        case .ended:
            guard let plusTimer = plusTimer else { return }
            plusTimer.invalidate()
        default:
            break
        }
    }
    
    @objc
    func countIncrease() {
        routineCountTask?.count += 1
        guard let count = routineCountTask?.count,
              let goal = routineCountTask?.goal else { return }
        DispatchQueue.main.async {
            if goal <= count {
                self.descriptionLabel.textColor = .mainColor
//                self.allBorderColor(color: UIColor.mainColor.cgColor)
                self.routineCountTask?.isDone = true
            }
            self.descriptionLabel.text = "\(count)"
        }
    }

    @objc
    func minusLongPress(recognizer: UILongPressGestureRecognizer) {
        switch recognizer.state {
        case .began:
            minusTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(countDecrease), userInfo: nil, repeats: true)
        case .ended:
            guard let minusTimer = minusTimer else { return }
            minusTimer.invalidate()
        default:
            break
        }
    }
    
    @objc
    func countDecrease() {
        if routineCountTask?.count == 0 { return }
        routineCountTask?.count -= 1
        guard let count = routineCountTask?.count,
              let goal = routineCountTask?.goal else { return }
        DispatchQueue.main.async {
            if goal > count {
                self.descriptionLabel.textColor = .black
                self.routineCountTask?.isDone = false

            }
            self.descriptionLabel.text = "\(count)"
        }
    }
}
