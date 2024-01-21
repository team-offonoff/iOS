//
//  TopicGenerateBSideFirstView.swift
//  TopicFeature
//
//  Created by 박소윤 on 2024/01/20.
//  Copyright © 2024 AB. All rights reserved.
//

import Foundation
import UIKit
import ABKit

final class TopicGenerateBSideFirstView: BaseView {
    
    let titleSection: SubtitleView<TopicTitleTextFieldView> = RegularSubtitleView(
        subtitle: "어떤 주제로 물어볼까요?",
        content: TopicTitleTextFieldView()
    )
    private let hashtagLabel: UILabel = {
        let label = UILabel()
        label.textColor = Color.subPurple
        label.text = "#"
        label.setTypo(Pretendard.semibold14)
        return label
    }()
    let keywordSection: SubtitleView<ABTextFieldView> = {
        let subview = RegularSubtitleView(subtitle: "토픽 키워드", content: ABTextFieldView(placeholder: "한글, 영문, 숫자만 가능", insets: UIEdgeInsets(top: 16, left: 35, bottom: 16, right: 40), isErrorNeed: true))
        subview.contentView.textField.customPlaceholder(font: Pretendard.medium16.font)
        subview.contentView.textField.font = Pretendard.medium16.font
        return subview
    }()
    let recommendKeyword: RecommendKeyword = RecommendKeyword()
    let pageIndicator: PageNumberIndicator = {
       let view =  PageNumberIndicator()
        view.cells[0].highlight()
        return view
    }()
    
    override func hierarchy() {
        addSubviews([titleSection, keywordSection, recommendKeyword.titleLabel, recommendKeyword.collectionView, recommendKeyword.commentLabel, pageIndicator])
        keywordSection.contentView.addSubview(hashtagLabel)
    }
    
    override func layout() {
        titleSection.snp.makeConstraints{
            $0.top.equalToSuperview().offset(54)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        keywordSection.snp.makeConstraints{
            $0.top.equalTo(titleSection.snp.bottom).offset(39)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        hashtagLabel.snp.makeConstraints{
            $0.centerY.equalTo(keywordSection.contentView.textField)
            $0.leading.equalToSuperview().offset(16)
        }
        recommendKeyword.titleLabel.snp.makeConstraints{
            $0.top.equalTo(keywordSection.snp.bottom).offset(6)
            $0.leading.equalToSuperview().offset(20)
        }
        recommendKeyword.collectionView.snp.makeConstraints{
            $0.top.equalTo(recommendKeyword.titleLabel.snp.bottom).offset(12)
            $0.height.equalTo(30)
            $0.leading.trailing.equalToSuperview()
        }
        recommendKeyword.commentLabel.snp.makeConstraints{
            $0.top.equalTo(recommendKeyword.collectionView.snp.bottom).offset(12)
            $0.leading.equalToSuperview().offset(20)
            $0.bottom.lessThanOrEqualToSuperview()
        }
        pageIndicator.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(66)
        }
    }
}

extension TopicGenerateBSideFirstView {
    
    class RecommendKeyword {
        
        let titleLabel: UILabel = {
           let label = UILabel()
            label.text = "추천 키워드"
            label.textColor = Color.white60
            label.setTypo(Pretendard.regular15)
            return label
        }()
        let collectionView: UICollectionView = {
            let flowLayout = UICollectionViewFlowLayout()
            flowLayout.minimumInteritemSpacing = 5
            flowLayout.scrollDirection = .horizontal
            
            let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
            collectionView.backgroundColor = Color.transparent
            collectionView.registers(cellTypes: [RecommendKeywordCollectionViewCell.self])
            collectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
            collectionView.showsHorizontalScrollIndicator = false
            return collectionView
        }()
        let commentLabel: UILabel = {
           let label = UILabel()
            label.text = "비속어를 포함한 부적절한 단어의 태그를 입력할 경우\n게시물 삭제 및 이용 제재를 받을 수 있어요."
            label.textColor = Color.white20
            label.setTypo(Pretendard.semibold13, setLineSpacing: true)
            label.numberOfLines = 0
            return label
        }()
    }
}
