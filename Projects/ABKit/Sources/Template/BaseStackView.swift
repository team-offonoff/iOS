//
//  BaseStackView.swift
//  ABKit
//
//  Created by 박소윤 on 2023/09/27.
//  Copyright © 2023 AB. All rights reserved.
//

import UIKit

open class BaseStackView: UIStackView {
    
    public init(){
        super.init(frame: .zero)
        style()
        hierarchy()
        layout()
        initialize()
    }
    
    public required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func style() { }
    
    open func hierarchy() { }
    
    open func layout() { }
    
    open func initialize() { }
}
