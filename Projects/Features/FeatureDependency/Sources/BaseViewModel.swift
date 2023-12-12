//
//  BaseViewModel.swift
//  FeatureDependency
//
//  Created by 박소윤 on 2023/11/06.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation
import Combine

public protocol CancelStorageable {
    var cancellable: Set<AnyCancellable> { get set }
}

open class BaseViewModel: CancelStorageable {
    
    public init(){
        bind()
    }
    
    public var cancellable: Set<AnyCancellable> = []
    
    open func bind(){ }
}
