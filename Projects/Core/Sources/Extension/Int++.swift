//
//  Int++.swift
//  Core
//
//  Created by 박소윤 on 2023/11/06.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation

extension Int {
    public var doubleDigitFormat: String {
        self < 10 ? "0\(self)" : "\(self)"
    }
}
