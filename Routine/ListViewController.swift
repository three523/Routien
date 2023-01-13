//
//  ListViewController.swift
//  Routine
//
//  Created by 김도현 on 2023/01/10.
//

import UIKit

final class ListViewController: UIViewController {
    
    private let dailyCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    
    private let listAddButton: UIButton = {
        let button = UIButton()
        button.setTitle("리스트 추가 +", for: .normal)
        button.backgroundColor = .mainColor
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 10, bottom: 8, right: 10)
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        return button
    }()
    
    private let filterButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "line.3.horizontal.decrease"), for: .normal)
        button.tintColor = .mainColor
        return button
    }()
    
    private let sortButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "arrow.up.arrow.down"), for: .normal)
        button.tintColor = .mainColor
        return button
    }()
    
    private let listTableView: UITableView = {
        let tableView = UITableView()
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationSetting()
        viewAdd()
        autolayoutSetting()
        collectionViewSetting()
        tableViewSetting()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dailyCollectionView.selectItem(at: IndexPath(item: 9, section: 0), animated: true, scrollPosition: .centeredHorizontally)
    }
    
    private func viewAdd() {
        view.addSubview(dailyCollectionView)
        view.addSubview(listAddButton)
        view.addSubview(filterButton)
        view.addSubview(sortButton)
        view.addSubview(listTableView)
    }
    
    private func autolayoutSetting() {
        dailyCollectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(60)
        }
        
        listAddButton.snp.makeConstraints { make in
            make.top.equalTo(dailyCollectionView.snp.bottom).inset(-14)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(12)
        }
        
        filterButton.snp.makeConstraints { make in
            make.top.equalTo(listAddButton)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(12)
            make.width.height.equalTo(32)
        }
        
        sortButton.snp.makeConstraints { make in
            make.top.equalTo(listAddButton)
            make.trailing.equalTo(filterButton.snp.leading).inset(-12)
            make.width.height.equalTo(32)
        }
        
        listTableView.snp.makeConstraints { make in
            make.top.equalTo(listAddButton.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(12)
            make.bottom.equalToSuperview()
        }
    }
    
    private func collectionViewSetting() {
        dailyCollectionView.delegate = self
        dailyCollectionView.dataSource = self
        dailyCollectionView.register(DailyCollectionViewCell.self)
        dailyCollectionView.layoutIfNeeded()
        dailyCollectionView.layer.addBorder([.top, .bottom], color: UIColor.secondaryColor, size: dailyCollectionView.contentSize, width: 1)
    }
    
    private func tableViewSetting() {
        listTableView.delegate = self
        listTableView.dataSource = self
        listTableView.register(TextRoutineTableViewCell.self)
        listTableView.register(ButtonRoutineTableViewCell.self)
        listTableView.register(CountRoutineTableViewCell.self)
        listTableView.register(TodoListTableViewCell.self)
    }

    private func navigationSetting() {
        self.navigationItem.title = "2023년 1월"
    }

}

extension ListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 31
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(DailyCollectionViewCell.self, for: indexPath)
        cell.layer.cornerRadius = 5
        cell.clipsToBounds = true
        let date = indexPath.item + 1
        if date == 10 {
            cell.isToday = true
        }
        cell.setDate(date: date)
        return cell
    }
}

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell = UITableViewCell()
        if indexPath.section % 3 == 0 {
            cell = tableView.dequeueReusableCell(TextRoutineTableViewCell.self, for: indexPath)
        } else if indexPath.section % 3 == 1 {
            cell = tableView.dequeueReusableCell(ButtonRoutineTableViewCell.self, for: indexPath)
        } else {
            cell = tableView.dequeueReusableCell(TodoListTableViewCell.self, for: indexPath)
        }
        
        cell.clipsToBounds = true
        cell.layer.cornerRadius = 5
        cell.layer.borderColor = UIColor.systemGray.cgColor
        cell.layer.borderWidth = 0.5
        return cell
    }
    
}
