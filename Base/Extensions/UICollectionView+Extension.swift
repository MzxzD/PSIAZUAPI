//
//  UICollectionView+Extension.swift
//  Base MVVM Project
//
//  Created by Matija Solić on 10/10/2018.
//  Copyright © 2018 Factory. All rights reserved.
//

import UIKit
extension UICollectionView {
    
    // dequeueing
    func dequeue<T: UICollectionViewCell>(for indexPath: IndexPath) -> T {
        
        guard let cell = self.dequeueReusableCell(withReuseIdentifier: T.identifier, for: indexPath) as? T else {
            fatalError("Can't dequeue cell with identifier: \(T.identifier)")
        }
        return cell
    }
}
extension UICollectionReusableView: Identifiable{
    
}
