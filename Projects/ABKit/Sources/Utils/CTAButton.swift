//
//  CTAButton.swift
//  ABKit
//
//  Created by 박소윤 on 2023/12/22.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation
import UIKit

public final class CTAButton: UIButton {
    
    public init(title: String) {
        self.title = title
        super.init(frame: .zero)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    ///superview로 부터의 leading, trailing의 기본 offset
    public let defaultOffset = (side: 20, bottom: 48)
    private let title: String
    
    private func style() {
        layer.cornerRadius = 10
    }
    
    private func initialize() {
        
        setHeight()
        setConfigurationHandler()

        func setHeight() {
            self.snp.makeConstraints{
                $0.height.equalTo(52)
            }
        }
        
        func setConfigurationHandler() {
            
            configurationUpdateHandler = { [weak self] button in
                
                guard let self = self else { return }
                self.configuration = newConfiguration()
                
                func newConfiguration() -> UIButton.Configuration {
                    
                    var result = UIButton.Configuration.filled()
                    let configuration = configuration()
                    
                    result.background.backgroundColor = configuration.backgroundColor
                    result.contentInsets = NSDirectionalEdgeInsets(topBottom: configuration.topBottomPadding, leadingTrailing: configuration.leadingTrailingPadding)
                    result.attributedTitle = attributedTitle()
                    
                    return result
                    
                    func configuration() -> CTAButtonConfiguration {
                        switch button.state {
                        case .disabled:     return DisabledCTAButtonConfiguration()
                        default:            return NormalCTAButtonConfiguration()
                        }
                    }
                    
                    func attributedTitle() -> AttributedString {
                        let attributedString = NSMutableAttributedString(string: self.title)
                        attributedString.addAttributes([
                            .font: configuration.font,
                            .foregroundColor: configuration.textColor
                        ], range: NSRange(location: 0, length: self.title.count))
                        return AttributedString(attributedString)
                    }
                }
            }
        }
    }
}

private extension NSDirectionalEdgeInsets {
    init(topBottom: CGFloat, leadingTrailing: CGFloat) {
        self.init(
            top: topBottom,
            leading: leadingTrailing,
            bottom: topBottom,
            trailing: leadingTrailing
        )
    }
}

fileprivate protocol CTAButtonConfiguration {
    var backgroundColor: UIColor { get }
    var font: UIFont { get }
    var textColor: UIColor { get }
    var topBottomPadding: CGFloat { get }
    var leadingTrailingPadding: CGFloat { get }
}

fileprivate struct DisabledCTAButtonConfiguration: CTAButtonConfiguration {
    var backgroundColor: UIColor = Color.navyWhite20
    var font: UIFont = Pretendard.bold16.font
    var textColor: UIColor = Color.navyWhite40
    var topBottomPadding: CGFloat = 15
    var leadingTrailingPadding: CGFloat = 50
}

fileprivate struct NormalCTAButtonConfiguration: CTAButtonConfiguration {
    var backgroundColor: UIColor = Color.subPurple
    var font: UIFont = Pretendard.bold16.font
    var textColor: UIColor = Color.white
    var topBottomPadding: CGFloat = 15
    var leadingTrailingPadding: CGFloat = 50
}
