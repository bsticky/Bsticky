//
//  ManageTagRouter.swift
//  bSticky
//
//  Created by mima on 02/01/2021.
//  Copyright © 2021 FiftyPercent. All rights reserved.
//

protocol ManageTagRoutingLogic {
    func routeToStartBee()
}

protocol ManageTagDataPassing {
    // interector
    var dataStore: ManageTagDataStore? { get }
}

class ManageTagRouter: ManageTagRoutingLogic, ManageTagDataPassing {
    
    weak var viewController: ManageTagViewController?
    var dataStore: ManageTagDataStore?
    
    func routeToStartBee() {
        let destinationVC = viewController?.navigationController?.viewControllers[0] as! StartBeeViewController
        navigateToStartBee(source: viewController!, destination: destinationVC)
    }
    
    // MARK: Navigation
    
    func navigateToStartBee(source: ManageTagViewController, destination: StartBeeViewController) {
        source.navigationController?.popViewController(animated: true)
    }
}
