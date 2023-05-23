//
//  SortAndFilterTableViewCell.swift
//  Routine
//
//  Created by 김도현 on 2023/05/23.
//

import UIKit
import SnapKit

class SortAndFilterTableViewCell: UITableViewCell {
    
    private let checkMarkImageView: UIImageView = {
        let imgView = UIImageView(image: UIImage(systemName: "checkmark"))
        imgView.tintColor = .mainColor
        return imgView
    }()
    private let titleLabel: UILabel = {
        let lb = UILabel()
        lb.font = .systemFont(ofSize: 16, weight: .medium)
        return lb
    }()
    var sortType: SortType? = nil {
        didSet {
            guard let sortType = sortType else { return }
            titleLabel.text = sortType.rawValue
        }
    }
    var filterType: FilterType? = nil {
        didSet {
            guard let filterType = filterType else { return }
            titleLabel.text = filterType.rawValue
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        viewAdd()
        autoLayoutSetting()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func viewAdd() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(checkMarkImageView)
    }
    
    private func autoLayoutSetting() {
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(12)
            make.top.bottom.equalToSuperview()
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        checkMarkImageView.snp.remakeConstraints { make in
            make.top.bottom.equalToSuperview().inset(12)
            make.trailing.equalToSuperview().inset(12)
            make.leading.equalTo(titleLabel.snp.trailing).inset(12)
            selected ? make.width.equalTo(checkMarkImageView.snp.height) : make.width.equalTo(0)
        }
        if selected {
            if let sortType {
                RoutineManager.sortType = sortType
            }
            if let filterType {
                RoutineManager.filterType = filterType
            }
        }
    }

}
