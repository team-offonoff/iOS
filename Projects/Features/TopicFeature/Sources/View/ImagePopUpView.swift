//
//  ImagePopUpView.swift
//  TopicFeature
//
//  Created by 박소윤 on 2023/12/10.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation
import UIKit
import ABKit
import Domain

public final class ImagePopUpView: BaseView {
    
    private let contentStackView: UIStackView = {
        let stackView = UIStackView(axis: .vertical, spacing: 0)
        stackView.layer.cornerRadius = 10
        stackView.layer.masksToBounds = true
        return stackView
    }()
    let closeButton: UIButton = {
        let button = UIButton()
        button.setImage(Image.imageExpandDismiss, for: .normal)
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
        label.setTypo(Pretendard.black200, setLineSpacing: true)
        return label
    }()
    let previewLabel: PaddingLabel = {
       let label = PaddingLabel(topBottom: 2, leftRight: 13)
        label.setTypo(Pretendard.regular14)
        label.backgroundColor = Color.black20
        label.textColor = Color.white60
        label.layer.cornerRadius = 24/2
        label.layer.masksToBounds = true
        label.snp.makeConstraints{
            $0.height.equalTo(24)
        }
        return label
    }()
    
    public override func hierarchy() {
        addSubview(contentStackView)
        contentStackView.addArrangedSubviews([imageView, optionBackgroundView])
        contentStackView.addSubview(closeButton)
        optionBackgroundView.addSubviews([optionLabel, previewLabel])
    }
    
    public override func layout() {
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
        previewLabel.snp.makeConstraints{
            $0.center.equalToSuperview()
        }
    }
    
    func fill(_ choice: Choice, isPreview: Bool = false) {
        previewLabel.isHidden = !isPreview
        previewLabel.text = "\(choice.option.content.title) 선택지 미리보기"
        optionBackgroundView.backgroundColor = choice.option.content.color
        optionLabel.text = choice.option.content.title
    }
    
    func fill(option: Choice.Option, image: UIImage, isPreview: Bool = false) {
        previewLabel.isHidden = !isPreview
        previewLabel.text = "\(option.content.title) 선택지 미리보기"
        optionBackgroundView.backgroundColor = option.content.color
        optionLabel.text = option.content.title
        imageView.image = image
    }
}
