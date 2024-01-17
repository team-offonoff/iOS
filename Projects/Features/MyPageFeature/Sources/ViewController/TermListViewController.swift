//
//  TermListViewController.swift
//  MyPageFeature
//
//  Created by 박소윤 on 2024/01/16.
//  Copyright © 2024 AB. All rights reserved.
//

import Foundation
import UIKit
import ABKit
import FeatureDependency

final class TermListViewController: BaseViewController<NavigateHeaderView, TermListView, DefaultMyPageCoordinator> {
    
    init() {
        super.init(headerView: NavigateHeaderView(title: "약관"), mainView: TermListView())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func initialize() {
        mainView.termCells.forEach{
            $0.isUserInteractionEnabled = true
            $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showTermDetail)))
        }
    }
    
    @objc private func showTermDetail(_ recognizer: UITapGestureRecognizer) {
        guard let view = recognizer.view as? TermListView.TermMoveCell else { return }
        //term에 노션 링크 데이터 삽입 + view.term에 접근하여 노션 링크 열기
    }
    
}
