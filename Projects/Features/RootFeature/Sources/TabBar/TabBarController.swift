//
//  TabBarController.swift
//  RootFeature
//
//  Created by 박소윤 on 2023/09/25.
//  Copyright © 2023 AB. All rights reserved.
//

import UIKit
import ABKit
import HomeFeature

public class TabBarController: UITabBarController{
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        style()
        setTabBarAppearance()
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setTabBarHeight()
    }
    
    private func setTabBarHeight(){
        let tabBarHeight: CGFloat = 76 + view.safeAreaInsets.bottom
        tabBar.frame.size.height = tabBarHeight
        tabBar.frame.origin.y = view.frame.height - tabBarHeight //- view.safeAreaInsets.bottom
    }
    
    private func style(){
        view.backgroundColor = .white
    }
    
    private func setTabBarAppearance() {
        tabBar.itemWidth = 30
        tabBar.backgroundColor = Color.homeBackground
        tabBar.tintColor = Color.white
        tabBar.unselectedItemTintColor = Color.white80
        tabBar.layer.cornerRadius =  35
        tabBar.layer.masksToBounds = true
    }
}
