//
//  SideAView.swift
//  SideAFeature
//
//  Created by 박소윤 on 2024/02/05.
//  Copyright © 2024 AB. All rights reserved.
//

import Foundation
import UIKit
import ABKit
import FeatureDependency

final class SideAView: BaseView {
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = Color.transparent
        tableView.separatorStyle = .none
        tableView.registers(cellTypes: [SideATopicTableViewCell.self, LoadingTableViewCell.self])
        return tableView
    }()
    
    let emptyView: SideTabEmptyView = SideTabEmptyView()
    
    private let logo: UIImageView = UIImageView(image: Image.sideAbackground)
    
    override func hierarchy() {
        addSubview(logo)
        addSubview(tableView)
        addSubview(emptyView)
    }
    
    override func layout() {
        logo.snp.makeConstraints{
            $0.top.equalToSuperview().offset(64)
            $0.trailing.equalToSuperview().offset(20)
        }
        tableView.snp.makeConstraints{
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
        emptyView.snp.makeConstraints{
            $0.top.bottom.equalTo(tableView)
            $0.leading.trailing.equalToSuperview()
        }
    }
}
