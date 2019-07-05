//
//  HomeCoordinator.swift
//  Base MVVM Project
//
//  Created by Matija Solić on 04/08/2018.
//  Copyright © 2018 Factory. All rights reserved.
//

import UIKit
class HomeCoordinator: Coordinator{
    var childCoordinators: [Coordinator] = []
    var presenter: UINavigationController
    let controller: HomeViewController
    init (presenter: UINavigationController){
        self.presenter = presenter
        let controller = HomeViewController()
        let homeViewModel = HomeViewModel()
        controller.viewModel = homeViewModel
        self.controller = controller
        
    }
    func start() {
        presenter.pushViewController(controller, animated: true)
    }
    
    
}
