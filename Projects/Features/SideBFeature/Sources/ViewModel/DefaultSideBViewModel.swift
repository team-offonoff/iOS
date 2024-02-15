//
//  DefaultSideBViewModel.swift
//  SideBFeature
//
//  Created by 박소윤 on 2024/02/12.
//  Copyright © 2024 AB. All rights reserved.
//

import Foundation
import SideBFeatureInterface
import TopicFeatureInterface
import FeatureDependency
import Domain
import Combine
import Core

final class DefaultSideBViewModel: BaseViewModel, SideBViewModel {

    init(
        fetchTopicUseCase: any FetchTopicsUseCase,
        voteTopicUseCase: any GenerateVoteUseCase,
        revoteTopicUseCase: any RevoteUseCase,
        reportTopicUseCase: any ReportTopicUseCase
    ) {
        self.fetchTopicUseCase = fetchTopicUseCase
        self.voteTopicUseCase = voteTopicUseCase
        self.revoteTopicUseCase = revoteTopicUseCase
        self.reportTopicUseCase = reportTopicUseCase
    }
    
    var topics: [TopicItemViewModel] = []
    let keywords: [String] = ["전체", "AB Test", "카피라이팅", "UIUX", "커리어", "디자인", "개발"]
    
    let fetchTopicUseCase: any FetchTopicsUseCase
    let voteTopicUseCase: any GenerateVoteUseCase
    let revoteTopicUseCase: any RevoteUseCase
    private let reportTopicUseCase: any ReportTopicUseCase
    
    var fetchTopicQuery: FetchTopicQuery = .init(side: .B, status: CurrentValueSubject(.ongoing), keywordIdx: CurrentValueSubject(0), pageInfo: .init(page: 0, last: false), sort: nil)
    var reloadTopics: (() -> Void)?
    var topicIndex: Int?
    
    let timerSubject: PassthroughSubject<TimerInfo, Never> = PassthroughSubject()
    let successVote: PassthroughSubject<(Index, Choice.Option), Never> = PassthroughSubject()
    let failVote: PassthroughSubject<Index, Never> = PassthroughSubject()
    let successTopicAction: PassthroughSubject<Topic.Action, Never> = PassthroughSubject()
    let errorHandler: PassthroughSubject<ErrorContent, Never> = PassthroughSubject()
    
    private var timer: Timer?
    private let hourUnit: Int = 60*60
    
    override func bind() {

        bindQuery()
        
        func bindQuery() {
            
            guard let status = fetchTopicQuery.status, let keywordIdx = fetchTopicQuery.keywordIdx else { return }
            
            status
                .combineLatest(keywordIdx)
                .sink{ [weak self] _ in
                    defer {
                        self?.fetchTopics()
                    }
                    self?.fetchTopicQuery.pageInfo = .init(page: 0, last: false)
                }
                .store(in: &cancellable)
        }
    }
    
    //MARK: Timer
    
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
            guard let detailIdx = topicIndex, let deadline = topics[detailIdx].topic.deadline else {
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
    
    var canRevote: Bool {
        guard let index = topicIndex else { return false }
        return topics[index].isVoted
    }
    
    func hideTopic(index: Int) {
        print("hide")
    }
    
    func reportTopic(index: Int) {
        reportTopicUseCase
            .execute(topicId: topics[index].topic.id!)
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
