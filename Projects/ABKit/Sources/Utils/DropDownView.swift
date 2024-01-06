//
//  DropDownView.swift
//  ABKit
//
//  Created by 박소윤 on 2023/12/22.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation
import UIKit
import Combine

fileprivate protocol DropDownViewConfiguration {
    var backgroundColor: UIColor { get }
    var strokeWidth: CGFloat? { get }
    var strokeColor: UIColor? { get }
}

public final class DropDownView: InsetTextField {
    
    public enum State {
        case noraml
        case complete
    }
    
    public init(placeholder: String) {
        super.init(insets: UIEdgeInsets(top: 14, left: 16, bottom: 14, right: 15))
        self.placeholder = placeholder
        style()
        initialize()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @Published public var viewState: State = .noraml
    private var cancellable: Set<AnyCancellable> = []
    
    private func style() {
        
        layer.cornerRadius = 10
        setCustomPlaceholder()
        
        func setCustomPlaceholder() {
            let attributedPlaceholder = NSMutableAttributedString(string: placeholder!)
            attributedPlaceholder.addAttributes([
                .font: Pretendard.semibold14.font,
                .foregroundColor: Color.subPurple
            ], range: NSRange(location: 0, length: placeholder!.count))
            self.attributedPlaceholder = NSAttributedString(attributedString: attributedPlaceholder)
        }
    }
    
    private func initialize() {
    
        isUserInteractionEnabled = false
        setRightView()
        setHeight()
        
        func setRightView() {
            let arrowImage = UIImageView(image: Image.arrowDown.withTintColor(Color.subPurple))
            rightView = arrowImage
            rightViewMode = .always
        }
        
        func setHeight() {
            self.snp.makeConstraints{
                $0.height.equalTo(48)
            }
        }
    }
    
    private func bind() {
        $viewState
            .sink{ [weak self] state in
                
                guard let self = self else { return }
 
                let configuration = configuration()
                self.backgroundColor = configuration.backgroundColor
                self.layer.borderWidth = configuration.strokeWidth ?? 0
                self.layer.borderColor = configuration.strokeColor?.cgColor
                
                func configuration() -> DropDownViewConfiguration {
                    switch state {
                    case .noraml:           return NormalStateConfiguration()
                    case .complete:         return CompleteStateConfiguration()
                    }
                }
            }
            .store(in: &cancellable)
    }
}

fileprivate struct NormalStateConfiguration: DropDownViewConfiguration {
    let backgroundColor: UIColor = Color.transparent
    let strokeWidth: CGFloat? = 1
    let strokeColor: UIColor? = Color.subPurple.withAlphaComponent(0.4)
}

fileprivate struct CompleteStateConfiguration: DropDownViewConfiguration {
    let backgroundColor: UIColor = Color.subNavy2
    let strokeWidth: CGFloat? = nil
    let strokeColor: UIColor? = nil
}
