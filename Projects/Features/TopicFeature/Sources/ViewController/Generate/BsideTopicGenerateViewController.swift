//
//  BsideTopicGenerateViewController.swift
//  TopicFeature
//
//  Created by 박소윤 on 2024/01/21.
//  Copyright © 2024 AB. All rights reserved.
//

import Foundation
import UIKit
import ABKit
import TopicFeatureInterface
import FeatureDependency
import Domain
import Core
import PhotosUI

final class BsideTopicGenerateViewController: BaseViewController<TopicGenerateHeaderView, TopicGenerateBSideSecondView, DefaultTopicGenerateCoordinator> {
    
    init(viewModel: any TopicGenerateViewModel) {
        self.viewModel = viewModel
        super.init(headerView: TopicGenerateHeaderView(), mainView: TopicGenerateBSideSecondView())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var viewModel: any TopicGenerateViewModel
    
    private var imagePickerOption: Choice.Option?
    private var selectedContentTypeChip: TopicGenerateBSideSecondView.ContentTypeChip? {
        willSet {
            newValue?.isSelected = true
        }
        didSet {
            oldValue?.isSelected = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.contentType.send(.text)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    override func initialize() {
        
        setHeaderViewTopicSide()
        contentType()
        bindTopicInformation()
        limitCount()
        addSwitchTarget()
        addRegisterTarget()
        addDeadlineMenu()
        
        func setHeaderViewTopicSide() {
            headerView?.topicSide = viewModel.topicSide
        }
        
        func contentType() {
            [mainView.contentTypeChips.text, mainView.contentTypeChips.image].forEach{
                $0.isUserInteractionEnabled = true
                $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(changeContentType)))
            }
            selectedContentTypeChip = mainView.contentTypeChips.text
        }
        
        func bindTopicInformation() {
            mainView.previousInformation.titleLabel.text = viewModel.tempStorage?.title
            mainView.previousInformation.keywordLabel.text = viewModel.tempStorage?.keyword
        }
        
        func limitCount() {
            mainView.textContentView.setLimitCount(viewModel.limitCount.textOption)
        }
        
        func addSwitchTarget() {
            mainView.optionSwitch.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(optionSwitch)))
        }
        
        func addRegisterTarget() {
            mainView.ctaButton.tapPublisher
                .sink{ [weak self] _ in
                    guard let self = self, let storage = self.viewModel.tempStorage else { return }
                    self.viewModel.register(.init(
                        side: self.viewModel.topicSide.value,
                        keyword: storage.keyword,
                        title: storage.title,
                        choices: [
                            self.viewModel.generateChoice(option: .A, content: self.mainView.view(of: self.viewModel.contentType.value).content(option: .A)!),
                            self.viewModel.generateChoice(option: .B, content: self.mainView.view(of: self.viewModel.contentType.value).content(option: .B)!)
                        ],
                        deadline: UTCTime.current + self.viewModel.deadlinePublisher.value*60
                    ))
                }
                .store(in: &cancellables)
        }
        
        func addDeadlineMenu() {
            mainView.deadlineSection.menu = {
                let children = (1...24).reversed().map{ time in
                    let action = UIAction(title: "\(time)시간 뒤", handler: { _ in
                        self.viewModel.deadlinePublisher.send(time)
                        self.mainView.deadlineSection.deadlineLabel.text = "\(time)시간 뒤"
                    })
                    return action
                }
                return UIMenu(title: "", children: children)
            }()
        }
    }
    
    @objc private func optionSwitch() {
        mainView.view(of: viewModel.contentType.value).switchOption()
    }
    
    @objc private func changeContentType(_ recognizer: UITapGestureRecognizer) {
        
        guard let view = recognizer.view as? TopicGenerateBSideSecondView.ContentTypeChip else { return }
        
        if viewModel.contentType.value != view.contentType {
            selectedContentTypeChip = view
            viewModel.contentType.send(view.contentType)
        }
    }
    
    override func bind() {
        
        bindImagePicker()
        
        viewModel.contentType
            .sink{ [weak self] type in
                self?.mainView.update(to: type)
                self?.updateViewModelInput()
            }
            .store(in: &cancellables)
        
        viewModel.sideBCanSwitchOption
            .sink{ [weak self] canSwitch in
                self?.mainView.optionSwitch.isEnabled = canSwitch
            }
            .store(in: &cancellables)
        
        viewModel.cansideBRegister
            .sink{ [weak self] canRegister in
                self?.mainView.ctaButton.isHidden = !canRegister
                self?.mainView.pageIndicator.isHidden = canRegister
            }
            .store(in: &cancellables)
        
        viewModel.successRegister = {
            DispatchQueue.main.async {
                self.dismiss(animated: true)
            }
        }
        
        func bindImagePicker() {
            NotificationCenter.default
                .publisher(for: Notification.Name( Topic.Action.showImagePicker.identifier), object: mainView.imageContentView)
                .receive(on: DispatchQueue.main)
                .sink{ [weak self] object in
                    
                    guard let self = self else { return }
                    
                    self.imagePickerOption = object.userInfo?[Choice.Option.identifier] as? Choice.Option
                    
                    //이미지가 존재하는 경우 팝업을 보여주고, 이미지가 없는 경우 피커를 띄워준다
                    if let option = self.imagePickerOption, let image = self.mainView.imageContentView.content(option: self.imagePickerOption!) as? UIImage {
                        DispatchQueue.main.async {
                            self.coordinator?.startPopUp(option: option, image: image)
                        }
                    }
                    else {
                        self.present(imagePicker(), animated: true)
                    }
                    
                    func imagePicker() -> PHPickerViewController {
                        var configuration = PHPickerConfiguration()
                        configuration.selectionLimit = 1
                        configuration.filter = .images
                        let picker = PHPickerViewController(configuration: configuration)
                        picker.delegate = self
                        return picker
                    }
                }
                .store(in: &cancellables)
        }
    }
    
    private func updateViewModelInput() {
        viewModel.sideBChoiceInput(
            content: .init(
                choiceA: mainView.view(of: viewModel.contentType.value).contentA,
                choiceB: mainView.view(of: viewModel.contentType.value).contentB)
        )
    }
}

extension BsideTopicGenerateViewController: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {

        picker.dismiss(animated: true) {
            
            guard let itemProvider = results.first?.itemProvider else { return }
            
            if itemProvider.canLoadObject(ofClass: UIImage.self) {
                itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                    guard let self = self, let image = image as? UIImage, let option = self.imagePickerOption else { return }
                    DispatchQueue.main.async {
                        self.mainView.imageContentView.setImage(image, option: option)
                    }
                }
            }
        }
    }
}
