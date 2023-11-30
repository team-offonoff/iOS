//
//  HomeTabView.swift
//  HomeFeature
//
//  Created by 박소윤 on 2023/10/03.
//  Copyright © 2023 AB. All rights reserved.
//

import UIKit
import ABKit

final class HomeTabView: BaseView {
    
    let scrollFrame: ScrollFrame = ScrollFrame()
    
    override func hierarchy() {
        addSubviews([scrollFrame])
    }
    
    override func layout() {
        scrollFrame.snp.makeConstraints{
            $0.top.equalToSuperview()
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    /*
    override func initialize() {
        setPanGestureRecognizer()
    }
    
    //MARK: - BottomSheet

    enum BottomSheetViewState {
        case expanded
        case normal
    }
    
    private let BOTTOM_SHEET_TOP_PADDING: CGFloat = 2
    
    private var originalPoint: CGPoint = CGPoint()
    private var shouldSetBottomSheetLayout: Bool = true
    private var defaultY: CGFloat!
    private var state: BottomSheetViewState = .normal
    
    private func setBottomSheetFrameLayout(){
        
        guard let cell = scrollFrame.collectionView.cellForItem(at: [0,0]) as? HomeTopicCollectionViewCell else { fatalError() }
        
//        chatBottomSheet.snp.makeConstraints{
//            $0.top.equalTo(cell.userFrame.snp.bottom).offset(20)
//            $0.height.equalTo(self).offset(-BOTTOM_SHEET_TOP_PADDING)
//            $0.leading.trailing.equalToSuperview()
//        }
    }
    
    private func setPanGestureRecognizer(){
        let viewPan = UIPanGestureRecognizer(target: self, action: #selector(viewPanned))
        viewPan.delaysTouchesBegan = false
        viewPan.delaysTouchesEnded = false
        chatBottomSheet.addGestureRecognizer(viewPan)
    }
    
    @objc private func viewPanned(_ recognizer: UIPanGestureRecognizer){
        let translation = recognizer.translation(in: chatBottomSheet)
        switch recognizer.state {
        case .began:
            if defaultY == nil {
                defaultY = chatBottomSheet.frame.minY
            }
            originalPoint = chatBottomSheet.frame.origin
        case .changed:
            chatBottomSheet.frame.origin = CGPoint(y: originalPoint.y + translation.y)
            if abs(translation.y) >= 60 {
                if state == .normal && translation.y <= 0{
                    state = .expanded
                } else if state == .expanded && translation.y >= 0{
                    state = .normal
                }
            }
        case .ended:
            let movePoint: CGPoint = {
                switch state {
                case .normal:
                    return CGPoint(y: defaultY)
                case .expanded:
                    return CGPoint(y: BOTTOM_SHEET_TOP_PADDING)
                }
            }()
            
            UIView.animate(
                withDuration: 0.27,
                animations: {
                    self.chatBottomSheet.frame.origin = movePoint
                })
        default:    return
        }
    }
    
    func setBottomSheetDefaultY(){
        if !shouldSetBottomSheetLayout { return }
        defer{
            shouldSetBottomSheetLayout = false
        }
        setBottomSheetFrameLayout()
    }
     */
}

private extension CGPoint {
    init(y: CGFloat){
        self.init(x: 0, y: y)
    }
}
