//
//  RadioButtonView.swift
//  ABKit
//
//  Created by 박소윤 on 2023/11/16.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation
import UIKit
import Combine

public final class RadioButtonView<E: RadioButtonData,T: RadioButtonCell>: UIStackView {

    public init(elements: [E], cellType: T.Type) {
        self.data = elements
        super.init(frame: .zero)
        hierarchy()
        initialize()

    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Public property
    
    public var elementPublisher: AnyPublisher<E, Never> {
        $selectedView
            .compactMap{ $0 }
            .map{ self.data[self.convert(tag: $0.tag)] }
            .eraseToAnyPublisher()
    }
    
    public var startIndex: Int? = nil {
        willSet {
            if newValue ?? data.count >= data.count {
                fatalError("start index is out of range")
            }
        }
        didSet {
            initialize()
        }
    }
    
    public var currentElement: E? {
        guard let view = selectedView else { return nil }
        return data[convert(tag: view.tag)]
    }
    
    //MARK: Private property
    
    private typealias Index = Int
    private typealias Tag = Int
    
    private let data: [E]
    
    @Published private var selectedView: RadioButtonCell? {
        didSet {
            oldValue?.deselect()
            selectedView?.select()
        }
    }
    
    private func convert(tag: Int) -> Index {
        tag-1
    }
    
    private func convert(index: Int) -> Tag {
        index+1
    }

    private func hierarchy(){
        
        for (i, element) in data.enumerated() {
            
            let elementView = T()
            
            addToParentView()
            setDefault()
            addTarget()
            
            func addToParentView(){
                addArrangedSubview(elementView)
            }
            func setDefault() {
                elementView.tag = convert(index: i)
                elementView.titleLabel.text = element.title
                elementView.deselect()
            }
            func addTarget(){
                elementView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(elementGestureTarget)))
            }
        }
    }
    
    @objc private func elementGestureTarget(_ recognizer: UITapGestureRecognizer) {
        guard let view = recognizer.view as? RadioButtonCell else { return }
        selectedView = view
    }
    
    private func initialize() {
        guard let index = startIndex,
              let initView = viewWithTag(convert(index: index)) as? RadioButtonCell
        else { return }
        selectedView = initView
    }
}
