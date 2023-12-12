//
//  ABFormat.swift
//  Core
//
//  Created by 박소윤 on 2023/12/12.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation

public struct ABFormat {
    
    public static func count(_ number: Int) -> String {
        //1. 999까지는 숫자 표현
        //2. 999 초과인 경우 '천' 단위 표기
        let (integer, decimal) = divide()
        if integer == 0 {
            return String(describing: number)
        }
        return (decimal == 0 ? String(describing: integer) : "\(integer).\(decimal)") + "천"
        
        //기준 단위에 맞춰 정수형과 소수점으로 구분한다.
        func divide(unit: Int = 1000) ->  (integer: Int, decimal: Int) {
            (number / unit, (number % unit)/(unit/10))
        }
    }
}
