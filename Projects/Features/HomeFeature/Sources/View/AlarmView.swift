//
//  AlarmView.swift
//  HomeFeature
//
//  Created by 박소윤 on 2024/01/17.
//  Copyright © 2024 AB. All rights reserved.
//

import Foundation
import UIKit
import ABKit
import Domain

extension Alarm.Subject {
    var title: String {
        switch self {
        case .topicVote:     return "투표한 토픽"
        case .topicWrite:    return "작성한 토픽"
        }
    }
}

final class AlarmView: BaseView {
    
    var currentTypeCell: AlarmTypeCell?{
        willSet {
            currentTypeCell?.isSelected = false
        }
        didSet {
            currentTypeCell?.isSelected = true
        }
    }
    var typeCells: [AlarmTypeCell] {
        typeStackView.subviews.map{ $0 as! AlarmTypeCell }
    }
    private let typeStackView: UIStackView = UIStackView(axis: .horizontal, spacing: 45)

    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = Color.transparent
        tableView.separatorStyle = .none
        tableView.register(cellType: AlarmListTableViewCell.self)
        return tableView
    }()
    
    override func hierarchy() {
        Alarm.Subject.allCases.forEach{
            let cell = AlarmTypeCell(type: $0)
            cell.isSelected = false
            typeStackView.addArrangedSubview(cell)
        }
        addSubviews([typeStackView, tableView])
    }
    
    override func layout() {
        typeStackView.snp.makeConstraints{
            $0.top.equalToSuperview().offset(30)
            $0.centerX.equalToSuperview()
        }
        tableView.snp.makeConstraints{
            $0.top.equalTo(typeStackView.snp.bottom).offset(24)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    override func initialize() {
        currentTypeCell = typeCells[0]
        typeCells[0].isSelected = true
    }
}

extension AlarmView {
    
    final class AlarmTypeCell: BaseView {
        
        init(type: Alarm.Subject) {
            self.type = type
            super.init()
            titleLabel.text = type.title
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        let type: Alarm.Subject
        
        var isSelected: Bool {
            get {
                !vectorView.isHidden
            }
            set {
                vectorView.isHidden = !newValue
                titleLabel.textColor = newValue ? Color.subPurple : Color.white
            }
        }
        private let vectorView: UIView = {
            let view = UIView()
            view.backgroundColor = Color.black
            view.snp.makeConstraints{
                $0.width.equalTo(60)
                $0.height.equalTo(18)
            }
            view.transform = view.transform.rotated(by: 3)
            return view
        }()
        private let titleLabel: UILabel = {
            let label = UILabel()
            label.setTypo(Pretendard.semibold18)
            return label
        }()
        
        override func hierarchy() {
            addSubviews([vectorView, titleLabel])
        }
        
        override func layout() {
            titleLabel.snp.makeConstraints{
                $0.leading.trailing.bottom.top.equalToSuperview()
            }
            vectorView.snp.makeConstraints{
                $0.centerX.equalToSuperview()
                $0.centerY.equalToSuperview().offset(2)
            }
        }
    }
}
