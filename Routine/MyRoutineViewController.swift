//
//  MyRoutineViewController.swift
//  Routine
//
//  Created by 김도현 on 2023/04/28.
//

import UIKit
import SnapKit

class MyRoutineViewController: UIViewController {
    
    private let myRoutineTableView: UITableView = {
        let tb = UITableView()
        tb.rowHeight = 80
        return tb
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "나의 루틴"
        view.addSubview(myRoutineTableView)
        autoLayoutSetting()
        tableViewSetting()
    }
    
    private func autoLayoutSetting() {
        myRoutineTableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.bottom.equalToSuperview().inset(16)
        }
    }
    
    private func tableViewSetting() {
        myRoutineTableView.register(MyRoutineTableViewCell.self)
        myRoutineTableView.delegate = self
        myRoutineTableView.dataSource = self
        RoutineManager.arrayViewUpdates.append(myRoutineTableView.reloadData)
    }
}

extension MyRoutineViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return RoutineManager.routines.count
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
        return 16
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let routine = RoutineManager.routines[indexPath.section]
        let myRoutineCell = tableView.dequeueReusableCell(MyRoutineTableViewCell.self, for: indexPath)
        myRoutineCell.layer.borderWidth = 0.5
        myRoutineCell.layer.borderColor = UIColor.systemGray.cgColor
        myRoutineCell.layer.cornerRadius = 5
        myRoutineCell.clipsToBounds = true
        myRoutineCell.routine = routine
        return myRoutineCell
    }
    
}
