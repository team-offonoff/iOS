//
//  BaseTableViewCell.swift
//  ABKit
//
//  Created by 박소윤 on 2023/11/28.
//  Copyright © 2023 AB. All rights reserved.
//

import UIKit
import SnapKit

open class BaseTableViewCell: UITableViewCell, CellReuseable{

    public var indexPath: IndexPath?{
        (superview as? UITableView)?.indexPath(for: self)
    }
    
    public let baseView = UIView()
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        template()
        self.style()
        hierarchy()
        layout()
        initialize()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    final private func template(){
        setBaseView()
        selectedBackgroundView = UIView()
    }
    
    private func setBaseView(){
        baseView.backgroundColor = Color.transparent
        contentView.addSubview(baseView)
        baseView.snp.makeConstraints{
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    open func style() { }
    open func hierarchy() { }
    open func layout() { }
    open func initialize() { }
}
