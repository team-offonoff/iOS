//
//  UICollectionView++.swift
//  ABKit
//
//  Created by 박소윤 on 2023/10/03.
//  Copyright © 2023 AB. All rights reserved.
//

import UIKit
import Core

public extension UICollectionView{
    
    final func registers(cellTypes: [BaseCollectionViewCell.Type]){
        cellTypes.forEach{
            register(cellType: $0)
        }
    }
    
    final func register<T: BaseCollectionViewCell>(cellType: T.Type) {
        register(cellType.self, forCellWithReuseIdentifier: cellType.cellIdentifier)
    }
    
    final func dequeueReusableCell<T: BaseCollectionViewCell>(for indexPath: IndexPath, cellType: T.Type = T.self) -> T {
        let bareCell = dequeueReusableCell(withReuseIdentifier: cellType.cellIdentifier, for: indexPath)
        guard let cell = bareCell as? T else {
          fatalError(
            "Failed to dequeue a cell with identifier \(cellType.cellIdentifier) matching type \(cellType.self). "
              + "Check that the reuseIdentifier is set properly in your XIB/Storyboard "
              + "and that you registered the cell beforehand"
          )
        }
        return cell
    }
    
    final func cellForItem<T: BaseCollectionViewCell>(at indexPath: IndexPath, cellType: T.Type) -> T? {
        cellForItem(at: indexPath) as? T
    }
}
