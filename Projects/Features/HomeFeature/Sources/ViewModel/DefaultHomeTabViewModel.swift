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
import FeatureDependency

final class DefaultHomeTabViewModel: BaseViewModel, HomeTabViewModel {
    
    init(fetchTopicsUseCase: any FetchTopicsUseCase) {
        self.fetchTopicsUseCase = fetchTopicsUseCase
        super.init()
    }

    var topics: [Topic] = [TestData.topicA, TestData.topicB]
    var willMovePage: Published<IndexPath>.Publisher{ $currentTopic }
    var canBottomSheetMovePublisher: Published<Bool>.Publisher { $canBottomSheetMove }
    
    let reloadTopics: PassthroughSubject<Void, Never> = PassthroughSubject()
    let timerSubject: PassthroughSubject<TimerInfo, Never> = PassthroughSubject()
    
    private var timer: Timer?
    
    private let hourUnit = 60*60
    private let fetchTopicsUseCase: any FetchTopicsUseCase
    
    @Published private var canBottomSheetMove: Bool = true
    @Published private var currentTopic: IndexPath = IndexPath(row: 0, section: 0)
    
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
    
    private func bindTopics(){
        
        let task = fetchTopicsUseCase.execute()
        
        task.filter{ $0.code == .success }
            .map{ $0.data }
            .sink(receiveValue: { [weak self] topics in
                defer {
                    self?.reloadTopics.send(())
                }
                self?.topics = topics
            })
            .store(in: &cancellable)
        
//        task.filter{ $0.code != .success }
    }
    
    private func convertNumberOfChatToFormat(num: Int) -> String {
        //1. 999까지는 숫자 표현
        //2. 999 초과인 경우 '천' 단위 표기
        let (integer, decimal) = divide()
        if integer == 0 {
            return "\(num)"
        } else if decimal == 0 {
            return "\(integer)천"
        } else {
            return "\(integer).\(decimal)천"
        }
        
        //기준 단위에 맞춰 정수형과 소수점으로 구분한다.
        func divide(unit: Int = 1000) ->  (integer: Int, decimal: Int) {
            (num / unit, (num % unit)/(unit/10))
        }
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
            let remain = topics[currentTopic.row].deadline - Int(Date.now.timeIntervalSince1970)
            return remain < 0 ? 0 : remain
        }
        
        func publishTimer() {
            timerSubject.send(
                TimerInfo(
                    time: timeFormat(remainTime()),
                    isHighlight: remainTime() < hourUnit
                )
            )
        }
        
        func timeFormat(_ time: Int) -> Time {
            Time(
                hour: time / hourUnit,
                minute: time % hourUnit / 60,
                second: time % 60
            )
        }
    }
}
