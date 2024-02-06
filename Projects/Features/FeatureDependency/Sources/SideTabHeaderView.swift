//
//  SideTabHeaderView.swift
//  FeatureDependency
//
//  Created by 박소윤 on 2024/02/06.
//  Copyright © 2024 AB. All rights reserved.
//

import Foundation
import UIKit
import ABKit
import Combine
import Domain

public final class SideTabHeaderView: BaseHeaderView {
    
    public let progressPublisher: CurrentValueSubject<Topic.Progress, Never> = CurrentValueSubject(.ongoing)
    
    public init(icon: UIImage) {
        super.init()
        self.logoImageView.image = icon
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var currentProgress: ProgressButton? {
        didSet {
            oldValue?.isSelected = false
        }
        willSet {
            guard let newValue = newValue else { return }
            newValue.isSelected = true
            progressPublisher.send(newValue.progress)
        }
    }
    
    private let logoImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.snp.makeConstraints{
            $0.height.equalTo(30)
        }
        return imageView
    }()
    private let progressStackView: UIStackView = {
       let stackView = UIStackView(axis: .horizontal, spacing: 0)
        stackView.backgroundColor = Color.white.withAlphaComponent(0.1)
        stackView.layer.cornerRadius = 33/2
        stackView.layoutMargins = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    
    public override func hierarchy() {
        
        addSubviews([logoImageView, progressStackView])
        
        Topic.Progress.allCases.forEach{
            let cell = ProgressButton(of: $0)
            cell.isUserInteractionEnabled = true
            cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapProgressButton)))
            progressStackView.addArrangedSubview(cell)
        }
    }
    
    @objc private func tapProgressButton(_ recognizer: UITapGestureRecognizer) {
        currentProgress = recognizer.view as? ProgressButton
    }
    
    public override func layout() {
        logoImageView.snp.makeConstraints{
            $0.leading.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(9)
            $0.centerY.equalToSuperview()
        }
        progressStackView.snp.makeConstraints{
            $0.center.equalToSuperview()
        }
    }
    
    public override func initialize() {
        guard let initProgress = progressStackView.subviews[0] as? ProgressButton else { return }
        initProgress.isSelected = true
        currentProgress = initProgress
    }
}

extension SideTabHeaderView {
    
    final class ProgressButton: PaddingLabel {
        
        let progress: Topic.Progress
        var isSelected: Bool = false {
            didSet {
                configuration()
            }
        }
 
        init(of progress: Topic.Progress){
            self.progress = progress
            super.init(top: 4, bottom: 4, left: 14, right: 14)
            self.text = progress.configuration.title
            setTypo(Pretendard.medium15)
            layer.cornerRadius = 29/2
            layer.masksToBounds = true
            configuration()
            self.snp.makeConstraints{
                $0.height.equalTo(29)
            }
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func configuration() {
            if isSelected {
                textColor = Color.subPurple
                backgroundColor = Color.black
            }
            else {
                textColor = Color.white40
                backgroundColor = Color.transparent
            }
        }
        
    }
}
