//
//  SemiboldSubtitleView.swift
//  ABKit
//
//  Created by 박소윤 on 2024/01/20.
//  Copyright © 2024 AB. All rights reserved.
//

import Foundation
import UIKit

public final class SemiboldSubtitleView<V: UIView>: SubtitleView<V>{
    
    public convenience init(subtitle: String, content: V) {
        self.init(subtitle: subtitle, content: content, font: Pretendard.semibold18.font, color: Color.white, spacing: 10)
    }
    
}
