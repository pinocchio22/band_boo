//
//  MainTabBarController.swift
//  band_memo
//
//  Created by t2023-m0056 on 2023/08/02.
//

import UIKit

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.delegate = self

        tabBarController?.tabBar.items![0].title = "hello"
        
        // Do any additional setup after loading the view.
    }
//     // 탭바 이동
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        print(tabBarController?.selectedIndex)
        performSegue(withIdentifier: "ShowEditMemo", sender: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
