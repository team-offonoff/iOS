//
//  TopicGenerateViewController.swift
//  TopicFeature
//
//  Created by 박소윤 on 2023/12/25.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation
import UIKit
import ABKit
import TopicFeatureInterface
import FeatureDependency
import Combine
import Core

final class TopicGenerateViewController: BaseViewController<BaseHeaderView, TopicGenerateView, DefaultTopicGenerateCoordinator> {

    init(viewModel: any TopicGenerateViewModel) {
        self.viewModel = viewModel
        super.init(headerView: TopicGenerateHeaderView(), mainView: TopicGenerateView())
    }
    
    private let viewModel: any TopicGenerateViewModel
    private var inputCell: TopicInputTableViewCell?
    private var contentInputCell: TopicContentInputTableViewCell?
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func initialize() {
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
    }
    
    override func bind() {
        
        viewModel.contentValidation
            .receive(on: DispatchQueue.main)
            .sink{ [weak self] isValid in
                self?.mainView.tableView.isScrollEnabled = isValid
                if isValid {
                    self?.mainView.tableView.scrollToRow(at: IndexPath(row: 1), at: .top, animated: true)
                }
            }
            .store(in: &cancellables)
        
        viewModel.canRegister
            .receive(on: DispatchQueue.main)
            .sink{ [weak self] isEnabled in
                self?.choiceContentCell()?.ctaButton.isEnabled = isEnabled
            }
            .store(in: &cancellables)
    }
    
    private func choiceContentCell() -> TopicContentInputTableViewCell? {
        mainView.tableView.cellForRow(at: IndexPath(row: 1), cellType: TopicContentInputTableViewCell.self)
    }
}

extension TopicGenerateViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:     return inputTableViewCell()
        case 1:     return contentInputTableViewCell()
        default:    fatalError()
        }
        
        func inputTableViewCell() -> UITableViewCell {
            
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: TopicInputTableViewCell.self)
            
            setGlobalProperty()
            setLimitCount()
            setDelegate()
            setInput()
            
            return cell
            
            func setGlobalProperty() {
                inputCell = cell
            }
            
            func setLimitCount() {
                cell.title.contentView.limitCount = viewModel.limitCount.title
                cell.keyword.contentView.limitCount = viewModel.limitCount.keyword
            }
            
            func setDelegate() {
                cell.recommendKeyword.collectionView.delegate = self
                cell.recommendKeyword.collectionView.dataSource = self
            }
            
            func setInput() {
                viewModel.input(content: .init(
                    titleDidEnd: cell.title.contentView.textField.publisher(for: .editingDidEnd),
                    keywordDidEnd: cell.keyword.contentView.textField.publisher(for: .editingDidEnd)
                ))
            }
        }
        
        func contentInputTableViewCell() -> UITableViewCell {
            
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: TopicContentInputTableViewCell.self)
            
            setGlobalProperty()
            setDelegate()
            setViewModel()
            
            func setGlobalProperty() {
                contentInputCell = cell
            }
            
            func setDelegate() {
                cell.delegate = self
            }
            
            func setViewModel() {
                cell.viewModel = viewModel
            }
            
            return cell
        }
    }
}

extension TopicGenerateViewController: TapDelegate {
    func tap(_ recognizer: DelegateSender) {
        
        guard let contentInputCell = contentInputCell else { return }
        
        viewModel.register(.init(
            side: viewModel.topicSide.value,
            keyword: inputCell?.keyword.contentView.textField.text ?? "",
            title: inputCell?.title.contentView.textField.text ?? "",
            choices: [
                .init(text: contentInputCell.registerText(option: .A), image: contentInputCell.registerImage(option: .A), option: .A),
                .init(text: contentInputCell.registerText(option: .B), image: contentInputCell.registerImage(option: .B), option: .B)
            ],
            deadline: UTCTime.current
        ))
    }
}

extension TopicGenerateViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.recommendKeywords.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: RecommendKeywordCollectionViewCell.self)
        cell.fill(viewModel.recommendKeywords[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        RecommendKeywordCollectionViewCell.size(viewModel.recommendKeywords[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        inputCell?.keyword.contentView.setText(viewModel.recommendKeywords[indexPath.row])
    }
    
}
