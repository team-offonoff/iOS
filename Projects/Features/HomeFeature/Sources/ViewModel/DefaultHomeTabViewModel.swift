//
//  DefaultHomeTabViewModel.swift
//  HomeFeature
//
//  Created by 박소윤 on 2023/09/25.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation
import HomeFeatureInterface
import TopicFeatureInterface
import Combine
import Domain
import Core
import FeatureDependency

final class DefaultHomeTabViewModel: BaseViewModel, HomeTabViewModel {
    
    private let fetchTopicsUseCase: any FetchTopicsUseCase
    private let reportTopicUseCase: any ReportTopicUseCase
    private let voteTopicUseCase: any GenerateVoteUseCase
    private let revoteTopicUseCase: any RevoteUseCase
    
    init(
        fetchTopicsUseCase: any FetchTopicsUseCase,
        reportTopicUseCase: any ReportTopicUseCase,
        voteTopicUseCase: any GenerateVoteUseCase,
        revoteTopicUseCase: any RevoteUseCase
    ) {
        self.fetchTopicsUseCase = fetchTopicsUseCase
        self.reportTopicUseCase = reportTopicUseCase
        self.voteTopicUseCase = voteTopicUseCase
        self.revoteTopicUseCase = revoteTopicUseCase
        super.init()
    }

    var topics: [TopicDetailItemViewModel] = []
    
    var currentTopic: TopicDetailItemViewModel {
        topics[currentIndexPath.row]
    }
    
    var willMovePage: AnyPublisher<IndexPath, Never>{ $currentIndexPath.filter{ _ in self.topics.count > 0 }.eraseToAnyPublisher() }
    
    let successVote: PassthroughSubject<Choice.Option, Never> = PassthroughSubject()
    let failVote: PassthroughSubject<Void, Never> = PassthroughSubject()
    let reloadTopics: PassthroughSubject<Void, Never> = PassthroughSubject()
    let timerSubject: PassthroughSubject<TimerInfo, Never> = PassthroughSubject()
    let errorHandler: PassthroughSubject<ErrorContent, Never> = PassthroughSubject()
    let successTopicAction: PassthroughSubject<Topic.Action, Never> = PassthroughSubject()
    
    private var timer: Timer?
    
    private let hourUnit = 60*60
    
    var topicIndex: Int? {
        get {
            currentIndexPath.row
        }
        set {
            
        }
    }
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
            .execute(requestQuery: .init(side: nil, status: nil, keyword: nil, paging: nil, sort: nil))
            .sink{ [weak self] result in
                guard let self = self else { return }
                if result.isSuccess, let (_, topics) = result.data {
                    defer {
                        self.reloadTopics.send(())
                    }
                    self.topics = topics.map{ TopicDetailItemViewModel.init(topic: $0) }
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
            guard let deadline = topics[currentIndexPath.row].deadline else {
                return 0
            }
            return deadline - UTCTime.current
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
    
    func vote(_ option: Choice.Option) {
        voteTopicUseCase
            .execute(
                topicId: topics[currentIndexPath.row].id,
                request: .init(
                    choiceOption: option,
                    votedAt: UTCTime.current
                )
            )
            .sink{ [weak self] result in
                guard let self = self else { return }
                if result.isSuccess, let comment = result.data {
                    self.topics[self.currentIndexPath.row].votedOption = option
                    self.successVote.send(option)
                    //TODO: 댓글 1개 미리보기
                }
                else {
                    if let error = result.error {
                        self.errorHandler.send(error)
                    }
                    self.failVote.send(())
                }
            }.store(in: &cancellable)
    }
    
    func revote(_ option: Choice.Option) {
        revoteTopicUseCase
            .execute(topicId: topics[currentIndexPath.row].id, request: .init(modifiedOption: option, modifiedAt: UTCTime.current))
            .sink{ [weak self] result in
                guard let self = self else { return }
                if result.isSuccess {
                    self.topics[self.currentIndexPath.row].votedOption = option
                    self.successVote.send(option)
                }
                else {
                    if let error = result.error {
                        self.errorHandler.send(error)
                    }
                    self.failVote.send(())
                }
            }
            .store(in: &cancellable)
    }
    
    //MARK: - Topic Bottom Sheet View Model
    
    var canRevote: Bool {
        topics[currentIndexPath.row].isVoted
    }
    
    func hideTopic(index: Int) {
        print("hide topic")
    }
    
    func reportTopic(index: Int) {
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
}
