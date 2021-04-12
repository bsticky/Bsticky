//
//  CreateStickyRouter.swift
//  bSticky
//
//  Created by mima on 21/12/2020.
//  Copyright © 2020 FiftyPercent. All rights reserved.
//

protocol CreateStickyRoutingLogic {
    func routeToStartBee()
}

protocol CreateStickyDataPassing {
    var dataStore: CreateStickyDataStore? { get }
}

class CreateStickyRouter: CreateStickyRoutingLogic, CreateStickyDataPassing {

    weak var viewController: CreateStickyViewController?
    var dataStore: CreateStickyDataStore?

    // MARK: - Routing
    
    func routeToStartBee() {
        guard let destinationVC = viewController?.navigationController?.viewControllers[0] as? StartBeeViewController else { return }
        navigateToStartBee(source: viewController!, destination: destinationVC)
    }
    
    
    // MARK: - Navigation
    
    func navigateToStartBee(source: CreateStickyViewController, destination: StartBeeViewController) {
        source.navigationController?.popViewController(animated: true)
    }
}
