//
//  VoteResultView.swift
//  TopicFeature
//
//  Created by 박소윤 on 2024/02/20.
//  Copyright © 2024 AB. All rights reserved.
//

import Foundation
import UIKit
import ABKit
import FeatureDependency
import Domain
import TopicFeatureInterface

public final class VoteResultView: BaseView {
    
    private let win: Win = Win()
    private let explainLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(r: 255, g: 231, b: 162)
        label.setTypo(Pretendard.semibold13)
        return label
    }()
    private let lose: Lose = Lose()
    
    public override func hierarchy() {
        addSubviews([win.contentView, win.crownImageView, explainLabel, lose.contentView])
        win.contentView.addSubviews([win.mark, win.optionLabel, win.contentLabel, win.voteAndPercentageLabel])
        lose.contentView.addSubviews([lose.mark, lose.contentLabel, lose.percentageLabel])
    }
    
    public override func layout() {
        
        winLayout()
        loseLayout()
        explainLabel.snp.makeConstraints{
            $0.top.equalTo(win.contentView.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
        }
        
        func winLayout() {
            win.contentView.snp.makeConstraints{
                $0.height.equalTo(148)
                $0.top.leading.trailing.equalToSuperview()
            }
            win.crownImageView.snp.makeConstraints{
                $0.bottom.equalTo(self.snp.top)
                $0.centerX.equalToSuperview()
            }
            win.mark.snp.makeConstraints{
                $0.top.equalToSuperview().offset(8)
                $0.leading.equalToSuperview().offset(16)
            }
            win.optionLabel.snp.makeConstraints{
                $0.centerX.equalToSuperview()
                $0.centerY.equalToSuperview().offset(20)
            }
            win.contentLabel.snp.makeConstraints{
                $0.width.equalTo(130)
                $0.height.equalTo(73)
                $0.centerX.equalToSuperview()
                $0.top.equalToSuperview().offset(24)
            }
            win.voteAndPercentageLabel.snp.makeConstraints{
                $0.top.equalTo(win.contentLabel.snp.bottom).offset(5)
                $0.centerX.equalToSuperview()
                $0.bottom.equalToSuperview().inset(24)
            }
        }
        
        func loseLayout() {
            lose.contentView.snp.makeConstraints{
                $0.top.equalTo(explainLabel.snp.bottom).offset(32)
                $0.leading.trailing.equalToSuperview().inset(20)
                $0.height.equalTo(43)
            }
            lose.mark.snp.makeConstraints{
                $0.centerY.equalToSuperview()
                $0.leading.equalToSuperview().offset(16)
            }
            lose.contentLabel.snp.makeConstraints{
                $0.leading.equalTo(lose.mark.snp.trailing).offset(12)
                $0.centerY.equalToSuperview()
                $0.top.equalToSuperview().offset(12.5)
                $0.trailing.lessThanOrEqualToSuperview().inset(80)
            }
            lose.percentageLabel.snp.makeConstraints{
                $0.trailing.equalToSuperview().inset(16)
                $0.centerY.equalToSuperview()
            }
        }
    }
    
    func fill(_ topic: TopicDetailItemViewModel) {
        
//        isHidden = 토픽 종료 ? false : true
        isHidden = true
        
        win.contentView.backgroundColor = Choice.Option.A.content.color
        win.contentView.layer.cornerRadius = 148/2
        win.contentView.layer.maskedCorners = Choice.Option.A.content.corenrMask
        win.optionLabel.text = Choice.Option.A.content.title
        win.contentLabel.text = "ㄴㄴ 학원 안다니면 한계가 있음"
        win.voteAndPercentageLabel.text = "(520명) 60%"
        
        explainLabel.text = "내가 고른 선택지가 이겼어요!"
        
        lose.contentView.backgroundColor = Choice.Option.B.content.color.withAlphaComponent(0.2)
        lose.contentLabel.text = "ㅇㅇ 콜로소만 들어도 가능 (382명)"
        lose.percentageLabel.text = "60%"
    }
    
}

extension VoteResultView {
    class Win {
        let contentView: UIView = {
            let view = UIView()
            view.layer.masksToBounds = true
            return view
        }()
        let crownImageView: UIImageView = UIImageView(image: Image.winnerCrown)
        let mark: UIImageView = UIImageView(image: Image.winMark)
        let contentLabel: UILabel = {
            let label = UILabel()
            label.numberOfLines = 0
            label.textColor = Color.white
            label.setTypo(Pretendard.semibold18, setLineSpacing: true)
            label.textAlignment = .center
            return label
        }()
        let optionLabel: UILabel = {
            let label = UILabel()
            label.textColor = Color.white20
            label.setTypo(Pretendard.black200)
            return label
        }()
        let voteAndPercentageLabel: UILabel = {
            let label = UILabel()
            label.textColor = Color.white
            label.setTypo(Pretendard.semibold14)
            return label
        }()
    }
    
    class Lose {
        let contentView: UIView = {
            let view = UIView()
            view.layer.cornerRadius = 10
            return view
        }()
        let mark: UIImageView = UIImageView(image: Image.loseMark)
        let contentLabel: UILabel = {
            let label = UILabel()
            label.textColor = Color.white60
            label.setTypo(Pretendard.regular13)
            return label
        }()
        let percentageLabel: UILabel = {
            let label = UILabel()
            label.textColor = Color.white60
            label.setTypo(Pretendard.regular13)
            return label
        }()
    }
}
