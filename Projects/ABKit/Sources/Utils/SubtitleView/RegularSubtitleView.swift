//
//  RegularSubtitleView.swift
//  ABKit
//
//  Created by 박소윤 on 2024/01/20.
//  Copyright © 2024 AB. All rights reserved.
//

import Foundation
import UIKit

public final class RegularSubtitleView<V: UIView>: SubtitleView<V>{
    
    public convenience init(subtitle: String, content: V) {
        self.init(subtitle: subtitle, content: content, font: Pretendard.regular16.font, color: Color.white.withAlphaComponent(0.6), spacing: 16)
    }
    
}
