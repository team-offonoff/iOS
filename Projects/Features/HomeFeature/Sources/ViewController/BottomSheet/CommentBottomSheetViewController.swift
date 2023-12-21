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
    
    init(viewModel: CommentBottomSheetViewModel){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public weak var coordinator: HomeCoordinator?
    private var viewModel: any CommentBottomSheetViewModel
    private var cancellable: Set<AnyCancellable> = []
    
    private let contentView: UIView = UIView()
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
        view.addSubview(contentView)
        contentView.addSubviews([headerView, tableView])
    }
    
    private func layout() {
        contentView.snp.makeConstraints{
            $0.top.equalToSuperview().offset(250) //TODO: offset 값 조정
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(Device.height-100)
        }
        headerView.snp.makeConstraints{
            $0.top.leading.trailing.equalToSuperview()
        }
        tableView.snp.makeConstraints{
            $0.top.equalTo(headerView.snp.bottom)
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
            headerView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(panGesture)))
        }
    }
    
    private func bind() {
        
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
            contentView.frame.origin = CGPoint(x: 0, y: originalPoint.y + translation.y)
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
            
            let location: CGPoint = {
                switch state {
                case .normal:
                    return CGPoint(x: 0, y: 250)
                case .expand:
                    return CGPoint(x: 0, y: Device.safeAreaInsets?.top ?? 0 + 15)
                default:
                    fatalError()
                }
            }()
            
            UIView.animate(
                withDuration: 0.5,
                animations: {
                    self.contentView.frame.origin = location
                }
            )
        default:
            return
        }
    }
    
    func detents(){
        [Device.height-273, Device.height-52]
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
