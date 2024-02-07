//
//  SideAViewController.swift
//  SideAFeature
//
//  Created by 박소윤 on 2024/02/05.
//  Copyright © 2024 AB. All rights reserved.
//

import Foundation
import UIKit
import ABKit
import FeatureDependency
import Domain

final class SideAViewController: BaseViewController<SideTabHeaderView, SideAView, DefaultSideACoordinator> {
    
    init(){
        super.init(headerView: SideTabHeaderView(icon: Image.sideAHeader), mainView: SideAView())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func initialize() {
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
    }
}

extension SideAViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: SideATopicTableViewCell.self)
        cell.delegate = self
        cell.fill(topic: .init(
            topic: .init(
                id: 0,
                side: .A,
                title: "10년 전 또는 후로 갈 수 있다면?",
                deadline: nil,
                voteCount: 100,
                commentCount: 100,
                keyword: .init(id: 0, name: "", topicSide: .A),
                choices: [.init(id: 0, content: .init(text: "10년 전 과거로 가기", imageURL: nil), option: .A),
                          .init(id: 0, content: .init(text: "10년 후로 가기", imageURL: nil), option: .B)],
                author: nil,
                selectedOption: nil))
        )
        return cell
    }
}

extension SideAViewController: VoteDelegate {
    func vote(_ option: Choice.Option) {
        print(option)
    }
}
