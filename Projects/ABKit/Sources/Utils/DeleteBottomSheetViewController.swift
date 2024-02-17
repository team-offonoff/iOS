//
//  DeleteBottomSheetViewController.swift
//  ABKit
//
//  Created by 박소윤 on 2024/02/16.
//  Copyright © 2024 AB. All rights reserved.
//

import Foundation
import UIKit
import Combine
import Core

public protocol DeleteBottomSheetViewModel {
    var deleteItem: PassthroughSubject<Index, Never> { get }
    func delete(at index: Int?)
}

public final class DeleteBottomSheetViewController: BaseBottomSheetViewController<DeleteBottomSheetViewController.DeleteBottomSheetView> {
 
    public init(title: String, index: Int, viewModel: any DeleteBottomSheetViewModel) {
        self.index = index
        self.viewModel = viewModel
        super.init(mainView: DeleteBottomSheetView())
        mainView.titleLabel.text = title
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let index: Int
    private let viewModel: any DeleteBottomSheetViewModel
    
    public override func detent() -> CGFloat {
        183
    }
    
    public override func initialize() {
        
        mainView.deleteItem.tapPublisher
            .sink{ [weak self] _ in
                guard let self = self else { return }
                self.viewModel.delete(at: self.index)
            }
            .store(in: &cancellable)
        
        mainView.cancelItem.tapPublisher
            .sink{ [weak self] _ in
                self?.dismiss(animated: true)
            }
            .store(in: &cancellable)
            
    }
    
    public override func bind() {
        viewModel.deleteItem
            .receive(on: DispatchQueue.main)
            .sink{ [weak self] _ in
                self?.dismiss(animated: true)
            }
            .store(in: &cancellable)
    }
}

extension DeleteBottomSheetViewController {
    
    public final class DeleteBottomSheetView: BaseView {
        
        let titleLabel: UILabel = {
            let label = UILabel()
            label.textColor = Color.black60
            label.setTypo(Pretendard.regular15)
            return label
        }()
        private let itemsStackView: UIStackView = {
            let stackView = UIStackView(axis: .vertical, spacing: 22)
            stackView.alignment = .center
            return stackView
        }()
        let deleteItem: UIButton = {
            let attributedTitle = NSMutableAttributedString("삭제하기")
            attributedTitle.addAttributes([.foregroundColor: Color.subPurple2, .font: Pretendard.medium18.font], range: NSRange(location: 0, length: attributedTitle.length))
            var configuration = UIButton.Configuration.plain()
            configuration.attributedTitle = AttributedString(attributedTitle)
            let button =  UIButton(configuration: configuration)
            return button
        }()
        private let separatorLine: SeparatorLine = SeparatorLine(color: Color.black20, height: 1)
        let cancelItem: UIButton = {
            let attributedTitle = NSMutableAttributedString("취소")
            attributedTitle.addAttributes([.foregroundColor: Color.black40, .font: Pretendard.medium18.font], range: NSRange(location: 0, length: attributedTitle.length))
            var configuration = UIButton.Configuration.plain()
            configuration.attributedTitle = AttributedString(attributedTitle)
            return UIButton(configuration: configuration)
        }()
        
        public override func hierarchy() {
            addSubviews([titleLabel, itemsStackView])
            itemsStackView.addArrangedSubviews([deleteItem, separatorLine, cancelItem])
        }
        
        public override func layout() {
            titleLabel.snp.makeConstraints{
                $0.top.equalToSuperview().offset(16)
                $0.centerX.equalToSuperview()
            }
            separatorLine.snp.makeConstraints{
                $0.leading.trailing.equalToSuperview()
            }
            itemsStackView.snp.makeConstraints{
                $0.top.equalTo(titleLabel.snp.bottom).offset(30)
                $0.bottom.equalToSuperview().inset(22)
                $0.leading.trailing.equalToSuperview()
            }
        }
    }

}
