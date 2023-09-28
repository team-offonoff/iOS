//
//  BaseHeaderView.swift
//  ABKit
//
//  Created by 박소윤 on 2023/09/28.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation

public class BaseHeaderView: BaseView {
    
    public override init() {
        super.init()
        setDefaultLayout()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setDefaultLayout(){
        self.snp.makeConstraints{
            $0.height.equalTo(48)
        }
    }
}
