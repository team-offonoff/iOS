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

public final class DropDownView: ABTextFieldView {
    
    public init(placeholder: String) {
        super.init(placeholder: placeholder, insets:  UIEdgeInsets(top: 14, left: 16, bottom: 14, right: 15), isErrorNeed: false)
        textField.customPlaceholder(font: Pretendard.semibold14.font)
    }
    
    public required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var menu: UIMenu? {
        didSet {
            backButton.menu = menu
        }
    }
    private let backButton: UIButton = {
        let button = UIButton()
        button.showsMenuAsPrimaryAction = true
        return button
    }()
    private var cancellable: Set<AnyCancellable> = []
    
    public override func initialize() {
        
        super.initialize()
        
        addBackButton()
        setRightView()
        
        func addBackButton() {
            addSubview(backButton)
            backButton.snp.makeConstraints{
                $0.top.leading.trailing.bottom.equalToSuperview()
            }
        }
        
        func setRightView() {
            let arrowImage = UIImageView(image: Image.dropdown.withTintColor(Color.subPurple))
            textField.rightView = arrowImage
            textField.rightViewMode = .always
        }
    }
}
