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

import HomeFeatureInterface

final class CommentBottomSheetViewController: UIViewController {
    
    private var viewModel: any CommentBottomSheetViewModel
    
    init(viewModel: CommentBottomSheetViewModel){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let headerView: CommentHeaderView = CommentHeaderView()
    private let tableView: UITableView = {
        let tableView: UITableView = UITableView()
        tableView.separatorStyle = .none
        tableView.registers(cellTypes: [CommentBottomSheetTableViewCell.self])
        return tableView
    }()
    
    override func viewDidLoad() {
        hierarchy()
        layout()
        initialize()
        modalSetting()
        bind()
        viewModel.viewDidLoad()
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
        
        func detents() -> [CGFloat] {
            [Device.height-273, Device.height-52]
        }
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
        headerView.fill(viewModel.commentsCount)
    }
    
    func bind() {
        viewModel.reloadData = {
            DispatchQueue.main.async {
                self.headerView.fill(self.viewModel.commentsCount)
                self.tableView.reloadData()
            }
        }
    }
}

extension CommentBottomSheetViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: CommentBottomSheetTableViewCell.self)
        cell.fill(viewModel.comments[indexPath.row])
        return cell
    }
}

extension CommentBottomSheetViewController {
    
    final class CommentHeaderView: BaseView {
        
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
            countLabel.text = count
        }
    }
}
