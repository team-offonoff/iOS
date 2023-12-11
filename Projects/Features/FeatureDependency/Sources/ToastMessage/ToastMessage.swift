//
//  ToastMessage.swift
//  FeatureDependency
//
//  Created by 박소윤 on 2023/12/10.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation
import UIKit

public final class ToastMessage {
    
    private static let toastMessageView = ToastMessageView()
    
    private init() { }
    
    private static var isAnimating = false

    public static func show(message: String) {
        
        if isAnimating { return }
        
        isAnimating = true
        
        let topViewController = topViewController()

        setMessage()
        setLayout()
        startAnimation()
        
        func topViewController() -> UIWindow? {
            UIApplication
                .shared
                .connectedScenes
                .compactMap{ ($0 as? UIWindowScene)?.keyWindow }
                .last
        }
        
        func setMessage() {
            toastMessageView.messageLabel.text = message
        }
        
        func setLayout() {
            
            topViewController?.addSubview(toastMessageView)

            toastMessageView.snp.makeConstraints{
                $0.bottom.equalTo(topViewController!.snp.top)
                $0.leading.trailing.equalToSuperview()
            }
        }
    
        func startAnimation() {
            startShowingAnimation()
        }
        
        func startShowingAnimation() {
            UIView.animate(
                withDuration: 0.5,
                delay: 0,
                options: .curveEaseOut,
                animations: {
                    topViewController?.isUserInteractionEnabled = false
                    toastMessageView.transform = CGAffineTransform(translationX: 0, y: toastMessageView.bounds.height)
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
                    toastMessageView.transform = .identity
                }, completion: { _ in
                    toastMessageView.removeFromSuperview()
                    topViewController?.isUserInteractionEnabled = true
                    isAnimating = false
                }
            )
        }
    }
    
}
