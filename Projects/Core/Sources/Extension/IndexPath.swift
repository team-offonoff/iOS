//
//  IndexPath.swift
//  Core
//
//  Created by 박소윤 on 2023/12/15.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation
import UIKit

public extension IndexPath {
    init(row: Int) {
        self.init(row: row, section: 0)
    }
}
