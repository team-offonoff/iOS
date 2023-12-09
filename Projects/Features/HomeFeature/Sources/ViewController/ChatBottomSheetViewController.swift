//
//  ChatBottomSheetViewController.swift
//  HomeFeature
//
//  Created by 박소윤 on 2023/12/08.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation
import UIKit
import ABKit

final class ChatBottomSheetViewController: UIViewController {
    
    init(){
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let headerView: ChatHeaderView = ChatHeaderView()
    private let tableView: UITableView = {
        let tableView: UITableView = UITableView()
        tableView.separatorStyle = .none
        tableView.registers(cellTypes: [ChatBottomSheetTableViewCell.self])
        return tableView
    }()
    
    override func viewDidLoad() {
        hierarchy()
        layout()
        initialize()
        modalSetting()
    }
    
    private func modalSetting(){
        
        guard let sheetPresentationController = sheetPresentationController else { return }

        sheetPresentationController.prefersGrabberVisible = true
        sheetPresentationController.detents = detents().map{ detent in
            UISheetPresentationController.Detent.custom(resolver: { _ in
                return detent
            })
        }
        sheetPresentationController.prefersScrollingExpandsWhenScrolledToEdge = false
        
        loadViewIfNeeded()
    }

    func hierarchy() {
        view.addSubviews([headerView, tableView])
    }
    
    func layout() {
        headerView.snp.makeConstraints{
            $0.top.leading.trailing.equalToSuperview()
        }
        tableView.snp.makeConstraints{
            $0.top.equalTo(headerView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func initialize() {
        tableView.delegate = self
        tableView.dataSource = self
        headerView.fill("")
    }
    
    func detents() -> [CGFloat] {
        [Device.height-273, Device.height-52]
    }
}

extension ChatBottomSheetViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: ChatBottomSheetTableViewCell.self)
        cell.fill()
        return cell
    }
}

extension ChatBottomSheetViewController {
    
    final class ChatHeaderView: BaseView {
        
        private let countStackView: UIStackView = UIStackView(axis: .horizontal, spacing: 1)
        private let countLabel: UILabel = {
            let label = UILabel()
            label.textColor = Color.black
            label.setTypo(Pretendard.semibold18)
            return label
        }()
        private let explainLabel: UILabel = {
            let label = UILabel()
            label.text = "의 댓글"
            label.textColor = Color.black40
            label.setTypo(Pretendard.semibold18)
            return label
        }()
        
        override func style() {
            backgroundColor = .white
        }
        
        override func hierarchy() {
            addSubviews([countStackView])
            countStackView.addArrangedSubviews([countLabel, explainLabel])
        }
        
        override func layout() {
            countStackView.snp.makeConstraints{
                $0.top.equalToSuperview().offset(38)
                $0.leading.equalToSuperview().offset(20)
                $0.bottom.equalToSuperview().inset(20)
            }
        }
        
        func fill(_ count: String) {
            countLabel.text = "1천 개"
        }
    }
}
