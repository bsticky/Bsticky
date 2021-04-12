//
//  ManageStickyPresenter.swift
//  bSticky
//
//  Created by mima on 2021/02/19.
//  Copyright © 2021 FiftyPercent. All rights reserved.
//

import UIKit

protocol ManageStickyPresentationLogic {
    func presentFetchedSticky(response: ManageSticky.FetchSticky.Response)
    func presentFetchedAdjacentSticky(response: ManageSticky.FetchAdjacentSticky.Response)
    func presentUpdatedSticky(response: ManageSticky.UpdateSticky.Response)
    func presentDeletedSticky(response: ManageSticky.DeleteSticky.Response)
}

class ManageStickyPresenter: ManageStickyPresentationLogic {
    
    weak var viewController: ManageStickyViewController?
    
    // MARK: - Fetch sticky
    
    func presentFetchedSticky(response: ManageSticky.FetchSticky.Response) {
        guard let managedSticky = response.managedSticky else {
            // Error
            return
        }
        let displayedSticky = toDisplayedSticky(managedSticky: managedSticky)
        let viewModel = ManageSticky.FetchSticky.ViewModel(displayedSticky: displayedSticky)
        
        viewController?.displayFetchedSticky(viewModel: viewModel)
    }
    
    // MARK: - Fetch adjacent sticky

    func presentFetchedAdjacentSticky(response: ManageSticky.FetchAdjacentSticky.Response) {
        guard let managedSticky = response.managedSticky else {
            viewController?.displayFetchedAdjecentSticky(viewModel: ManageSticky.FetchAdjacentSticky.ViewModel(displayedSticky: nil))
            return
        }

        let displayedSticky = toDisplayedSticky(managedSticky: managedSticky)
        let viewModel = ManageSticky.FetchAdjacentSticky.ViewModel(displayedSticky: displayedSticky)

        viewController?.displayFetchedAdjecentSticky(viewModel: viewModel)
    }
    
    // MARK: - Delete sticky
    
    func presentDeletedSticky(response: ManageSticky.DeleteSticky.Response) {
        let viewModel = ManageSticky.DeleteSticky.VieWModel(stickyId: response.stickyId)
        viewController?.displayDeletedSticky(viewModel: viewModel)
    }
    
    // MARK: - Helper
    
    func toDisplayedSticky(managedSticky: ManagedSticky) -> ManageSticky.DisplayedSticky {
        var displayedSticky = ManageSticky.DisplayedSticky(
            id: managedSticky.id,
            tagName: managedSticky.tagName,
            tagColor: UIColor(managedSticky.tagColor),
            date: "Created on " + BeeDateFormatter.convertDate(since1970: managedSticky.createdDate, withHouraAndMinutes: true),
            contentsType: managedSticky.contentsType,
            text: nil,
            image: nil,
            audioURL: nil
        )
        
        if managedSticky.createdDate != managedSticky.updatedDate {
            displayedSticky.date.append(BeeDateFormatter.convertDate(since1970: managedSticky.updatedDate))
        }

        switch managedSticky.contentsType {
        case .Text:
            displayedSticky.text = managedSticky.text
            
            // This is error message sticky created by the system
            if displayedSticky.id == 0 {
                displayedSticky.date = ""
            }
        case .Image:
            // MARK: IMPORTENT
            // make alert when can't find image and back to listStickies
            guard let image = BeeMediaHelper.getImage(fileName: managedSticky.fileName) else {
                // Display error alert
                displayedSticky.text = "Can't find the image in the folder where your image should be sotred. It's an wired Error... How could this happend? Let's figure out... please shoot us bug reports and drink tee"
                return displayedSticky
            }
            displayedSticky.image = image
        case .Audio:
            let audioURL = BeeMediaHelper.getAudioURL(fileName: managedSticky.fileName)
            displayedSticky.audioURL = audioURL
        default:
            break
        }
        return displayedSticky
    }
    
    // MARK:  - Update sticky
    
    func presentUpdatedSticky(response: ManageSticky.UpdateSticky.Response) {
    }
}
