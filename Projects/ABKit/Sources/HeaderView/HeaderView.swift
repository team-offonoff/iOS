//
//  HeaderView.swift
//  ABKit
//
//  Created by 박소윤 on 2023/09/28.
//  Copyright © 2023 AB. All rights reserved.
//

import UIKit

public class HeaderView: BaseHeaderView, HeaderTouchable {
    
    public convenience init(title: String){
        self.init(title: title, icon: nil, selectedIcon: nil)
    }
    
    public convenience init(icon: UIImage){
        self.init(title: nil, icon: icon, selectedIcon: nil)
    }
    
    public convenience init(icon: UIImage, selectedIcon: UIImage){
        self.init(title: nil, icon: icon, selectedIcon: selectedIcon)
    }
    
    public init(title: String?, icon: UIImage?, selectedIcon: UIImage?){
        super.init()
        self.titleLabel.text = title
        self.rightItem.setImage(icon, for: .normal)
        self.rightItem.setImage(selectedIcon, for: .selected)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let titleLabel: UILabel = {
       let label = UILabel()
        label.textColor = Color.white
        label.setTypo(Pretendard.semibold20)
        return label
    }()
    
    public lazy var rightItem: UIButton = UIButton()
    
    public override func hierarchy() {
        addSubviews([titleLabel, rightItem])
    }
    
    public override func layout() {
        titleLabel.snp.makeConstraints{
            $0.centerX.centerY.equalToSuperview()
        }
        rightItem.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(20)
        }
    }
}
