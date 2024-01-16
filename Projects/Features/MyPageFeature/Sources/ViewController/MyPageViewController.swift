//
//  MyPageViewController.swift
//  MyPageFeature
//
//  Created by 박소윤 on 2024/01/16.
//  Copyright © 2024 AB. All rights reserved.
//

import Foundation
import UIKit
import ABKit
import MyPageFeatureInterface
import FeatureDependency
import Domain
import PhotosUI

final class MyPageViewController: BaseViewController<HeaderView, MyPageView, DefaultMyPageCoordinator> {
    
    init(viewModel: any MyPageViewModel) {
        self.viewModel = viewModel
        super.init(headerView: HeaderView(title: "MY"), mainView: MyPageView())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let viewModel: any MyPageViewModel
    
    override func initialize() {
        
        addGalleryNotificationObserver()
        
        mainView.imageModifyButton.tapPublisher
            .sink{ [weak self] _ in
                self?.coordinator?.startProfileImageActionBottomSheet()
            }
            .store(in: &cancellables)
        
        func addGalleryNotificationObserver() {
            NotificationCenter.default.publisher(for: Notification.Name(Profile.Image.Action.gallery.identifier))
                .sink{ [weak self] _ in
                    //갤러리 보여주기
                    self?.present(imagePicker(), animated: true)
                    
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
    
    override func bind() {
        viewModel.profileImage
            .receive(on: DispatchQueue.main)
            .sink{ [weak self] url in
                self?.mainView.profileImageView.image = nil
            }
            .store(in: &cancellables)
    }
}

extension MyPageViewController: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {

        picker.dismiss(animated: true) {
            
            guard let itemProvider = results.first?.itemProvider else { return }
            
            if itemProvider.canLoadObject(ofClass: UIImage.self) {
                itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                    guard let self = self, let image = image as? UIImage else { return }
                    self.viewModel.modifyImage(image)
                }
            }
        }
    }
}
