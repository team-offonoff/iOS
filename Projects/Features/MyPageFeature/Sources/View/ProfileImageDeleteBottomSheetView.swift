//
//  ProfileImageDeleteBottomSheetView.swift
//  MyPageFeature
//
//  Created by 박소윤 on 2024/01/16.
//  Copyright © 2024 AB. All rights reserved.
//

import Foundation
import UIKit
import ABKit

final class ProfileImageDeleteBottomSheetView: BaseView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "현재 프로필 사진을 삭제합니다."
        label.textColor = Color.black60
        label.setTypo(Pretendard.regular15)
        return label
    }()
    private let itemsStackView: UIStackView = {
        let stackView = UIStackView(axis: .vertical, spacing: 22)
        stackView.alignment = .center
        return stackView
    }()
    let deleteItem: UIButton = {
        let attributedTitle = NSMutableAttributedString("삭제하기")
        attributedTitle.addAttributes([.foregroundColor: Color.subPurple2, .font: Pretendard.medium18.font], range: NSRange(location: 0, length: attributedTitle.length))
        var configuration = UIButton.Configuration.plain()
        configuration.attributedTitle = AttributedString(attributedTitle)
        let button =  UIButton(configuration: configuration)
        return button
    }()
    private let separatorLine: SeparatorLine = SeparatorLine(color: Color.black20, height: 1)
    let cancelItem: UIButton = {
        let attributedTitle = NSMutableAttributedString("취소")
        attributedTitle.addAttributes([.foregroundColor: Color.black40, .font: Pretendard.medium18.font], range: NSRange(location: 0, length: attributedTitle.length))
        var configuration = UIButton.Configuration.plain()
        configuration.attributedTitle = AttributedString(attributedTitle)
        return UIButton(configuration: configuration)
    }()
    
    override func hierarchy() {
        addSubviews([titleLabel, itemsStackView])
        itemsStackView.addArrangedSubviews([deleteItem, separatorLine, cancelItem])
    }
    
    override func layout() {
        titleLabel.snp.makeConstraints{
            $0.top.equalToSuperview().offset(16)
            $0.centerX.equalToSuperview()
        }
        separatorLine.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview()
        }
        itemsStackView.snp.makeConstraints{
            $0.top.equalTo(titleLabel.snp.bottom).offset(30)
            $0.bottom.equalToSuperview().inset(22)
            $0.leading.trailing.equalToSuperview()
        }
    }
}
