//
//  ImageContentView.swift
//  TopicFeature
//
//  Created by 박소윤 on 2023/12/31.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation
import UIKit
import ABKit
import Combine
import Domain

extension TopicGenerateBSideSecondView {
    
    class ImageContentView: BaseView, ContentPublisher {
        
        private let commentLabel: PaddingLabel = {
            let label = PaddingLabel(topBottom: 16, leftRight: 16)
            label.text = "가로 세로 길이가 같은 사진을 올리는 것이 좋아요.\n너무 큰 용량의 사진은 화질이 조정될 수 있어요."
            label.setTypo(Pretendard.regular13, setLineSpacing: true)
            label.backgroundColor = Color.white.withAlphaComponent(0.04)
            label.textColor = Color.white40
            label.numberOfLines = 0
            label.layer.cornerRadius = 10
            label.layer.masksToBounds = true
            return label
        }()
        private let imageStackView: UIStackView = UIStackView(axis: .horizontal, spacing: 13)
        private let aImageView: CustomImageView = CustomImageView(option: .A)
        private let bImageView: CustomImageView = CustomImageView(option: .B)
        
        override func hierarchy() {
            addSubviews([commentLabel, imageStackView])
            imageStackView.addArrangedSubviews([aImageView, bImageView])
        }
        
        override func layout() {
            imageStackView.snp.makeConstraints{
                $0.top.equalToSuperview().offset(14)
                $0.centerX.equalToSuperview()
            }
            commentLabel.snp.makeConstraints{
                $0.top.equalTo(imageStackView.snp.bottom).offset(20)
                $0.leading.trailing.bottom.equalToSuperview()
            }
        }
        
        override func initialize() {
            
            addGestureRecognizer()
            
            func addGestureRecognizer() {
                [aImageView, bImageView].forEach{
                    $0.isUserInteractionEnabled = true
                    $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageTap)))
                }
            }
        }
        
        //토픽 생성 ViewController에서 image picker를 띄우도록 알림을 보낸다
        @objc private func imageTap(_ recognizer: UITapGestureRecognizer) {
            
            guard let view = recognizer.view as? CustomImageView else { return }

            NotificationCenter.default
                .post(
                    name: Notification.Name(Topic.Action.showImagePicker.identifier),
                    object: self,
                    userInfo: [Choice.Option.identifier: view.option]
                )
        }
        
        //MARK: Input
        
        func setImage(_ image: UIImage, option: Choice.Option) {
            switch option {
            case .A:    aImageView.imageSubject.send(image)
            case .B:    bImageView.imageSubject.send(image)
            }
        }
        
        func reset() {
            
            resetImageView()
            
            func resetImageView() {
                aImageView.imageSubject.send(nil)
                bImageView.imageSubject.send(nil)
            }
        }
        
        func switchOption() {
            let temp = aImageView.imageSubject.value
            aImageView.imageSubject.send(bImageView.imageSubject.value)
            bImageView.imageSubject.send(temp)
        }
        
        //MARK: Output
        
        var contentA: AnyPublisher<Any?, Never> {
            aImageView.imageSubject.eraseToAnyPublisher()
        }
        var contentB: AnyPublisher<Any?, Never> {
            bImageView.imageSubject.eraseToAnyPublisher()
        }
        func content(option: Choice.Option) -> Any? {
            switch option {
            case .A:    return aImageView.imageSubject.value
            case .B:    return bImageView.imageSubject.value
            }
        }
    }
}

extension TopicGenerateBSideSecondView {
    
    class CustomImageView: BaseStackView {
        
        init(option: Choice.Option) {
            self.option = option
            super.init()
        }
        
        required init(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        //MARK: Output
        
        let option: Choice.Option
        let imageSubject: CurrentValueSubject<Any?, Never> = CurrentValueSubject(nil)
        
        private let imageView: UIImageView = {
            let imageView = UIImageView()
            imageView.layer.cornerRadius = 10
            imageView.layer.masksToBounds = true
            imageView.snp.makeConstraints{
                $0.width.equalTo(122)
                $0.height.equalTo(124)
            }
            imageView.backgroundColor = Color.subNavy2.withAlphaComponent(0.8)
            imageView.isUserInteractionEnabled = true
            return imageView
        }()
        private let bringImageLabel: UILabel = {
            let label = UILabel()
            label.numberOfLines = 0
            label.setTypo(Pretendard.medium15, setLineSpacing: true)
            label.text = "이미지\n가져오기"
            label.textAlignment = .center
            label.textColor = Color.white
            return label
        }()
        private let optionLabel: UILabel = {
            let label = UILabel()
            label.setTypo(Pretendard.black180)
            return label
        }()
        private lazy var cancelButton: UIButton = {
            let button = UIButton()
            button.setImage(Image.topicGenerateImageCancel, for: .normal)
            button.snp.makeConstraints{
                $0.width.height.equalTo(24)
            }
            return button
        }()
        private let optionTag: PaddingLabel = {
           let label = PaddingLabel(topBottom: 2, leftRight: 10)
            label.textColor = Color.subPurple.withAlphaComponent(0.4)
            label.backgroundColor = Color.subNavy2.withAlphaComponent(0.4)
            label.font = Pretendard.semibold13.font
            label.layer.cornerRadius = 22/2
            label.layer.masksToBounds = true
            return label
        }()
//        private let dimView: UIView = {
//            let view = UIView()
//            view.backgroundColor = Color.black.withAlphaComponent(0.6)
//            return view
//        }()
        private var cancellable: Set<AnyCancellable> = []
        
        override func style() {
            axis = .vertical
            alignment = .center
            spacing = 8
        }
        
        override func hierarchy() {
            addArrangedSubviews([imageView, optionTag])
            imageView.addSubviews([optionLabel, bringImageLabel, cancelButton])
        }
        
        override func layout() {
            imageView.snp.makeConstraints{
                $0.top.leading.trailing.equalToSuperview()
            }
//            dimView.snp.makeConstraints{
//                $0.top.leading.trailing.bottom.equalToSuperview()
//            }
            bringImageLabel.snp.makeConstraints{
                $0.centerX.centerY.equalToSuperview()
            }
            optionLabel.snp.makeConstraints{
                $0.top.equalToSuperview().offset(-20)
                $0.centerX.equalToSuperview()
            }
            cancelButton.snp.makeConstraints{
                $0.top.equalToSuperview().offset(8)
                $0.centerX.equalToSuperview()
            }
        }
        
        override func initialize() {
            
            setOptionLabelStyle()
            addTarget()
            addSubscriber()
            
            func setOptionLabelStyle() {
                optionTag.text = "\(option.content.title) 선택지"
                optionLabel.text = option.content.title
                optionLabel.textColor = option.content.color.withAlphaComponent(0.4)
            }
            
            func addTarget() {
                cancelButton.tapPublisher
                    .sink{ [weak self] _ in
                        self?.imageSubject.send(nil)
                    }
                    .store(in: &cancellable)
            }
            
            func addSubscriber() {
                imageSubject
                    .receive(on: DispatchQueue.main)
                    .sink{ [weak self] image in
                        self?.imageView.image = image as? UIImage
                        self?.setComponentVisibility()
                    }
                    .store(in: &cancellable)
            }
        }
        
        //MARK: Input
        
        func setComponentVisibility() {
            if imageView.image == nil {
                bringImageLabel.isHidden = false
                cancelButton.isHidden = true
//                dimView.isHidden = true
            }
            else {
                bringImageLabel.isHidden = true
                cancelButton.isHidden = false
//                dimView.isHidden = false
            }
        }
    }
}
