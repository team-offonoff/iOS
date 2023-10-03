//
//  HomeTabView.swift
//  HomeFeature
//
//  Created by 박소윤 on 2023/09/25.
//  Copyright © 2023 AB. All rights reserved.
//

import ABKit
import UIKit

final public class HomeTabView: BaseView {
    
    let topicFrame: TopicFrame = TopicFrame()
    let selectionFrame: SelectionFrame = SelectionFrame()
    let userFrame: UserFrame = UserFrame()
    let chatBottomSheetFrame: HomeChatBottomSheetView = HomeChatBottomSheetView()
    
    public override func style() {
        [self, topicFrame, selectionFrame, userFrame].forEach{
            $0.backgroundColor = Color.transparent
        }
    }
    
    public override func hierarchy() {
        addSubviews([topicFrame, selectionFrame, userFrame, chatBottomSheetFrame])
    }
    
    public override func layout() {
        topicFrame.snp.makeConstraints{
            $0.top.equalToSuperview().offset(2)
            $0.leading.trailing.equalToSuperview()
        }
        selectionFrame.snp.makeConstraints{
            $0.top.equalTo(topicFrame.snp.bottom).offset(37)
            $0.leading.trailing.equalToSuperview()
        }
        userFrame.snp.makeConstraints{
            $0.top.equalTo(selectionFrame.snp.bottom).offset(49)
            $0.leading.trailing.equalToSuperview()
        }
        setBottomSheetFrameLayout()
    }
    
    public override func initialize() {
        setPanGestureRecognizer()
    }
    
    //MARK: - BottomSheet
    
    enum BottomSheetViewState {
        case expanded
        case normal
    }
    
    private let BOTTOM_SHEET_TOP_PADDING: CGFloat = 2
    
    private var originalPoint: CGPoint = CGPoint()
    private var defaultY: CGFloat!
    private var state: BottomSheetViewState = .normal
    
    private func setBottomSheetFrameLayout(){
        chatBottomSheetFrame.snp.makeConstraints{
            $0.top.equalTo(userFrame.snp.bottom).offset(20)
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
        if defaultY == nil {
            defaultY = chatBottomSheetFrame.frame.minY
        }
    }
}

private extension CGPoint {
    init(y: CGFloat){
        self.init(x: 0, y: y)
    }
}
