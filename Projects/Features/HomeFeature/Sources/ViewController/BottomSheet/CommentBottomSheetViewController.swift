//
//  ChatBottomSheetViewController.swift
//  HomeFeature
//
//  Created by 박소윤 on 2023/12/08.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation
import UIKit
import ABKit
import Combine
import HomeFeatureInterface
import FeatureDependency
import Domain
import Core

final class CommentBottomSheetViewController: UIViewController {
    
    ///Summary
    ///
    ///Discussion/Overview
    ///
    /// - Parameters:
    ///     - standard: 댓글 바텀시트의 기준으로 삼는 뷰의 maxY 값
    ///
    init(standard: CGFloat, viewModel: CommentBottomSheetViewModel){
        self.normalStateY = standard + 42
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public weak var coordinator: HomeCoordinator?
    private var viewModel: any CommentBottomSheetViewModel
    private var cancellable: Set<AnyCancellable> = []
    
    private let normalStateY: CGFloat
    private let expandStateY: CGFloat = (Device.safeAreaInsets?.top ?? 0) + 10
    private let commentInputView: CommentInputView = CommentInputView()
    private lazy var normalHeight: CGFloat = Device.height - normalStateY
    private lazy var expandHeight: CGFloat = Device.height - expandStateY
    
    private let contentView: UIView = {
       let view = UIView()
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        return view
    }()
    private let grabberView: UIView = {
       let view = UIView()
        view.backgroundColor = Color.black.withAlphaComponent(0.1)
        view.layer.cornerRadius = 4/2
        view.snp.makeConstraints{
            $0.width.equalTo(40)
            $0.height.equalTo(4)
        }
        return view
    }()
    private let headerView: CommentHeaderView = CommentHeaderView()
    private let tableView: UITableView = {
        let tableView: UITableView = UITableView()
        tableView.separatorStyle = .none
        tableView.registers(cellTypes: [CommentBottomSheetTableViewCell.self])
        return tableView
    }()
    
    override func viewDidLoad() {
        hierarchy()
        layout()
        initialize()
        bind()
        viewModel.fetchComments()
    }

    private func hierarchy() {
        view.addSubviews([contentView, commentInputView])
        contentView.addSubviews([headerView, tableView, grabberView])
    }
    
    private func layout() {
        contentView.snp.makeConstraints{
            $0.top.equalToSuperview().offset(normalStateY)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(normalHeight)
        }
        grabberView.snp.makeConstraints{
            $0.top.equalToSuperview().offset(8)
            $0.centerX.equalToSuperview()
        }
        headerView.snp.makeConstraints{
            $0.top.leading.trailing.equalToSuperview()
        }
        tableView.snp.makeConstraints{
            $0.top.equalTo(headerView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        commentInputView.snp.makeConstraints{
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func initialize() {
        
        setTableViewDelegate()
        addGestureRecognizer()
        
        func setTableViewDelegate() {
            tableView.delegate = self
            tableView.dataSource = self
        }
        
        func addGestureRecognizer() {
            let recognizer = UIPanGestureRecognizer(target: self, action: #selector(panGesture))
            recognizer.delegate = self
            headerView.addGestureRecognizer(recognizer)
            
            tableView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cancelInput)))
        }
    }
    
    @objc private func cancelInput() {
        view.endEditing(true)
    }

    private func bind() {
        
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
            .receive(on: DispatchQueue.main)
            .sink{ [weak self] noti in
                if let keyboardFrame: NSValue = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                    let keyboardRectangle = keyboardFrame.cgRectValue
                    UIView.animate(
                        withDuration: 0.25
                        , animations: { [weak self] in
                            self?.commentInputView.transform = CGAffineTransform(translationX: 0, y: -keyboardRectangle.height)
                        }
                    )
                }
            }
            .store(in: &cancellable)
        
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
            .receive(on: DispatchQueue.main)
            .sink{ [weak self] _ in
                self?.commentInputView.transform = .identity
            }
            .store(in: &cancellable)
        
        //MARK: view model output
        
        viewModel.reloadData = {
            DispatchQueue.main.async {
                self.headerView.fill(self.viewModel.commentsCountTitle)
                self.tableView.reloadData()
            }
        }
        
        viewModel.toggleLikeState
            .receive(on: DispatchQueue.main)
            .sink{ [weak self] index in
                guard let self = self else { return }
                let cell = self.tableView.cellForRow(at: .init(row: index), cellType: CommentBottomSheetTableViewCell.self)
                cell?.state(isLike: self.viewModel.comments[index].isLike, count: self.viewModel.comments[index].likeCountString)
            }
            .store(in: &cancellable)
        
        viewModel.toggleDislikeState
            .receive(on: DispatchQueue.main)
            .sink{ [weak self] index in
                guard let self = self else { return }
                let cell = self.tableView.cellForRow(at: .init(row: index), cellType: CommentBottomSheetTableViewCell.self)
                cell?.state(isDislike: self.viewModel.comments[index].isHate)
            }
            .store(in: &cancellable)
        
        viewModel.deleteItem
            .receive(on: DispatchQueue.main)
            .sink{ [weak self] index in
                guard let self = self else  { return }
                self.headerView.fill(self.viewModel.commentsCountTitle)
                self.tableView.deleteRows(at: [IndexPath(row: index)], with: .fade)
            }
            .store(in: &cancellable)
    }
    
    //MARK: Bottom Sheet Gesture
    
    private enum State {
        case normal
        case expand
        case dismiss
    }
    private var state: State = .normal
    private var originalPoint: CGPoint = CGPoint()
    
    @objc private func panGesture(_ recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: headerView)
        switch recognizer.state {
        case .began:
            originalPoint = contentView.frame.origin
        case .changed:
            contentView.frame.origin.y = originalPoint.y + translation.y
            if abs(translation.y) >= 50 {
                if state == .normal && translation.y <= 0{
                    state = .expand
                }
                else if state == .expand && translation.y > 0 {
                    state = .normal
                    recognizer.state = .ended
                }
                else if state == .normal && translation.y > 0 {
                    state = .dismiss
                }
            }
        case .ended:
            
            if state == .dismiss {
                dismiss(animated: true)
                return
            }
            
            let (location, height): (CGFloat, CGFloat) = {
                switch state {
                case .normal:
                    return (normalStateY, normalHeight)
                case .expand:
                    return (expandStateY, expandHeight)
                default:
                    fatalError()
                }
            }()
            
            UIView.animate(
                withDuration: 0.5,
                animations: {
                    self.contentView.frame.origin = CGPoint(x: 0, y: location)
                },
                completion: { _ in
                    self.contentView.snp.updateConstraints{
                        $0.height.equalTo(height)
                    }
                }
            )
        default:
            return
        }
    }
}

extension CommentBottomSheetViewController: UIGestureRecognizerDelegate {
    //바텀시트 스와이프가 시작되기 전, 테이블 뷰의 크기 잠시 늘림
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        contentView.snp.updateConstraints{
            $0.height.equalTo(expandHeight)
        }
        contentView.layoutIfNeeded()
        return true
    }
}

extension CommentBottomSheetViewController: TapDelegate {
    
    func tap(_ recognizer: DelegateSender) {
        
        guard let indexPath = recognizer.data as? IndexPath else { return }
        let index = indexPath.row
        
        switch recognizer.identifier {
        case Comment.State.like.identifier:
            viewModel.toggleLikeState(at: index)
            
        case Comment.State.dislike.identifier:
            viewModel.toggleDislikeState(at: index)
            
        case Comment.Action.tapEtc.identifier:
            if viewModel.isWriterItem(at: index) {
                coordinator?.startWritersBottomSheet(index: index)
            }
            else {
                coordinator?.startOthersBottomSheet(index: index)
            }
            
        default:
            fatalError()
        }
    }
}

extension CommentBottomSheetViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: CommentBottomSheetTableViewCell.self)
        cell.fill(viewModel.comments[indexPath.row])
        cell.delegate = self
        return cell
    }
}

extension CommentBottomSheetViewController {
    
    final class CommentHeaderView: BaseView {
        
        private let countStackView: UIStackView = UIStackView(axis: .horizontal, spacing: 1)
        private let countLabel: UILabel = {
            let label = UILabel()
            label.textColor = Color.black
            label.setTypo(Pretendard.semibold18)
            return label
        }()
        private let explainLabel: UILabel = {
            let label = UILabel()
            label.text = "의 댓글"
            label.textColor = Color.black40
            label.setTypo(Pretendard.semibold18)
            return label
        }()
        
        override func style() {
            backgroundColor = .white
        }
        
        override func hierarchy() {
            addSubviews([countStackView])
            countStackView.addArrangedSubviews([countLabel, explainLabel])
        }
        
        override func layout() {
            countStackView.snp.makeConstraints{
                $0.top.equalToSuperview().offset(38)
                $0.leading.equalToSuperview().offset(20)
                $0.bottom.equalToSuperview().inset(20)
            }
        }
        
        func fill(_ count: String) {
            countLabel.text = count
        }
    }
}
