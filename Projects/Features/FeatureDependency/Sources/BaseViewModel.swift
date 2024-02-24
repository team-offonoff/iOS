//
//  BaseViewModel.swift
//  FeatureDependency
//
//  Created by 박소윤 on 2023/11/06.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation
import Combine
import Domain

public protocol CancelStorageable {
    var cancellable: Set<AnyCancellable> { get set }
}

open class BaseViewModel: CancelStorageable, ErrorHandleable {
    
    public init(){
        bind()
    }
    
    public var cancellable: Set<AnyCancellable> = []
    public let errorHandler: PassthroughSubject<ErrorContent, Never> = PassthroughSubject()
    
    open func bind(){ }
}
