//
//  BaseViewController.swift
//  FeatureDependency
//
//  Created by 박소윤 on 2023/10/26.
//  Copyright © 2023 AB. All rights reserved.
//

import UIKit
import SnapKit
import Combine
import ABKit

open class BaseViewController<H: BaseHeaderView, M: BaseView, C: Coordinator>: UIViewController {
    
    public let headerView: H?
    public let mainView: M
    
    public weak var coordinator: C?
    public var cancellables: Set<AnyCancellable> = []
    
    public init(headerView: H?, mainView: M){
        self.headerView = headerView
        self.mainView = mainView
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func viewDidLoad() {
        setDefault()
        style()
        initialize()
        bind()
    }
    
    private func setDefault(){
        defaultStyle()
        layout()
        addHeaderViewTarget()
    }
    
    private func defaultStyle(){
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = Color.background
    }
    
    private func layout(){
        setHeaderView()
        setMainView()
    }
    
    private func setHeaderView(){
        guard let headerView = headerView else { return }
        view.addSubview(headerView)
        headerView.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
    }
    
    private func addHeaderViewTarget(){
        guard let headerView = headerView as? Navigatable else { return }
        headerView.popButton.addTarget(self, action: #selector(popViewController), for: .touchUpInside)
    }
    
    private func setMainView(){
        view.addSubview(mainView)
        mainView.snp.makeConstraints{
            if let headerView = headerView{
                $0.top.equalTo(headerView.snp.bottom)
            }
            else {
                $0.top.equalTo(view.safeAreaLayoutGuide)
            }
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    //MARK: Override Template func
    
    @objc open func popViewController(){
        navigationController?.popViewController(animated: true)
    }
    
    open func style(){
        
    }
    
    open func initialize(){
        
    }
    
    open func bind(){

    }
}

