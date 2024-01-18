//
//  AlarmViewController.swift
//  HomeFeature
//
//  Created by 박소윤 on 2024/01/17.
//  Copyright © 2024 AB. All rights reserved.
//

import Foundation
import UIKit
import ABKit
import FeatureDependency
import Domain
import Combine

final class AlarmViewController: BaseViewController<NavigateHeaderView, AlarmView, DefaultHomeCoordinator> {
    
    init() {
        super.init(headerView: NavigateHeaderView(title: "알림"), mainView: AlarmView())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let alarmTypeSubject: CurrentValueSubject<Alarm.Subject, Never> = CurrentValueSubject(.topicVote)
    
    override func initialize() {
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        
        mainView.typeCells.forEach{
            $0.isUserInteractionEnabled = true
            $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(typeTap)))
        }
    }
    
    @objc private func typeTap(_ recognizer: UITapGestureRecognizer) {
        guard let cell = recognizer.view as? AlarmView.AlarmTypeCell else { return }
        mainView.currentTypeCell = cell
        alarmTypeSubject.send(cell.type)
    }
    
    override func bind() {

    }
}

extension AlarmViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: AlarmListTableViewCell.self)
        cell.fill(.init(isNew: true, type: .breakThrough, title: "", subtitle: ""))
        return cell
    }
}
