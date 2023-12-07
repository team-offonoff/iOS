//
//  HomeTabViewController.swift
//  HomeFeature
//
//  Created by 박소윤 on 2023/09/25.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation
import ABKit
import UIKit
import FeatureDependency
import HomeFeatureInterface
import Core

protocol TopicBottomSheetDelegate: AnyObject {
    func show()
}

protocol Choiceable: AnyObject {
    func choice(option: ChoiceOption)
}

final class HomeTabViewController: BaseViewController<HeaderView, HomeTabView, DefaultHomeCoordinator>{

    init(viewModel: any HomeTabViewModel){
        self.viewModel = viewModel
        super.init(
            headerView: HeaderView(
                icon: Image.homeAlarmOff,
                selectedIcon: Image.homeAlarmOn),
            mainView: HomeTabView()
        )
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var currentTopicCell: HomeTopicCollectionViewCell? //timer ui 업데이트 편의를 위한 셀 저장 프로퍼티
    
    private let viewModel: any HomeTabViewModel
    
    override func viewDidAppear(_ animated: Bool) {
//        mainView.setBottomSheetDefaultY()
        viewModel.startTimer()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        viewModel.stopTimer()
    }
    
    public override func style() {
        view.backgroundColor = Color.homeBackground
    }
    
    override func initialize() {
        setDelegate()
        addButtonFrameTarget()
    }
    
    private func setDelegate(){
        mainView.scrollFrame.setDelegate(to: self)
    }
    
    private func addButtonFrameTarget(){
        mainView.scrollFrame.buttonFrame.previousButton.tapPublisher
            .sink{ [weak self] _ in
                self?.viewModel.movePreviousTopic()
            }.store(in: &cancellables)
        
        mainView.scrollFrame.buttonFrame.nextButton.tapPublisher
            .sink{ [weak self] _ in
                self?.viewModel.moveNextTopic()
            }.store(in: &cancellables)
    }
    
    override func bind() {
        viewModel.viewDidLoad()
        bindReloadTopics()
        bindMoveTopic()
        bindTimer()
        bindSelectionSuccess()
    }
    
    private func bindReloadTopics(){
        viewModel.reloadTopics
            .receive(on: RunLoop.main)
            .sink{ [weak self] _ in
                self?.mainView.scrollFrame.reloadTopics()
            }
            .store(in: &cancellables)
    }
    
    private func bindMoveTopic(){
        viewModel.willMovePage
            .receive(on: RunLoop.main)
            .sink{ [weak self] indexPath in
                self?.mainView.scrollFrame.move(to: indexPath)
                self?.setMoveButtonVisibility()
            }
            .store(in: &cancellables)
    }
    
    private func bindSelectionSuccess() {
        viewModel.choiceSuccess
            .receive(on: RunLoop.main)
            .sink{ [weak self] choice in
                self?.currentTopicCell?.select(choice: choice)
            }
            .store(in: &cancellables)
    }
    
    private func setMoveButtonVisibility(){
        mainView.scrollFrame.buttonFrame.previousButton.isHidden = !viewModel.canMovePrevious
        mainView.scrollFrame.buttonFrame.nextButton.isHidden = !viewModel.canMoveNext
    }
    
    private func bindTimer(){
        viewModel.timerSubject
            .receive(on: RunLoop.main)
            .sink{ [weak self] time in
                self?.currentTopicCell?.binding(timer: time)
            }
            .store(in: &cancellables)
    }
}

//MARK: CollcetionView Delegate
extension HomeTabViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.topics.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: HomeTopicCollectionViewCell.self)
        cell.delegate = self
        cell.binding(data: viewModel.topics[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: Device.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        currentTopicCell = cell as? HomeTopicCollectionViewCell
    }
    
    // clipsToBounds를 활용하여 토픽 전환(scroll)시 선택지 뷰가 셀 자체 크기를 넘기지 못하도록 한다.
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        currentTopicCell?.clipsToBounds = true
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        currentTopicCell?.clipsToBounds = false
    }
}

extension HomeTabViewController: TopicBottomSheetDelegate {
    func show() {
        coordinator?.startTopicBottomSheet()
    }
}

extension HomeTabViewController: Choiceable {
    func choice(option: ChoiceOption) {
        print(choice)
    }
}
