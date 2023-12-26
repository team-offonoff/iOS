//
//  TopicGenerateView.swift
//  TopicFeatureDemo
//
//  Created by 박소윤 on 2023/12/25.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation
import UIKit
import ABKit

final class TopicGenerateView: BaseView {
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = Color.transparent
        tableView.registers(cellTypes: [TopicInputTableViewCell.self])
        return tableView
    }()
    
    override func hierarchy() {
        addSubview(tableView)
    }
    
    override func layout() {
        tableView.snp.makeConstraints{
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
    }
}
