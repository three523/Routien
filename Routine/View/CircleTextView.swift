//
//  CircleTextView.swift
//  Routine
//
//  Created by 김도현 on 2023/01/10.
//

import UIKit
import SnapKit

class CircleTextView: UIView {
    
    let dailyLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = .black
        label.text = ""
        return label
    }()
    var isToday: Bool = false {
        didSet {
            self.backgroundColor = isToday ? UIColor(hex: 0xD9D9D9) : .white.withAlphaComponent(0.0)
        }
    }
    var isSelected: Bool = true {
        didSet {
            DispatchQueue.main.async {
                if self.isSelected {
                    self.backgroundColor = .mainColor
                    self.dailyLabel.textColor = .black
                } else {
                    self.backgroundColor = .secondaryColor
                    self.dailyLabel.textColor = .white
                }
            }
        }
    }
    var dayOfWeek: DayOfWeek = .mon {
        didSet {
            dailyLabel.text = dayOfWeek.rawValue
        }
    }
    var date: Date = Date() {
        didSet {
            dailyLabel.text = String(date.day)
        }
    }
    var text: String = "" {
        didSet {
            dailyLabel.text = text
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.clipsToBounds = true
        addView()
        autoLayoutSetting()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addView() {
        self.addSubview(dailyLabel)
    }
    
    private func autoLayoutSetting() {
        dailyLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    override func draw(_ rect: CGRect) {
        layer.cornerRadius = frame.height / 2
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.isSelected = !self.isSelected
    }

}
