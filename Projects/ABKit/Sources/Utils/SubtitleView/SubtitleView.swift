//
//  SubtitleView.swift
//  ABKit
//
//  Created by 박소윤 on 2023/12/22.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation
import UIKit

open class SubtitleView<V: UIView>: BaseStackView {
    
    public init(subtitle: String, content: V, font: UIFont, color: UIColor, spacing: CGFloat) {
        self.contentView = content
        super.init()
        self.subtitleLabel.text = subtitle
        self.subtitleLabel.textColor = color
        self.subtitleLabel.font = font
        self.spacing = spacing
    }
    
    public required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public let contentView: V
    public let defaultSideOffset: CGFloat = 20
    public let subtitleLabel: UILabel = UILabel()
    
    public override func style() {
        axis = .vertical
    }
    
    public override func hierarchy() {
        addArrangedSubviews([subtitleLabel, contentView])
    }
}
