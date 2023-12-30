//
//  SubtitleView.swift
//  ABKit
//
//  Created by 박소윤 on 2023/12/22.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation
import UIKit

public final class SubtitleView<V: UIView>: BaseStackView {
    
    public init(subtitle: String, content: V) {
        self.contentView = content
        super.init()
        self.subtitleLabel.text = subtitle
    }
    
    public required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public let contentView: V
    public let defaultSideOffset: CGFloat = 20
    private let subtitleLabel: UILabel = {
       let label = UILabel()
        label.setTypo(Pretendard.bold18)
        label.textColor = Color.white
        return label
    }()
    
    public override func style() {
        spacing = 10
        axis = .vertical
    }
    
    public override func hierarchy() {
        addArrangedSubviews([subtitleLabel, contentView])
    }
}
