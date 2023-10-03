//
//  DefaultHomeTabViewModel.swift
//  HomeFeature
//
//  Created by 박소윤 on 2023/09/25.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation
import FeatureDependency
import Combine

final class DefaultHomeTabViewModel: HomeTabViewModel {
    
    var canBottomSheetMovePublisher: Published<Bool>.Publisher { $canBottomSheetMove }
    
    @Published private var canBottomSheetMove: Bool = true
    
    private func remainTimerTime() -> Int {
        return 0
    }
    
    private func shouldTimerHighlight() -> Bool {
        //1시간 미만인지 여부 확인
        return true
    }
    
    private func convertToCountFormat(num: Int) -> String {
        /*
        1. 999까지는 숫자 표현
        2. 999 초과인 경우 '천' 단위 표기
         */
        let (head, tail) = (num / 1000, (num % 1000)/100)
        if head == 0 {
            return "\(num)"
        } else if tail == 0 {
            return "\(head)천"
        } else {
            return "\(head).\(tail)천"
        }
    }
    
    func viewDidLoad() {
        
    }
}
