//
//  DefaultTopicCoordinator.swift
//  TopicGenerateFeature
//
//  Created by 박소윤 on 2023/12/25.
//  Copyright © 2023 AB. All rights reserved.
//

import UIKit
import TopicFeature
import TopicGenerateFeatureInterface
import Domain
import Data

public class DefaultTopicGenerateCoordinator: TopicGenerateCoordinator {
    
    required public init(window: UIWindow?){
        self.window = window
    }
    
    public init(rootViewController: UIViewController){
        self.rootViewController = rootViewController
    }
    
    private var window: UIWindow?
    private var rootViewController: UIViewController?
    private lazy var topicGenerateViewModel: any TopicGenerateViewModel = DefaultTopicGenerateViewModel(
        topicGenerateUseCase: DefaultGenerateTopicUseCase(repository: DefaultTopicRepository())
    )
    private lazy var navigationController: UINavigationController = {
        let viewController = TopicSideChoiceViewController(viewModel: topicGenerateViewModel)
        viewController.coordinator = self
        return UINavigationController(rootViewController: viewController)
    }()
    
    public func start() {
        if window != nil {
            self.window?.rootViewController = navigationController
        }
        navigationController.modalPresentationStyle = .overFullScreen
        rootViewController?.present(navigationController, animated: true)
    }
    
    public func startTopicGenerate() {
        let viewController = TopicGenerateViewController(viewModel: topicGenerateViewModel)
        viewController.coordinator = self
        navigationController.pushViewController(viewController, animated: true)
    }
    
    public func startBsideTopicGenerate() {
        let viewController = BsideTopicGenerateViewController(viewModel: topicGenerateViewModel)
        viewController.coordinator = self
        navigationController.pushViewController(viewController, animated: true)
    }
    
    public func startPopUp(option: Choice.Option, image: UIImage) {
        let popUpViewController = TopicImagePopUpViewController(option: option, image: image)
        popUpViewController.modalPresentationStyle = .overFullScreen
        navigationController.present(popUpViewController, animated: false)
    }
}
