//
//  TermListView.swift
//  MyPageFeature
//
//  Created by 박소윤 on 2024/01/16.
//  Copyright © 2024 AB. All rights reserved.
//

import Foundation
import UIKit
import ABKit
import FeatureDependency
import Domain

final class TermListView: BaseView {
    
    var termCells: [TermMoveCell] {
        termsStackView.subviews.map{ $0 as! TermMoveCell }
    }
    
    private let termsStackView: UIStackView = {
       let stackView = UIStackView(axis: .vertical, spacing: 32)
        stackView.alignment = .leading
        return stackView
    }()

    override func hierarchy() {
        
        addSubview(termsStackView)
        
        Term.allCases.forEach{
            let cell = TermMoveCell(term: $0)
            termsStackView.addArrangedSubview(cell)
        }
    }
    
    override func layout() {
        termsStackView.snp.makeConstraints{
            $0.top.equalToSuperview().offset(50)
            $0.leading.equalToSuperview().offset(27)
            $0.bottom.lessThanOrEqualToSuperview()
        }
    }
    
}

extension TermListView {
    
    final class TermMoveCell: MyPageView.MoveCell {
        
        init(term: Term) {
            self.term = term
            super.init(title: term.title)
        }
        
        required init(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        let term: Term
    }
}
