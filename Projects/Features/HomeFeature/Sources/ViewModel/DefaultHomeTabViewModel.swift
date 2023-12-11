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
    
    init(
        fetchTopicsUseCase: any FetchTopicsUseCase,
        reportTopicUseCase: any ReportTopicUseCase
    ) {
        self.fetchTopicsUseCase = fetchTopicsUseCase
        self.reportTopicUseCase = reportTopicUseCase
        super.init()
    }

    var topics: [HomeTopicItemViewModel] = [.init(topic: TestData.topicA), .init(topic: TestData.topicImage), .init(topic: TestData.topicA), .init(topic: TestData.topicB)]
    var willMovePage: Published<IndexPath>.Publisher{ $currentTopic }
    var choiceSuccess: AnyPublisher<Choice, Never> { $selectedOption.compactMap{ $0 }.eraseToAnyPublisher() }
    
    let reloadTopics: PassthroughSubject<Void, Never> = PassthroughSubject()
    let timerSubject: PassthroughSubject<TimerInfo, Never> = PassthroughSubject()
    
    private var timer: Timer?
    
    private let hourUnit = 60*60
    
    @Published private var selectedOption: Choice?
    @Published private var currentTopic: IndexPath = IndexPath(row: 0, section: 0)
    
    override func bind(){
        willMovePage
            .sink{ [weak self] _ in
                self?.startTimer()
            }
            .store(in: &cancellable)
    }
    
    func viewDidLoad() {
//        bindTopics()
    }
    
    private func bindTopics(){

        let task = fetchTopicsUseCase.execute()

        task.filter{ $0.isSuccess }
            .map{ $0.data }
            .sink(receiveValue: { [weak self] topics in
                defer {
                    self?.reloadTopics.send(())
                }
                self?.topics = topics.map{ HomeTopicItemViewModel.init(topic: $0) }
            })
            .store(in: &cancellable)
        
//        task.filter{ $0.code != .success }
    }
    
    //MARK: topic page control
    
    var canMovePrevious: Bool {
        currentTopic.row > 0
    }
    var canMoveNext: Bool {
        currentTopic.row < topics.count-1
    }
    
    func moveNextTopic(){
        currentTopic.row += 1
    }
    
    func movePreviousTopic(){
        currentTopic.row -= 1
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
            topics[currentTopic.row].deadline - Int(Date.now.timeIntervalSince1970)
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
    
    func choice(option: ChoiceOption) {
//        topicSelectUseCase.execute()
        topics[currentTopic.row].votedChoice = {
            switch option {
            case .A:    return topics[currentTopic.row].aOption
            case .B:    return topics[currentTopic.row].bOption
            }
        }()
        selectedOption = topics[currentTopic.row].votedChoice
    }
    
    //MARK: - Topic Bottom Sheet View Model
    
    var canChoiceReset: Bool {
        topics[currentTopic.row].isVoted
    }
    
    func hideTopic() {
        print("hide topic")
    }
    
    func reportTopic() {
        print("report topic")
        reportTopicUseCase.execute(topicId: topics[currentTopic.row].id)
            .sink{ isSuccess, _, error in
                if isSuccess {
                    print("reportTopicUseCase: success")
                }
                else {
                    print(error)
                }
            }
            .store(in: &cancellable)
    }
    
    func resetChoice() {
        print("reset topic")
    }
}
