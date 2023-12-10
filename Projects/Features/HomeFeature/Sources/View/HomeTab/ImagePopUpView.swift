//
//  ImagePopUpView.swift
//  HomeFeature
//
//  Created by 박소윤 on 2023/12/10.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation
import UIKit
import ABKit
import Domain

final class ImagePopUpView: BaseView {
    
    private let contentStackView: UIStackView = {
        let stackView = UIStackView(axis: .vertical, spacing: 0)
        stackView.layer.cornerRadius = 10
        stackView.layer.masksToBounds = true
        return stackView
    }()
    let closeButton: UIButton = {
        let button = UIButton()
        button.setImage(Image.close, for: .normal)
        button.snp.makeConstraints{
            $0.width.height.equalTo(34)
        }
        return button
    }()
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.snp.makeConstraints{
            $0.height.equalTo((Device.width-40)/335*340)
        }
        return imageView
    }()
    private let optionBackgroundView: UIView = {
        let view = UIView()
        view.snp.makeConstraints{
            $0.height.equalTo(148)
        }
        return view
    }()
    private let optionLabel: UILabel = {
        let label = UILabel()
        label.textColor = Color.white20
        label.setTypo(Pretendard.black200, lineSpacing: 280)
        return label
    }()
    
    override func hierarchy() {
        addSubview(contentStackView)
        contentStackView.addArrangedSubviews([imageView, optionBackgroundView])
        contentStackView.addSubview(closeButton)
        optionBackgroundView.addSubview(optionLabel)
    }
    
    override func layout() {
        contentStackView.snp.makeConstraints{
            $0.top.equalToSuperview().offset(162)
            $0.leading.equalToSuperview().offset(20)
            $0.centerY.centerX.equalToSuperview()
        }
        closeButton.snp.makeConstraints{
            $0.leading.top.equalToSuperview().offset(10)
        }
        optionLabel.snp.makeConstraints{
            $0.centerY.equalToSuperview().offset(10)
            $0.centerX.equalToSuperview()
        }
    }
    
    func fill(_ choice: Choice?) {
        optionBackgroundView.backgroundColor = Color.mainA
        optionLabel.text = "A"
        imageView.backgroundColor = .black
    }
}
