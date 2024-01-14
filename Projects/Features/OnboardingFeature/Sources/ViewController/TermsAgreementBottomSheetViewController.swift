//
//  TermsAgreementBottomSheetViewController.swift
//  OnboardingFeature
//
//  Created by 박소윤 on 2024/01/13.
//  Copyright © 2024 AB. All rights reserved.
//

import Foundation
import UIKit
import ABKit
import OnboardingFeatureInterface
import Domain

final class TermsAgreementBottomSheetViewController: BaseBottomSheetViewController<TermsAgreementView> {
    
    init(viewModel: TermsAgreementViewModel) {
        self.viewModel = viewModel
        super.init(mainView: TermsAgreementView())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    weak var coordinator: OnboardingCoordinator?
    private var viewModel: TermsAgreementViewModel
    
    override func style() {
        super.style()
        insets = UIEdgeInsets()
    }
    
    override func detent() -> CGFloat {
        382
    }
    
    override func initialize() {
        mainView.allAgreement.agreementButton.tapPublisher
            .sink{ [weak self] _ in
                self?.viewModel.toggleAll()
            }
            .store(in: &cancellable)
        
        mainView.agreementCells.forEach{ cell in
            cell.agreementButton.tapPublisher
                .sink{ [weak self] _ in
                    self?.viewModel.toggle(term: cell.term)
                }
                .store(in: &cancellable)
        }
        
        mainView.ctaButton.tapPublisher
            .sink{ [weak self] _ in
                self?.viewModel.register()
            }
            .store(in: &cancellable)
    }
    
    override func bind() {
        viewModel.allAgreementSubject
            .sink{ [weak self] value in
                guard let self = self else { return }
                self.mainView.allAgreement.isChecked = value
            }
            .store(in: &cancellable)
        
        viewModel.serviceUseSubject
            .sink{ [weak self] value in
                guard let self = self else { return }
                self.mainView.agreementCells[Term.serviceUse.rawValue].isChecked = value
            }
            .store(in: &cancellable)
        
        viewModel.privacySubject
            .sink{ [weak self] value in
                guard let self = self else { return }
                self.mainView.agreementCells[Term.privacy.rawValue].isChecked = value
            }
            .store(in: &cancellable)
        
        viewModel.marketingSubject
            .sink{ [weak self] value in
                guard let self = self else { return }
                self.mainView.agreementCells[Term.marketing.rawValue].isChecked = value
            }
            .store(in: &cancellable)
        
        viewModel.canMove
            .sink{ [weak self] value in
                guard let self = self else { return }
                self.mainView.ctaButton.isEnabled = value
            }
            .store(in: &cancellable)
        
        viewModel.successRegister = {
            DispatchQueue.main.async {
                self.dismiss(animated: true) {
                    self.coordinator?.startHome()
                }
            }
        }
    }
}
