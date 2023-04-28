//
//  UITaskTableViewCell.swift
//  Routine
//
//  Created by 김도현 on 2023/03/21.
//

import UIKit

class UITaskTableViewCell: UITableViewCell {
    
    private let checkBox: UIImageView = {
        let image = UIImage(systemName: "checkmark.square")
        let imageView = UIImageView(image: image)
        imageView.tintColor = .mainColor
        return imageView
    }()
    
    private let routineButton: UIButton = {
        let button = UIButton()
        button.setTitle("루틴 이름", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(UIColor.black, for: .normal)
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.black.cgColor
        return button
    }()
    
    weak var delegate: RoutineDelegate? = nil
    
    var isCheck: Bool = false {
        didSet {
            DispatchQueue.main.async {
                if self.isCheck {
                    self.checkBox.image = UIImage(systemName: "checkmark.square.fill")
                    self.checkBox.snp.updateConstraints { make in
                        make.width.height.equalTo(32)
                    }
                } else {
                    self.checkBox.image = UIImage(systemName: "checkmark.square")
                    self.checkBox.snp.updateConstraints { make in
                        make.width.height.equalTo(0)
                    }
                }
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
