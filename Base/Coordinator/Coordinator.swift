//
//  Coordinator.swift
//  Base MVVM Project
//
//  Created by Matija Solić on 11/06/2018.
//  Copyright © 2018 Base MVVM Project. All rights reserved.
//

import UIKit
public protocol Coordinator: class{
    var childCoordinators: [Coordinator] { get set}
    var presenter: UINavigationController { get}
    func start()
}

public extension Coordinator {
    
    /// Add a child coordinator to the parent
    func addChildCoordinator(childCoordinator: Coordinator) {
        self.childCoordinators.append(childCoordinator)
    }
    
    /// Remove a child coordinator from the parent
    func removeChildCoordinator(childCoordinator: Coordinator) {
        self.childCoordinators = self.childCoordinators.filter { $0 !== childCoordinator }
    }
    
}
