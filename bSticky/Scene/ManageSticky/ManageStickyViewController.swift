//
//  ShowStickyViewController.swift
//  bSticky
//
//  Created by mima on 2021/02/19.
//  Copyright © 2021 FiftyPercent. All rights reserved.
//

import UIKit
import AVFoundation

protocol ManageStickyDisplayLogic: class {
    func displayFetchedSticky(viewModel: ManageSticky.FetchSticky.ViewModel)
    func displayFetchedAdjecentSticky(viewModel: ManageSticky.FetchAdjacentSticky.ViewModel)
    func displayUpdatedSticky(viewModel: ManageSticky.UpdateSticky.ViewModel)
    func displayDeletedSticky(viewModel: ManageSticky.DeleteSticky.VieWModel)
}

class ManageStickyViewController: UIViewController, ManageStickyDisplayLogic, ManageStickyViewDelegate, AVAudioPlayerDelegate {
    
    var interactor: ManageStickyBusinessLogic?
    var router: (ManageStickyRoutingLogic & ManageStickyDataPassing)?
    
    weak var manageStickyView: ManageStickyView!
    
    // MARK: - Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: - Set up
    
    private func setup() {
        let viewController = self
        let interactor = ManageStickyInteractor()
        let presenter = ManageStickyPresenter()
        let router = ManageStickyRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    private func setupUI() {
        let manageStickyView = ManageStickyView()
        view.addSubview(manageStickyView)
        
        self.manageStickyView = manageStickyView
        self.manageStickyView.delegate = self
        
        NSLayoutConstraint.activate([
            manageStickyView.topAnchor.constraint(equalTo: view.topAnchor),
            manageStickyView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            manageStickyView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            manageStickyView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    // MARK: - View lifecycle
    
    override func loadView() {
        super.loadView()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchSticky()
    }

    // MARK: - Fetch sticky
    
    func fetchSticky() {
        let request = ManageSticky.FetchSticky.Request()
        interactor?.fetchSticky(request: request)
    }
    
    func displayFetchedSticky(viewModel: ManageSticky.FetchSticky.ViewModel) {
        if let displayedSticky = viewModel.displayedSticky {
            displaySticky(displayedSticky: displayedSticky)
        } else {
            displayErrorAlert(title: "Failed to fetch sticky")
        }
    }
    
    // MARK: - Update Sticky
    
    func displayUpdatedSticky(viewModel: ManageSticky.UpdateSticky.ViewModel) {
    }
    
    // MARK: - Fetch adjacent sticky
    
    var noMoreSticky: Bool = false
    
    func fetchAdjacentSticky(isNext: Bool) {
        if !noMoreSticky {
            let request = ManageSticky.FetchAdjacentSticky.Request(isNext: isNext)
            interactor?.fetchAdjacentSticky(request: request)
        }
    }
    
    func displayFetchedAdjecentSticky(viewModel: ManageSticky.FetchAdjacentSticky.ViewModel) {
        if let displayedSticky = viewModel.displayedSticky {
            displaySticky(displayedSticky: displayedSticky)
        } else {
            displayErrorAlert(title: "Failed to fetch adjacent sticky")
        }
    }
    
    // MARK: - Delete Sticky
    
    func deleteSticky() {
        let request = ManageSticky.DeleteSticky.Request()
        interactor?.deleteSticky(request: request)
    }
    
    func displayDeletedSticky(viewModel: ManageSticky.DeleteSticky.VieWModel) {
        if viewModel.stickyId != nil {
            // Show Previous sticky
            fetchAdjacentSticky(isNext: false)
        } else {
            displayErrorAlert(title: "Failed to delete sticky")
        }
    }
    
    // MARK: - User actions
    
    func swipedRight() {
        // should I change to back to list stickies ?
        //router?.routeToStartBee()
        let tagName = manageStickyView.tagNameLabel.text
        let tagColor = manageStickyView.backgroundColor?.toHex
        router?.routeToListStickies(tagName: tagName!, tagColor: tagColor!)
    }
    
    func nextButtonTapped() {
        fetchAdjacentSticky(isNext: true)
    }
    
    func previousButtonTapped() {
        fetchAdjacentSticky(isNext: false)
    }
    
    func bottomMiddleButtonTapped() {
        displayDeleteAlert()
        //deleteSticky()
    }
    
    // MARK: - Helper functions
    
    func displaySticky(displayedSticky: ManageSticky.DisplayedSticky) {
        manageStickyView.tagNameLabel.text = displayedSticky.tagName
        manageStickyView.backgroundColor  = displayedSticky.tagColor.withAlphaComponent(0.7)
        manageStickyView.dateLabel.text = displayedSticky.date

        // Clean up contents stack view
        manageStickyView.dismissSubviews()

        switch displayedSticky.contentsType {
        case .Image:
            manageStickyView.contentsStackView.addArrangedSubview(manageStickyView.beeImageView)
            manageStickyView.beeImageView.image = displayedSticky.image
        case .Audio:
            prepareAudioPlayer(url: displayedSticky.audioURL!)
            manageStickyView.contentsStackView.addArrangedSubview(manageStickyView.audioPlayerView)
        default:
            manageStickyView.textView.text = displayedSticky.text
            manageStickyView.contentsStackView.addArrangedSubview(manageStickyView.textView)
        }
        
        if displayedSticky.id == 0 {
            // This is error message sticky created by the system
            manageStickyView.bottomMiddleButton.isHidden = true
        } else {
            manageStickyView.bottomMiddleButton.isHidden = false
        }
    }

    // MARK: Alert view controller
    
    func displayErrorAlert(title: String, message: String="") {
        // Show Error Message and route to start bee
        let message =  "Please re-start the application and try again. \nIf you still encounter problem, Please report a bug. \nWe will fix it."
        
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok",
                                     style: .default,
                                     handler: {(alert: UIAlertAction!)
                                        in self.router?.routeToStartBee()})
        alertController.addAction(okAction)
        
        showDetailViewController(alertController, sender: nil)
    }
    
    func displayDeleteAlert() {
        let message = "Are you sure you want to delte this sticky? \n This action cannot be undoen."
        let alertController = UIAlertController(title: "Delete sticky", message: message, preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "Yes", style: .default, handler: {
            (alert: UIAlertAction!) in
            self.deleteSticky()
        })
        
        let noAction = UIAlertAction(title: "No", style: .default, handler: nil)
        
        alertController.addAction(yesAction)
        alertController.addAction(noAction)
        
        showDetailViewController(alertController, sender: nil)
    }
    

    // MARK: - Audio player
    
    var player: BeeAudioPlayerComposition!
    var isPlaying: Bool = false
    
    func prepareAudioPlayer(url: URL!) {
        if player != nil {
            player.stop()
            player = nil
            isPlaying = false
        }
        
        // URL not exist handle error
        if url == nil { fatalError() }
        
        do {
            let audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer.delegate = self
            audioPlayer.volume = 1.0
            audioPlayer.prepareToPlay()
            
            player = BeeAudioPlayerComposition(
                player: audioPlayer,
                view: manageStickyView.audioPlayerView.playerVisualizerView!)
            
            manageStickyView.audioPlayerView.setPlyerButton(isPlaying)
            manageStickyView.audioPlayerView.playButton.addTarget(
                self,
                action: #selector(playButtonTapped(_:)),
                for: .touchUpInside)
        } catch {
            fatalError()
        }
    }
    
    @objc func playButtonTapped(_ sender: Any) {
        if isPlaying {
            isPlaying = false
            player.stop()
            manageStickyView.audioPlayerView.setPlyerButton(isPlaying)
        } else {
            isPlaying = true
            player.play()
            manageStickyView.audioPlayerView.setPlyerButton(isPlaying)
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        isPlaying = false
        manageStickyView.audioPlayerView.setPlyerButton(isPlaying)
        manageStickyView.audioPlayerView.playerVisualizerView?.slider.value = 0
    }
}
