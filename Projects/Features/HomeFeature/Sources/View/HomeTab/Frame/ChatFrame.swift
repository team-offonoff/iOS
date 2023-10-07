//
//  ChatView.swift
//  HomeFeature
//
//  Created by 박소윤 on 2023/09/27.
//  Copyright © 2023 AB. All rights reserved.
//

import UIKit
import ABKit

extension HomeChatBottomSheetView {
    
    final class ChatFrame: BaseView {
        
        private let blurView: UIVisualEffectView = {
            let blurEffect = UIBlurEffect(style: .regular)
            let blurView = UIVisualEffectView(effect: blurEffect)
            return blurView
        }()
        
        let tableView: UITableView = {
           let tableView = UITableView()
            tableView.backgroundColor = .clear
            return tableView
        }()
        
        private let voteRequestLabel: UILabel = {
           let label = UILabel()
            label.text = "투표 후 반응을 확인해보세요!"
            label.textColor = Color.white
            label.setTypo(Pretendard.semibold20)
            return label
        }()
        
        override func style() {
            backgroundColor = .clear
            blurView.isHidden = true
        }
        
        override func hierarchy() {
            addSubviews([tableView, voteRequestLabel, blurView])
        }
        
        override func layout() {
            tableView.snp.makeConstraints{
                $0.top.leading.trailing.bottom.equalToSuperview()
            }
            blurView.snp.makeConstraints{
                $0.top.leading.trailing.bottom.equalToSuperview()
            }
            voteRequestLabel.snp.makeConstraints{
                $0.centerX.equalToSuperview()
                $0.top.equalToSuperview().offset(20)
            }
        }
    }
}
