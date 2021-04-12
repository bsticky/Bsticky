//
//  ListStickiesRouter.swift
//  bSticky
//
//  Created by mima on 2021/02/05.
//  Copyright © 2021 FiftyPercent. All rights reserved.
//

protocol ListStickiesRoutingLogic {
    func routeToStartBee()
    func routeToManageSticky()
}

protocol ListStickiesDataPassing {
    var dataStore: ListStickiesDataStore? { get }
}

class ListStickiesRounter: ListStickiesRoutingLogic, ListStickiesDataPassing {
    
    weak var viewController: ListStickiesViewController?
    var dataStore: ListStickiesDataStore?
    
    // MARK: - Routing
    
    func routeToStartBee() {
        let destinationVC = viewController?.navigationController?.viewControllers[0] as! StartBeeViewController
        navigateToStartBee(source: viewController!, destination: destinationVC)
    }
    
    func routeToManageSticky() {
        let destinationVC = ManageStickyViewController.init()
        var destinationDS = destinationVC.router!.dataStore!
        passDataToManageSticky(source: dataStore!, destination: &destinationDS)
        navigateToManageSticky(source: viewController!, destination: destinationVC)
    }
    
    // MARK: Navigation
    
    func navigateToStartBee(source: ListStickiesViewController, destination: StartBeeViewController) {
        source.navigationController?.popViewController(animated: true)
    }
    
    func navigateToManageSticky(source: ListStickiesViewController, destination: ManageStickyViewController) {
        let parentVC = viewController?.navigationController?.viewControllers[0] as? StartBeeViewController
        source.navigationController?.popViewController(animated: false)
        parentVC?.show(destination, sender: nil)
    }
    
    // MARK: Passing data
    
    func passDataToManageSticky(source: ListStickiesDataStore, destination: inout ManageStickyDataStore) {
        destination.stickyId = source.chosenStickyId
        destination.baseTagId = source.tagId
    }
}
