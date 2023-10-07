//
//  ChatHeaderFrame
//  HomeFeature
//
//  Created by 박소윤 on 2023/09/27.
//  Copyright © 2023 AB. All rights reserved.
//

import UIKit
import ABKit

extension HomeChatBottomSheetView {
    
    final class ChatHeaderFrame: BaseView {
        
        let voteFrame: InfoStackView = InfoStackView(title: "투표")
        let chatFrame: InfoStackView = InfoStackView(title: "댓글")
        
        private let borderLine: UIView = {
            let view = UIView()
            view.backgroundColor = Color.black20
            return view
        }()
        
        override func hierarchy() {
            addSubviews([voteFrame, chatFrame, borderLine])
        }
        
        override func layout() {
            self.snp.makeConstraints{
                $0.height.equalTo(50)
            }
            voteFrame.snp.makeConstraints{
                $0.leading.equalToSuperview().offset(24)
                $0.centerY.equalToSuperview()
            }
            chatFrame.snp.makeConstraints{
                $0.leading.equalTo(voteFrame.snp.trailing).offset(12)
                $0.centerY.equalToSuperview()
            }
            borderLine.snp.makeConstraints{
                $0.height.equalTo(1)
                $0.leading.trailing.bottom.equalToSuperview()
            }
        }
    }
}

extension HomeChatBottomSheetView.ChatHeaderFrame {
    
    final class InfoStackView: BaseStackView {
        
        private let titleLabel: UILabel = {
            let label = UILabel()
            label.textColor = Color.white80
            label.setTypo(Pretendard.bold15)
            return label
        }()
        
        private let countLabel: UILabel = {
            let label = UILabel()
            label.text = "00"
            label.textColor = Color.white60
            label.setTypo(Pretendard.regular15)
            return label
        }()
        
        init(title: String){
            super.init()
            titleLabel.text = title
        }
        
        required init(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func style() {
            axis = .horizontal
            spacing = 4
        }
        
        override func hierarchy() {
            addArrangedSubviews([titleLabel, countLabel])
        }
        
        func binding(data count: String){
            countLabel.text = count
        }
    }
}
