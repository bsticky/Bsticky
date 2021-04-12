//
//  ManageStickyRouter.swift
//  bSticky
//
//  Created by mima on 2021/02/19.
//  Copyright © 2021 FiftyPercent. All rights reserved.
//

import Foundation

@objc protocol ManageStickyRoutingLogic {
    func routeToStartBee()
    func routeToListStickies(tagName: String, tagColor: String)
}

protocol ManageStickyDataPassing {
    var dataStore: ManageStickyDataStore? { get }
}

class ManageStickyRouter: ManageStickyRoutingLogic, ManageStickyDataPassing {
    
    weak var viewController: ManageStickyViewController?
    var dataStore: ManageStickyDataStore?
    
    // MARK: - Routing
    
    func routeToStartBee() {
        let destinationVC = viewController?.navigationController?.viewControllers[0] as! StartBeeViewController
        navigateToStartBee(source: viewController!, destination: destinationVC)
    }
    
    func routeToListStickies(tagName: String, tagColor: String) {
        let destinationVC = ListStickiesViewController()
        var destinationDS = destinationVC.router!.dataStore!
        passDataToListStickies(source: dataStore!, destination: &destinationDS, tagName: tagName, tagColor: tagColor)
        navigateToListStickies(source: viewController!, destination: destinationVC)

    }
    
    // MARK: - Navigation
    
    func navigateToListStickies(source: ManageStickyViewController, destination: ListStickiesViewController) {
        let parentVC = viewController?.navigationController?.viewControllers[0] as? StartBeeViewController
        source.navigationController?.popViewController(animated: false)
        parentVC?.show(destination, sender: nil)
    }
    
    func navigateToStartBee(source: ManageStickyViewController, destination: StartBeeViewController) {
        source.navigationController?.popViewController(animated: true)
    }

    // MARK: Passing data
    
    func passDataToListStickies(source: ManageStickyDataStore, destination: inout ListStickiesDataStore, tagName: String, tagColor: String) {
        destination.tagId = source.baseTagId
        destination.tagName = tagName
        destination.tagColor = tagColor
    }
}
