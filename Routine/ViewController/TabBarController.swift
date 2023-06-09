//
//  MainViewController.swift
//  Routine
//
//  Created by 김도현 on 2023/01/10.
//

import UIKit

final class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarSetting()
        viewControllerSetting()
    }
    
    private func tabBarSetting() {
        self.tabBar.backgroundColor = .white
        self.modalPresentationStyle = .fullScreen
        self.tabBar.unselectedItemTintColor = .systemGray
        self.tabBar.tintColor = UIColor.mainColor
    }
    
    private func viewControllerSetting() {
        let vc1 = UINavigationController(rootViewController: ListViewController(viewModel: ListViewModel()))
        let vc2 = UINavigationController(rootViewController: MyRoutineViewController())
        let vc3 = UINavigationController(rootViewController: SettingViewController())

        vc1.title = "목록"
        vc2.tabBarItem.title = "나의 루틴"
        vc3.title = "설정"

        self.setViewControllers([vc1, vc2, vc3], animated: false)
        
        guard let items = self.tabBar.items else { return }
        
        let images = ["list.bullet", "person.fill", "gearshape.fill"]
        
        for index in 0..<items.count {
            items[index].image = UIImage(systemName: images[index])
        }
    }
}
