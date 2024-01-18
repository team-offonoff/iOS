//
//  AlarmListTableViewCell.swift
//  HomeFeature
//
//  Created by 박소윤 on 2024/01/17.
//  Copyright © 2024 AB. All rights reserved.
//

import Foundation
import UIKit
import ABKit
import HomeFeatureInterface

final class AlarmListTableViewCell: BaseTableViewCell {
    
    private let subLayer: UIView = {
        let layer = UIView()
        layer.backgroundColor = Color.black40
        return layer
    }()
    private let newDotView: UIView = {
        let view = UIView()
        view.backgroundColor = Color.subPurple2
        view.snp.makeConstraints{
            $0.width.height.equalTo(10)
        }
        view.layer.cornerRadius = 10/2
        view.layer.masksToBounds = true
        return view
    }()
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.snp.makeConstraints{
            $0.width.height.equalTo(40)
        }
        return imageView
    }()
    private let titleStackView: UIStackView = UIStackView(axis: .vertical, spacing: 8)
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = Color.white
        label.setTypo(Pretendard.medium15, setLineSpacing: true)
        label.numberOfLines = 0
        return label
    }()
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = Color.subPurple
        label.setTypo(Pretendard.regular14, setLineSpacing: true)
        label.numberOfLines = 0
        return label
    }()
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = Color.white40
        label.setTypo(Pretendard.regular13)
        return label
    }()
    
    override func hierarchy() {
        baseView.addSubviews([subLayer, iconImageView, newDotView, titleStackView, timeLabel])
        titleStackView.addArrangedSubviews([titleLabel, subtitleLabel])
    }
    
    override func layout() {
        subLayer.snp.makeConstraints{
            $0.leading.trailing.bottom.top.equalToSuperview()
        }
        iconImageView.snp.makeConstraints{
            $0.top.equalToSuperview().offset(24)
            $0.leading.equalToSuperview().offset(20)
        }
        newDotView.snp.makeConstraints{
            $0.top.leading.equalToSuperview().offset(16)
        }
        titleStackView.snp.makeConstraints{
            $0.top.bottom.equalToSuperview().inset(24)
            $0.leading.equalTo(iconImageView.snp.trailing).offset(16)
            $0.trailing.equalToSuperview().inset(96)
        }
        timeLabel.snp.makeConstraints{
            $0.top.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().inset(20)
        }
    }
    
    func fill(_ alarm: AlarmItemViewModel) {
        iconImageView.image = {
            switch alarm.type {
            case .topicEnd:     return Image.alarmTimer
            case .comment:      return Image.alarmChat
            case .like:         return Image.alarmLike
            case .breakThrough: return Image.alarmCount
            }
        }()
        newDotView.isHidden = !alarm.isNew
//        subtitleLabel.isHidden =
        titleLabel.text = "투표가 마감 되었어요,\n지금 바로 결과를 확인해 보세요!"
        subtitleLabel.text = "성수 치킨 버거의 종결지는? 성수 치킨 버거의 종결지는?"
        timeLabel.text = "방금"
        if alarm.isNew {
            baseView.backgroundColor = Color.subNavy2
            subLayer.isHidden = false
        }
        else {
            baseView.backgroundColor = Color.subNavy
            subLayer.isHidden = true
        }
    }
}
