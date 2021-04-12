//
//  ManageTagInteractor.swift
//  bSticky
//
//  Created by mima on 2021/02/19.
//  Copyright © 2021 FiftyPercent. All rights reserved.
//

protocol ManageStickyBusinessLogic {
    func fetchSticky(request: ManageSticky.FetchSticky.Request)
    func fetchAdjacentSticky(request: ManageSticky.FetchAdjacentSticky.Request)
    func updateSticky(request: ManageSticky.UpdateSticky.Request)
    func deleteSticky(request: ManageSticky.DeleteSticky.Request)
}

protocol ManageStickyDataStore {
    var baseTagId: Int? { get set } // should I use bool instead...?
    var stickyId: Int? { get set }
}

class ManageStickyInteractor: ManageStickyBusinessLogic, ManageStickyDataStore {
    
    var beeWorker = BeeWorker(BeeDB: BeeDatabase())
    var presenter: ManageStickyPresentationLogic?
    
    var managedSticky: ManagedSticky?
    var stickyId: Int?
    var baseTagId: Int?
    

    // MARK: - Fetch sticky
    
    func fetchSticky(request: ManageSticky.FetchSticky.Request) {
        beeWorker.fetchSticky(stickyId: self.stickyId!, completionHandler: { (managedSticky) -> Void in
            self.managedSticky = managedSticky
            let response = ManageSticky.FetchSticky.Response(managedSticky: managedSticky)
            self.presenter?.presentFetchedSticky(response: response)
        })
    }
    
    // MARK: - Fetch adjacent sticky
    
    func fetchAdjacentSticky(request: ManageSticky.FetchAdjacentSticky.Request) {
        guard let currentSticky = self.managedSticky else { return }
        
        if baseTagId == 0 {
            // fetch adjacent sticky without specific tag
            beeWorker.fetchAdjacentSticky(updatedDate: currentSticky.updatedDate , isNext: request.isNext, completionHandler: { (managedSticky) -> Void in
                self.managedSticky = managedSticky
                let response = ManageSticky.FetchAdjacentSticky.Response(managedSticky: managedSticky)
                self.presenter?.presentFetchedAdjacentSticky(response: response)
            })
        } else {
            beeWorker.fetchAdjacentStickyWithinTag(updatedDate: currentSticky.updatedDate, isNext: request.isNext, tagId: self.baseTagId!, completionHandler: { (managedSticky) -> Void in
                self.managedSticky = managedSticky
                let response = ManageSticky.FetchAdjacentSticky.Response(managedSticky: managedSticky)
                self.presenter?.presentFetchedAdjacentSticky(response: response)
            })
        }
    }
    
    // MARK: - Delete Sticky
    
    func deleteSticky(request: ManageSticky.DeleteSticky.Request) {
        guard self.managedSticky != nil && self.managedSticky?.id != 0 else {
            return
        }
        
        beeWorker.deleteSticky(stickyId: self.managedSticky!.id, completionHandler: { (deleteStickyId) -> Void in
            if deleteStickyId != nil {
                // Delete media file
                if self.managedSticky?.contentsType == .Image {
                    guard let fileURL = BeeMediaHelper.getFileURL(contentsType: .Image, fileName: self.managedSticky!.fileName) else { return }
                    BeeMediaHelper.deleteFile(fileURL: fileURL)
                } else if self.managedSticky?.contentsType == .Audio {
                    guard  let fileURL = BeeMediaHelper.getFileURL(contentsType: .Audio, fileName: self.managedSticky!.fileName) else { return }
                    BeeMediaHelper.deleteFile(fileURL: fileURL)
                }
            }
            let response = ManageSticky.DeleteSticky.Response(stickyId: self.managedSticky?.id)
            self.presenter?.presentDeletedSticky(response: response)
        })
    }
    
    
    // MARK: - Update Sticky
    
    func updateSticky(request: ManageSticky.UpdateSticky.Request) {
    }
    
    
}



