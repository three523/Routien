//
//  DailyCollectionViewCell.swift
//  Routine
//
//  Created by 김도현 on 2023/01/10.
//

import UIKit

final class DailyCollectionViewCell: UICollectionViewCell {
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 2
        return stackView
    }()
    private let dailyLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = .black
        label.text = "월"
        return label
    }()
    private let dateCircleView: CircleTextView = CircleTextView()
    override var isSelected: Bool {
        didSet {
            isBorder = isSelected
        }
    }
    private var isBorder: Bool = false {
        didSet {
            if isBorder {
                layer.borderWidth = 1
            } else {
                layer.borderWidth = 0
            }
        }
    }
    var isToday: Bool = false {
        didSet {
            dateCircleView.isToday = isToday
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.borderColor = UIColor.mainColor.cgColor
        addView()
        autolayoutSetting()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addView() {
        addSubview(stackView)
        stackView.addArrangedSubview(dailyLabel)
        stackView.addArrangedSubview(dateCircleView)
    }
    
    private func autolayoutSetting() {
        stackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(2)
            make.leading.right.equalToSuperview().inset(10)
        }
        dateCircleView.snp.makeConstraints { make in
            make.height.width.equalTo(30)
        }
    }
    
    func setDate(date: Int) {
        guard date < 31 || date > 1 else {
            print("date range over")
            return
        }
        dateCircleView.date = "\(date)"
    }

}
