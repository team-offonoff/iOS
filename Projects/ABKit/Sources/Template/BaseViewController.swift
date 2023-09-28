//
//  BaseViewController.swift
//  ABKit
//
//  Created by 박소윤 on 2023/09/25.
//  Copyright © 2023 AB. All rights reserved.
//

import UIKit
import Core
import SnapKit

open class BaseViewController<H: BaseHeaderView, M: BaseView, C: Coordinator>: UIViewController {
    
    public weak var coordinator: C?
    
    public let headerView: H
    public let mainView: M
    
    public init(headerView: H, mainView: M){
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
        view.backgroundColor = Color.white
    }
    
    private func layout(){
        setHeaderView()
        setMainView()
    }
    
    private func setHeaderView(){
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
    
    @objc open func popViewController(){
        navigationController?.popViewController(animated: true)
    }
    
    private func setMainView(){
        view.addSubview(mainView)
        mainView.snp.makeConstraints{
            $0.top.equalTo(headerView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
//            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    //MARK: Override Template func
    
    open func style(){
        
    }
    
    open func initialize(){
        
    }
    
    open func bind(){

    }
}
