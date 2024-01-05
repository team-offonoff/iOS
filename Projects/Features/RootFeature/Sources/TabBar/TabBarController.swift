//
//  TabBarController.swift
//  RootFeature
//
//  Created by 박소윤 on 2023/09/25.
//  Copyright © 2023 AB. All rights reserved.
//

import UIKit
import ABKit
import Combine

public class TabBarController: UITabBarController{
    
    public weak var coordinator: TabCoordinator?
    private let tabBarView: CustomTabBar = CustomTabBar()
    private var cancellables: Set<AnyCancellable> = []
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        style()
        hierarchy()
        layout()
        initialize()
        setTabBarAppearance()
    }
    
    private func style(){
        view.backgroundColor = .white
    }
    
    private func setTabBarAppearance() {
        tabBar.isHidden = true
    }
    
    private func hierarchy() {
        view.addSubview(tabBarView)
    }
    
    private func layout() {
        tabBarView.snp.makeConstraints{
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func initialize() {
        tabBarView.$selectedIndex
            .receive(on: RunLoop.main)
            .sink{ [weak self] in
                if self?.selectedIndex != $0 {
                    self?.selectedIndex = $0
                }
            }
            .store(in: &cancellables)
        
        tabBarView.generateTopicButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink{ [weak self] _ in
                guard let self = self else { return }
                self.coordinator?.startTopicGenerate()
            }
            .store(in: &cancellables)
    }
}

extension TabBarController {
    
    final class CustomTabBar: BaseView {
        
        @Published private(set) var selectedIndex: Int = 0
        
        private let items: [TabBarItem] = TabBarItem.allCases
        private var itemCells: [TabBarItemCell] = []
        
        let generateTopicButton: UIButton = {
            let button = UIButton()
            button.setImage(Image.tabGenerateTopic, for: .normal)
            button.backgroundColor = UIColor(r: 22, g: 20, b: 33)
            button.layer.cornerRadius = 56/2
            button.layer.borderWidth = 1
            button.layer.borderColor = Color.subNavy2.cgColor
            button.layer.masksToBounds = true
            return button
        }()
        
        private let leftItemsStackView: UIStackView = UIStackView(axis: .horizontal, spacing: 33)
        private let rightItemsStackView: UIStackView = UIStackView(axis: .horizontal, spacing: 37)
        
        override func style() {
            backgroundColor = Color.black40
            layer.cornerRadius = 78/2
        }
        
        override func hierarchy() {
            addSubviews([leftItemsStackView, generateTopicButton, rightItemsStackView])
        }
        
        override func layout() {
            
            self.snp.makeConstraints{
                $0.height.equalTo(78 + (Device.safeAreaInsets?.bottom ?? 0))
            }
            
            leftItemsStackView.snp.makeConstraints{
                $0.leading.equalToSuperview().offset(41)
                $0.top.equalToSuperview().offset(16)
                $0.trailing.equalTo(generateTopicButton.snp.leading).offset(-18)
            }
            
            generateTopicButton.snp.makeConstraints{
                $0.width.height.equalTo(56)
                $0.top.equalToSuperview().offset(-7)
                $0.centerX.equalToSuperview()
            }
            
            rightItemsStackView.snp.makeConstraints{
                $0.top.equalToSuperview().offset(16)
                $0.leading.equalTo(generateTopicButton.snp.trailing).offset(14)
                $0.trailing.equalToSuperview().inset(40)
            }
        }
        
        override func initialize() {
            
            for (idx, item) in items.enumerated(){
                
                let itemCell = createCell()
                addToArray()
                addToParentView()
                
                func createCell() -> TabBarItemCell {
                    let cell = TabBarItemCell(item: item)
                    cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(changeItem)))
                    return cell
                }
                
                func addToArray() {
                    itemCells.append(itemCell)
                }
                
                func addToParentView() {
                    if idx < items.count/2 {
                        leftItemsStackView.addArrangedSubview(itemCell)
                    }
                    else {
                        rightItemsStackView.addArrangedSubview(itemCell)
                    }
                }
            }
            itemCells[0].isSelected = true
        }
        
        @objc private func changeItem(_ sender: UITapGestureRecognizer) {
            guard let cell = sender.view as? TabBarItemCell else { return }
            itemCells[selectedIndex].isSelected = false //old value make deselect
            selectedIndex = cell.tag
            itemCells[selectedIndex].isSelected = true
        }
    }
    
    final class TabBarItemCell: BaseStackView {

        private let item: TabBarItem
        
        init(item: TabBarItem) {
            self.item = item
            super.init()
            initialize()
        }
        
        required init(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        var isSelected: Bool = false {
            didSet {
                iconImageView.image = isSelected ? item.selectedIcon : item.defaultIcon
            }
        }
        
        private let iconImageView: UIImageView = UIImageView()
        private let titleLabel: UILabel = {
            let label = UILabel()
            label.setTypo(Pretendard.regular12)
            label.textColor = Color.white
            return label
        }()
        
        override func style() {
            axis = .vertical
            spacing = 4
            alignment = .center
        }
        
        override func hierarchy() {
            addArrangedSubviews([iconImageView, titleLabel])
        }
        
        override func layout() {
            iconImageView.snp.makeConstraints{
                $0.width.height.equalTo(26)
            }
        }
        
        override func initialize() {
            tag = item.rawValue
            iconImageView.image = item.defaultIcon
            titleLabel.text = item.title
        }
    }
}
