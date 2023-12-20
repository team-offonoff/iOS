//
//  ToastMessage.swift
//  FeatureDependency
//
//  Created by 박소윤 on 2023/12/10.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation
import UIKit
import Combine

public final class ToastMessage {
    
    private init() {

    }
    
    public static let shared: ToastMessage = ToastMessage()
    private let toastMessageView = ToastMessageView()
    private var isAnimating = false
    private var topViewController: UIWindow?
    private var messageQueue: [String] = []
    private var cancellable: Set<AnyCancellable> = []
    
    public func register(message: String) {
        messageQueue.append(message)
        show()
    }
    
    private func show() {
        
        if isAnimating {
            return
        } else {
            isAnimating = true
        }
        
        prepare()
        start()
        
        func prepare() {
            
            self.topViewController = topViewController()
            setMessage()
            setLayout()
            
            func topViewController() -> UIWindow? {
                UIApplication
                    .shared
                    .connectedScenes
                    .compactMap{ ($0 as? UIWindowScene)?.keyWindow }
                    .last
            }
            
            func setMessage() {
                toastMessageView.messageLabel.text = messageQueue.removeFirst()
            }
            
            func setLayout() {
                self.topViewController?.addSubview(self.toastMessageView)
                self.toastMessageView.snp.makeConstraints{
                    $0.bottom.equalTo(self.topViewController!.snp.top)
                    $0.leading.trailing.equalToSuperview()
                }
            }
        }
        
        func start() {
            
            startShowingAnimation()
            
            func startShowingAnimation() {
                UIView.animate(
                    withDuration: 0.5,
                    delay: 0,
                    options: .curveEaseOut,
                    animations: {
                        self.topViewController?.isUserInteractionEnabled = false
                        self.toastMessageView.transform = CGAffineTransform(translationX: 0, y: self.toastMessageView.bounds.height)
                    },
                    completion: { _ in
                        startHidingAnimation()
                    }
                )
            }
            
            func startHidingAnimation() {
                UIView.animate(
                    withDuration: 0.5,
                    delay: 2,
                    options: .curveEaseOut,
                    animations: {
                        self.toastMessageView.transform = .identity
                    }, completion: { _ in
                        defer {
                            self.isAnimating = false
                            restart()
                        }
                        self.topViewController = nil
                        self.toastMessageView.removeFromSuperview()
                        self.topViewController?.isUserInteractionEnabled = true
                    }
                )
            }
        }
        
        func restart() {
            if !messageQueue.isEmpty {
                show()
            }
        }
    }
}
