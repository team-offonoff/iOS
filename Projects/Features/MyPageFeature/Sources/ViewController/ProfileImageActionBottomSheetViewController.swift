//
//  ProfileImageActionBottomSheetViewController.swift
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

final class ProfileImageActionBottomSheetViewController: ActionBottomSheetViewController {
    
    init() {
        super.init(actions: Profile.Image.Action.allCases)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    weak var coordinator: MyPageCoordinator?
    
    override func tap(action: BottomSheetAction) {
        guard let action = action as? Profile.Image.Action else { return }
        switch action {
        case .takePicture:
            //일단 보류
            return
        case .gallery:
            dismiss(animated: true) {
                NotificationCenter.default.post(name: Notification.Name(Profile.Image.Action.gallery.identifier), object: nil)
            }
        case .delete:
            dismiss(animated: true) {
                self.coordinator?.startDeleteProfileImageBottomSheet()
            }
            return
        }
    }
}

extension Profile.Image.Action: BottomSheetAction {
    public var content: BottomSheetActionContent {
        switch self {
        case .takePicture:  return TakePictureActionContent()
        case .gallery:      return AlbumActionContent()
        case .delete:       return DeleteActionContent()
        }
    }
}

fileprivate struct TakePictureActionContent: BottomSheetActionContent {
    let defaultIcon: UIImage = Image.takePicture
    let disabledIcon: UIImage? = nil
    let title: String = "사진 찍기"
}

fileprivate struct AlbumActionContent: BottomSheetActionContent {
    let defaultIcon: UIImage = Image.gallery
    let disabledIcon: UIImage? = nil
    let title: String = "앨범에서 가져오기"
}

fileprivate struct DeleteActionContent: BottomSheetActionContent {
    let defaultIcon: UIImage = Image.delete
    let disabledIcon: UIImage? = nil
    let title: String = "현재 사진 삭제하기"
}
