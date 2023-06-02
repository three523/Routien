//
//  SortViewController.swift
//  Routine
//
//  Created by 김도현 on 2023/05/23.
//

import UIKit
import SnapKit

protocol TabbarHiddenDelegate: AnyObject {
    func tabbarHidden(isHidden: Bool)
}

final class SortAndFilterViewController: UIViewController {
    
    private let backgroundView: UIView = UIView()
    private let sortAndFilterTableView: UITableView = {
        let tableView = UITableView()
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = 50
        tableView.layer.cornerRadius = 10
        return tableView
    }()
    private let sortTypes: [SortType] = SortType.allCases
    private let filterTypes: [FilterType] = FilterType.allCases
    var isSort: Bool = true
    
    weak var delegate: TabbarHiddenDelegate? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewAdd()
        autoLayoutSetting()
        tableViewSetting()
        delegate?.tabbarHidden(isHidden: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        delegate?.tabbarHidden(isHidden: false)
    }
    
    private func viewAdd() {
        view.addSubview(backgroundView)
        view.addSubview(sortAndFilterTableView)
        let gesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTap))
        backgroundView.backgroundColor = .gray.withAlphaComponent(0.4)
        backgroundView.addGestureRecognizer(gesture)
    }
    
    private func autoLayoutSetting() {
        backgroundView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
        
        var safeAreaBottomHeight: CGFloat = 0
        if let window = UIApplication.shared.windows.first {
            safeAreaBottomHeight = window.safeAreaInsets.bottom
        }
        sortAndFilterTableView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            if isSort {
                make.height.equalTo(sortAndFilterTableView.rowHeight * CGFloat(sortTypes.count) + safeAreaBottomHeight)
            } else {
                make.height.equalTo(sortAndFilterTableView.rowHeight * CGFloat(filterTypes.count) + safeAreaBottomHeight)
            }
        }
    }
    
    private func tableViewSetting() {
        sortAndFilterTableView.delegate = self
        sortAndFilterTableView.dataSource = self
        sortAndFilterTableView.register(SortAndFilterTableViewCell.self)
    }
    
    @objc
    func backgroundTap() {
        dismiss(animated: true)
    }

}

extension SortAndFilterViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSort ? sortTypes.count : filterTypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(SortAndFilterTableViewCell.self, for: indexPath)
        if isSort {
            cell.sortType = sortTypes[indexPath.row]
        } else {
            cell.filterType = filterTypes[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true)
    }
}
