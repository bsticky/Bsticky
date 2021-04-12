//
//  StartSceneRouter.swift
//  bSticky
//
//  Created by mima on 21/12/2020.
//  Copyright © 2020 FiftyPercent. All rights reserved.
//

import UIKit

@objc protocol StartBeeRoutingLogic {
    func routeToManageTag()
    func routeToCreateSticky()
    func routeToListStickies()
    func routeToSettings()
}

protocol StartBeeDataPassing {
    var dataStore: StartBeeDataStore? { get }
}

class StartBeeRouter: NSObject, StartBeeRoutingLogic, StartBeeDataPassing {
    
    weak var viewController: StartBeeViewController?
    var dataStore: StartBeeDataStore?
    
    // MARK:  Routing
    
    func routeToManageTag() {
        let destinationVC = ManageTagViewController.init()
        var destinationDS = destinationVC.router!.dataStore!
        passDataToManageTag(source: dataStore!, destination: &destinationDS)
        navigateToManageTag(source: viewController!, destination: destinationVC)
    }
    
    func routeToCreateSticky() {
        let destinationVC = CreateStickyViewController.init()
        var destinationDS = destinationVC.router!.dataStore!
        passDataToCreateSticky(source: dataStore!, destination: &destinationDS)
        navigateToCreateSticky(source: viewController!, destination: destinationVC)
    }
    
    func routeToListStickies() {
        let destinationVC = ListStickiesViewController.init()
        var destinationDS = destinationVC.router!.dataStore!
        passDataToListStickies(source: dataStore!, destination: &destinationDS)
        navigateToListStickies(source: viewController!, destination: destinationVC)
    }
    
    func routeToSettings() {
        let destinatinoVC = SettingsViewController()
        navigateToSettings(source: viewController!, destination: destinatinoVC)
    }
    
    // MARK: Navigation
    
    func navigateToManageTag(source: StartBeeViewController, destination: ManageTagViewController) {
        source.show(destination, sender: nil)
        //source.navigationController?.pushViewController(destination, animated: true)
    }
    
    func navigateToCreateSticky(source: StartBeeViewController, destination: CreateStickyViewController) {
        source.show(destination, sender: nil)
    }
    
    func navigateToListStickies(source: StartBeeViewController, destination: ListStickiesViewController) {
        source.show(destination, sender: nil)
    }
    
    func navigateToSettings(source: StartBeeViewController, destination: SettingsViewController) {
        source.show(destination, sender: nil)
    }

    // MARK: Passing data
    
    func passDataToManageTag(source: StartBeeDataStore, destination: inout ManageTagDataStore) {
        destination.chosenTagId = source.chosenTagId
        destination.chosenTagButtonPosition = source.chosenTagButtonPosition
        destination.tagsToChoose = source.fetchedTags
    }
    
    func passDataToCreateSticky(source: StartBeeDataStore, destination: inout CreateStickyDataStore) {
        destination.tagId = source.chosenTagId
        destination.tagColor = source.chosenTagColor
    }
    
    func passDataToListStickies(source: StartBeeDataStore, destination: inout ListStickiesDataStore) {
        destination.tagId = source.chosenTagId
        destination.tagName = source.chosenTagName
        destination.tagColor = source.chosenTagColor
    }
}
