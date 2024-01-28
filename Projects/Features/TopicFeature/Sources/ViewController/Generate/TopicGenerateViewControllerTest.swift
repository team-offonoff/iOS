//
//  TopicGenerateViewControllerTest.swift
//  TopicFeature
//
//  Created by 박소윤 on 2024/01/20.
//  Copyright © 2024 AB. All rights reserved.
//

import Foundation
import UIKit
import ABKit
import TopicFeatureInterface
import FeatureDependency
import Domain

final class TopicGenerateViewControllerTest: BaseViewController<TopicGenerateHeaderView, BaseView, DefaultTopicGenerateCoordinator> {
    
    init(viewModel: any TopicGenerateViewModel) {
        self.viewModel = viewModel
        super.init(headerView: TopicGenerateHeaderView(), mainView: BaseView())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var viewModel: any TopicGenerateViewModel
    private let aSideView: TopicGenerateASideView = TopicGenerateASideView()
    private let bSideView: TopicGenerateBSideFirstView = TopicGenerateBSideFirstView()
    
    private var sideChangeButton: TopicSideChangeButton?
    private var currentSideView: UIView? {
        willSet {
            newValue?.isHidden = false
        }
        didSet {
            oldValue?.isHidden = true
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func initialize() {
        
        setLimitCount()
        setHeaderViewTopicSide()
        addSideChangeTarget()
        collectionViewDelegate()
        
        mainView.addSubviews([aSideView, bSideView])
        [aSideView, bSideView].forEach{ view in
            view.isHidden = true
            view.snp.makeConstraints{
                $0.top.leading.trailing.bottom.equalToSuperview()
            }
        }
        
        aSideView.optionSwitch.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(optionSwitch)))
        
        aSideView.ctaButton.tapPublisher
            .sink{ [weak self] _ in
                guard let self = self else { return }
                self.viewModel.register(.init(
                    side: .A,
                    keyword: nil,
                    title: self.aSideView.titleSection.contentView.textField.text ?? "",
                    choices: [.init(text: self.aSideView.optionsSection.contentView.aTextField.textField.text, image: nil, option: .A),
                              .init(text: self.aSideView.optionsSection.contentView.aTextField.textField.text, image: nil, option: .B)],
                    deadline: nil
                ))
            }
            .store(in: &cancellables)
        
        func setLimitCount() {
            aSideView.titleSection.contentView.limitCount = viewModel.limitCount.title
            aSideView.optionsSection.contentView.aTextField.limitCount = viewModel.limitCount.textOption
            aSideView.optionsSection.contentView.bTextField.limitCount = viewModel.limitCount.textOption
            
            bSideView.titleSection.contentView.limitCount = viewModel.limitCount.title
            bSideView.keywordSection.contentView.limitCount = viewModel.limitCount.keyword
        }
        
        func setHeaderViewTopicSide() {
            headerView?.topicSide = viewModel.topicSide
        }
        
        func addSideChangeTarget() {
            
            headerView?.sideChangeButton.tapPublisher
                .sink{ [weak self] _ in
                    
                    guard let self = self, let headerView = self.headerView else { return }
                    
                    if headerView.sideChangeViewState == .open {
                        closeSideChangeButton()
                    }
                    else if headerView.sideChangeViewState == .close {
                        
                        openSideChangeButton()
                        
                        func openSideChangeButton() {
                            
                            headerView.sideChangeViewState = .open
                            
                            let button = TopicSideChangeButton(side: self.viewModel.otherTopicSide())
                            self.view.addSubview(button)
                            button.snp.makeConstraints{
                                $0.top.equalTo(headerView.sideChangeButton.snp.bottom).offset(11.5)
                                $0.leading.equalTo(headerView.sideChangeButton)
                            }
                            button.tapPublisher
                                .sink{ _ in
                                    self.viewModel.topicSide.send(button.side)
                                    closeSideChangeButton()
                                }
                                .store(in: &self.cancellables)
                            
                            self.sideChangeButton = button
                        }
                    }
                }
                .store(in: &cancellables)
            
            func closeSideChangeButton() {
                headerView?.sideChangeViewState = .close
                sideChangeButton?.removeFromSuperview()
                sideChangeButton = nil
            }
        }
        
        func collectionViewDelegate() {
            bSideView.recommendKeyword.collectionView.delegate = self
            bSideView.recommendKeyword.collectionView.dataSource = self
        }
    }
    
    @objc private func optionSwitch() {
        let temp = aSideView.optionsSection.contentView.aTextField.textField.text ?? ""
        aSideView.optionsSection.contentView.aTextField.update(text: aSideView.optionsSection.contentView.bTextField.textField.text ?? "")
        aSideView.optionsSection.contentView.bTextField.update(text: temp)
    }
    
    override func bind() {
        
        bindTopicSide()
        bindSideA()
        bindSideB()

        
        func bindTopicSide() {
            viewModel.topicSide
                .receive(on: DispatchQueue.main)
                .sink{ [weak self] side in
                    guard let self = self else { return }
                    switch side {
                    case .A:
                        self.aSideView.clear()
                        self.currentSideView = self.aSideView
                        self.viewModel.sideAInput(
                            content: .init(titleDidEnd: self.aSideView.titleSection.contentView.textField.publisher(for: .editingDidEnd), keywordDidEnd: nil),
                            choices: .init(
                                choiceA: self.aSideView.optionsSection.contentView.aTextField.textField.anyPublisher(for: .editingDidEnd),
                                choiceB: self.aSideView.optionsSection.contentView.bTextField.textField.anyPublisher(for: .editingDidEnd))
                        )
                    case .B:
                        self.bSideView.clear()
                        self.currentSideView = self.bSideView
                        self.viewModel.sideBInput(
                            content: .init(
                                titleDidEnd: self.bSideView.titleSection.contentView.textField.publisher(for: .editingDidEnd),
                                keywordDidEnd: self.bSideView.keywordSection.contentView.textField.publisher(for: .editingDidEnd)
                            )
                        )
                    }
                }
                .store(in: &cancellables)
        }
        
        func bindSideA() {
            
            viewModel.sideATitleValidation
                .receive(on: DispatchQueue.main)
                .sink{ [weak self] (isValid, message) in
                    if isValid {
                        self?.aSideView.titleSection.contentView.complete()
                    }
                    else {
                        self?.aSideView.titleSection.contentView.error(message: message)
                    }
                }
                .store(in: &cancellables)
            
            viewModel.sideAOptionAValidation
                .receive(on: DispatchQueue.main)
                .sink{ [weak self] (isValid, message) in
                    if isValid {
                        self?.aSideView.optionsSection.contentView.aTextField.complete()
                    }
                    else {
                        self?.aSideView.optionsSection.contentView.aTextField.error(message: message)
                        self?.aSideView.optionsSection.contentView.bTextField.errorLabel.text = message
                    }
                }
                .store(in: &cancellables)
            
            viewModel.sideAOptionBValidation
                .receive(on: DispatchQueue.main)
                .sink{ [weak self] (isValid, message) in
                    if isValid {
                        self?.aSideView.optionsSection.contentView.bTextField.complete()
                    }
                    else {
                        self?.aSideView.optionsSection.contentView.bTextField.error(message: message)
                    }
                }
                .store(in: &cancellables)
            
            viewModel.sideACanSwitchOption
                .receive(on: DispatchQueue.main)
                .sink{ [weak self] isValid in
                    self?.aSideView.optionSwitch.isEnabled = isValid
                }
                .store(in: &cancellables)
            
            viewModel.canSideARegister
                .receive(on: DispatchQueue.main)
                .sink{ [weak self] canRegister in
                    self?.aSideView.ctaButton.isEnabled = canRegister
                }
                .store(in: &cancellables)
            
            viewModel.successRegister = {
                DispatchQueue.main.async {
                    self.dismiss(animated: true)
                }
            }
        }
        
        func bindSideB() {
            
        }

    }
}

extension TopicGenerateViewControllerTest: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
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
        bSideView.keywordSection.contentView.update(text: viewModel.recommendKeywords[indexPath.row])
    }
}
