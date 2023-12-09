//
//  UITableView++.swift
//  ABKit
//
//  Created by 박소윤 on 2023/12/08.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation
import UIKit

public extension UITableView{
    
    final func registers(cellTypes: [BaseTableViewCell.Type]){
        cellTypes.forEach{
            register(cellType: $0)
        }
    }
    
    final func register<T: BaseTableViewCell>(cellType: T.Type) {
        register(cellType.self, forCellReuseIdentifier: cellType.cellIdentifier)
    }
    
    final func dequeueReusableCell<T: BaseTableViewCell>(for indexPath: IndexPath, cellType: T.Type = T.self) -> T {
        let bareCell = dequeueReusableCell(withIdentifier: cellType.cellIdentifier, for: indexPath)
        guard let cell = bareCell as? T else {
          fatalError(
            "Failed to dequeue a cell with identifier \(cellType.cellIdentifier) matching type \(cellType.self). "
              + "Check that the reuseIdentifier is set properly in your XIB/Storyboard "
              + "and that you registered the cell beforehand"
          )
        }
        return cell
    }
    
    final func cellForItem<T: BaseTableViewCell>(at indexPath: IndexPath, cellType: T.Type) -> T? {
        cellForRow(at: indexPath) as? T
    }
}
