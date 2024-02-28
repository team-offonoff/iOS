//
//  SideTabEmptyView.swift
//  FeatureDependency
//
//  Created by 박소윤 on 2024/02/27.
//  Copyright © 2024 AB. All rights reserved.
//

import Foundation
import UIKit
import ABKit

public final class SideTabEmptyView: BaseView {
    
    private let stackView: UIStackView = {
       let stackView = UIStackView(axis: .vertical, spacing: 4)
        stackView.alignment = .center
        return stackView
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "아직 작성된 토픽이 없어요"
        label.setTypo(Pretendard.semibold22)
        label.textColor = Color.white
        return label
    }()
    private let subtitleLabel: UILabel = {
        let label = UILabel()
         label.text = "가장 먼저 토픽을 올려 보세요!"
         label.setTypo(Pretendard.regular14)
         label.textColor = Color.white60
         return label
    }()
    
    public override func hierarchy() {
        addSubview(stackView)
        stackView.addArrangedSubviews([titleLabel, subtitleLabel])
    }
    
    public override func layout() {
        stackView.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-20)
        }
    }
}
