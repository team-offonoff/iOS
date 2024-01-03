//
//  LoadingTableViewCell.swift
//  HomeFeature
//
//  Created by 박소윤 on 2024/01/03.
//  Copyright © 2024 AB. All rights reserved.
//

import Foundation
import UIKit
import ABKit

final class LoadingTableViewCell: BaseTableViewCell {
    
    private let loadingView = UIActivityIndicatorView()
    
    override func hierarchy() {
        super.hierarchy()
        baseView.addSubview(loadingView)
    }
    
    override func layout() {
        super.layout()
        loadingView.snp.makeConstraints{
            $0.centerY.centerX.equalToSuperview()
        }
    }
    
    func startLoading(){
        loadingView.startAnimating()
    }
}
