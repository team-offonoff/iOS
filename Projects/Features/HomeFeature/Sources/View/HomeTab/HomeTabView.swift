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
    
    private let titleFrame: TitleFrame = TitleFrame()
    private let scrollFrame: ScrollFrame = ScrollFrame()
    private let buttonFrame: ButtonFrame = ButtonFrame()
    let chatBottomSheetFrame: HomeChatBottomSheetView = HomeChatBottomSheetView()
    
    override func hierarchy() {
        addSubviews([titleFrame, scrollFrame, buttonFrame, chatBottomSheetFrame])
    }
    
    override func layout() {
        titleFrame.snp.makeConstraints{
            $0.top.leading.trailing.equalToSuperview()
        }
        scrollFrame.snp.makeConstraints{
            $0.top.equalTo(titleFrame.snp.bottom).offset(12)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        buttonFrame.snp.makeConstraints{
            $0.top.equalTo(titleFrame.snp.bottom).offset(26)
            $0.leading.trailing.equalToSuperview()
        }
    }
    
    override func initialize() {
        addMoveButtonTarget()
        setPanGestureRecognizer()
    }
    
    private func addMoveButtonTarget(){
        buttonFrame.nextButton.addTarget(self, action: #selector(moveNextTopic), for: .touchUpInside)
        buttonFrame.previousButton.addTarget(self, action: #selector(movePreviousTopic), for: .touchUpInside)
    }
    
    @objc private func moveNextTopic(){
        scrollFrame.moveNext()
    }
    
    @objc private func movePreviousTopic(){
        scrollFrame.movePrevious()
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
        
        chatBottomSheetFrame.snp.makeConstraints{
            $0.top.equalTo(cell.userFrame.snp.bottom).offset(20)
            $0.height.equalTo(self).offset(-BOTTOM_SHEET_TOP_PADDING)
            $0.leading.trailing.equalToSuperview()
        }
    }
    
    private func setPanGestureRecognizer(){
        let viewPan = UIPanGestureRecognizer(target: self, action: #selector(viewPanned))
        viewPan.delaysTouchesBegan = false
        viewPan.delaysTouchesEnded = false
        chatBottomSheetFrame.addGestureRecognizer(viewPan)
    }
    
    @objc private func viewPanned(_ recognizer: UIPanGestureRecognizer){
        let translation = recognizer.translation(in: chatBottomSheetFrame)
        switch recognizer.state {
        case .began:
            if defaultY == nil {
                defaultY = chatBottomSheetFrame.frame.minY
            }
            originalPoint = chatBottomSheetFrame.frame.origin
        case .changed:
            chatBottomSheetFrame.frame.origin = CGPoint(y: originalPoint.y + translation.y)
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
                    self.chatBottomSheetFrame.frame.origin = movePoint
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
}

private extension CGPoint {
    init(y: CGFloat){
        self.init(x: 0, y: y)
    }
}
