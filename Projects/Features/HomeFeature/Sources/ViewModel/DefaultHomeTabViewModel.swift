//
//  DefaultHomeTabViewModel.swift
//  HomeFeature
//
//  Created by 박소윤 on 2023/09/25.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation
import HomeFeatureInterface
import Combine
import Domain
import Core
import FeatureDependency

final class DefaultHomeTabViewModel: BaseViewModel, HomeTabViewModel {
    
    private let fetchTopicsUseCase: any FetchTopicsUseCase
    private let reportTopicUseCase: any ReportTopicUseCase
    private let voteTopicUseCase: any GenerateVoteUseCase
    private let cancelVoteTopicUseCase: any CancelVoteUseCase
    
    init(
        fetchTopicsUseCase: any FetchTopicsUseCase,
        reportTopicUseCase: any ReportTopicUseCase,
        voteTopicUseCase: any GenerateVoteUseCase,
        cancelVoteTopicUseCase: any CancelVoteUseCase
    ) {
        self.fetchTopicsUseCase = fetchTopicsUseCase
        self.reportTopicUseCase = reportTopicUseCase
        self.voteTopicUseCase = voteTopicUseCase
        self.cancelVoteTopicUseCase = cancelVoteTopicUseCase
        super.init()
    }

    var topics: [HomeTopicItemViewModel] = [.init(topic: TestData.topicData1), .init(topic: TestData.topicData2), .init(topic: TestData.topicData3), .init(topic: TestData.topicData4)]
    
    var currentTopic: HomeTopicItemViewModel {
        topics[currentIndexPath.row]
    }
    
    var willMovePage: AnyPublisher<IndexPath, Never>{ $currentIndexPath.filter{ _ in self.topics.count > 0 }.eraseToAnyPublisher() }
    var voteSuccess: AnyPublisher<Choice, Never> { $selectedOption.compactMap{ $0 }.eraseToAnyPublisher() }
    
    let successTopicAction: PassthroughSubject<Topic.Action, Never> = PassthroughSubject()
    let reloadTopics: PassthroughSubject<Void, Never> = PassthroughSubject()
    let timerSubject: PassthroughSubject<TimerInfo, Never> = PassthroughSubject()
    let errorHandler: PassthroughSubject<ErrorContent, Never> = PassthroughSubject()
    
    private var timer: Timer?
    
    private let hourUnit = 60*60
    
    @Published private var selectedOption: Choice?
    @Published private var currentIndexPath: IndexPath = IndexPath(row: 0, section: 0)
    
    override func bind(){
        willMovePage
            .sink{ [weak self] _ in
                self?.startTimer()
            }
            .store(in: &cancellable)
    }
    
    func viewDidLoad() {
        bindTopics()
    }
    
    private func bindTopics() {
        fetchTopicsUseCase
            .execute(keywordId: nil, paging: nil, sort: nil)
            .sink{ [weak self] result in
                guard let self = self else { return }
                if result.isSuccess, let (_, topics) = result.data {
                    defer {
                        self.reloadTopics.send(())
                    }
                    self.topics = topics.map{ HomeTopicItemViewModel.init(topic: $0) }
                }
                else if let error = result.error {
                    self.errorHandler.send(error)
                }
            }
            .store(in: &cancellable)
    }
    
    //MARK: topic page control
    
    var canMovePrevious: Bool {
        currentIndexPath.row > 0
    }
    var canMoveNext: Bool {
        currentIndexPath.row < topics.count-1
    }
    
    func moveNextTopic(){
        currentIndexPath.row += 1
    }
    
    func movePreviousTopic(){
        currentIndexPath.row -= 1
    }
    
    //MARK: timer

    func startTimer(){
        DispatchQueue.global(qos: .background).async {
            self.stopTimer()
            self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateTimer), userInfo: nil, repeats: true)
            RunLoop.current.run()
        }
    }
    
    func stopTimer(){
        timer?.invalidate()
    }
    
    @objc private func updateTimer(){
        
        publishTimer()
        
        if remainTime() <= 0 {
            stopTimer()
        }
        
        //MARK: helper method
        
        func remainTime() -> Int {
            topics[currentIndexPath.row].deadline - Int(Date.now.timeIntervalSince1970)
        }
        
        func publishTimer() {
            timerSubject.send(
                TimerInfo(
                    time: timeFormat(),
                    isHighlight: remainTime() < hourUnit
                )
            )
        }
        
        func timeFormat() -> Time {
            var time = remainTime()
            if time < 0 { time = 0 }
            return Time(
                hour: time / hourUnit,
                minute: time % hourUnit / 60,
                second: time % 60
            )
        }
    }
    
    func vote(choice: Choice.Option) {
        voteTopicUseCase
            .execute(
                topicId: topics[currentIndexPath.row].id,
                request: .init(
                    choiceOption: choice,
                    votedAt: UTCTime.current
                )
            )
            .sink{ [weak self] result in
                guard let self = self else { return }
                if result.isSuccess {
                    self.topics[self.currentIndexPath.row].selectedOption = {
                        switch choice {
                        case .A:    return self.topics[self.currentIndexPath.row].aOption
                        case .B:    return self.topics[self.currentIndexPath.row].bOption
                        }
                    }()
                    self.selectedOption = self.topics[self.currentIndexPath.row].selectedOption
                }
                else if let error = result.error {
                    self.errorHandler.send(error)
                }
            }.store(in: &cancellable)
    }
    
    //MARK: - Topic Bottom Sheet View Model
    
    var canChoiceReset: Bool {
        topics[currentIndexPath.row].isVoted
    }
    
    func hideTopic() {
        print("hide topic")
    }
    
    func reportTopic() {
        reportTopicUseCase
            .execute(topicId: topics[currentIndexPath.row].id)
            .sink{ [weak self] result in
                guard let self = self else { return }
                if result.isSuccess {
                    self.successTopicAction.send(Topic.Action.report)
                }
                else if let error = result.error {
                    print(error)
                    self.errorHandler.send(error)
                }
            }
            .store(in: &cancellable)
    }
    
    func resetChoice() {
        cancelVoteTopicUseCase
            .execute(topicId: topics[currentIndexPath.row].id, request: .init(canceledAt: UTCTime.current))
            .sink{ [weak self] result in
                guard let self = self else { return }
                if result.isSuccess {
                    self.topics[self.currentIndexPath.row].selectedOption = nil
                    self.successTopicAction.send(Topic.Action.reset)
                    self.reloadTopics.send(())
                }
                else if let error = result.error {
                    print(error)
                    self.errorHandler.send(error)
                }
            }
            .store(in: &cancellable)
    }
}
