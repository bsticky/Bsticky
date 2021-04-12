//
//  CreateStickyViewController.swift
//  bSticky
//
//  Created by mima on 17/12/2020.
//  Copyright © 2020 FiftyPercent. All rights reserved.
//

import UIKit
import AVFoundation

protocol CreateStickyDisplayLogic: class
{
    func displayCreatedSticky(viewModel: CreateSticky.CreateSticky.ViewModel)
    func displayTagAttribute(viewModel: CreateSticky.SetTagAttribute.ViewModel)
}

class CreateStickyViewController: UIViewController, CreateStickyDisplayLogic, CreateStickyViewDelegate, BeeCameraControllerDelegate, BeeAudioRecordingControllerDelegate {

    var interactor: CreateStickyBusinessLogic?
    var router: (CreateStickyRoutingLogic & CreateStickyDataPassing)?

    weak var createStickyView: CreateStickyView!

    // MARK: - Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: - View lifecycle
    
    override func loadView() {
        super.loadView()
        setupUI()
        setTagAttribute()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraints()
    }
    
    // MARK: - Setup
    
    private func setup() {
        let viewController = self
        let interactor = CreateStickyInteractor()
        let presenter = CreateStickyPresenter()
        let router = CreateStickyRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    private func setupUI() {
        let createStickyView = CreateStickyView()
        view.addSubview(createStickyView)
        self.createStickyView = createStickyView
        self.createStickyView.delegate = self
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            createStickyView.topAnchor.constraint(equalTo: view.topAnchor),
            createStickyView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            createStickyView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            createStickyView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    // MARK: - Set tag attribute
    
    func setTagAttribute() {
        let request = CreateSticky.SetTagAttribute.Request()
        interactor?.setTagAttribute(request: request)
    }
    
    func displayTagAttribute(viewModel: CreateSticky.SetTagAttribute.ViewModel) {
        self.createStickyView.backgroundColor = UIColor(viewModel.tagColor ?? "#FFFFFF")
    }
    
    // MARK: - Create sticky
    
    func swipedLeft() {
        let text = createStickyView.textView.text!
        createSticky(contentType: 1, text: text)
    }
    
    func photoSaveButtonTapped(filePath: String!) {
        createSticky(contentType: 2, filePath: filePath)
    }
    
    func audioPlayerSaveButtonTapped(filePath: String!) {
        createSticky(contentType: 3, filePath: filePath)
    }
    
    func createSticky(contentType: Int, text: String = "", filePath: String = "") {
        let createdDate = Int(Date().timeIntervalSince1970)
        let contentsAttributeId = 0 // for the future use
        
        let request = CreateSticky.CreateSticky.Request(stickyFormFields: CreateSticky.StickyFormFields(id: 0, contentsType: contentType, text: text, filePath: filePath, contentsAttributeId: contentsAttributeId, createdDate: createdDate, updatedDate: createdDate))

        interactor?.createSticky(request: request)
    }
    
    func displayCreatedSticky(viewModel: CreateSticky.CreateSticky.ViewModel) {
        if viewModel.sticky != nil {
            createStickyView.showSavedAnimation()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                self.router?.routeToStartBee()
            }
        } else {
            displayErrorAlert(title: "Failed to create sticky")
        }
    }

    // MARK: - Camera
    
    func cameraButtopTapped(_ sender: Any) {
        createStickyView.textView.endEditing(true)
        let camera = BeeCameraController()
        camera.delegate = self
        camera.openCamera()
        self.present(camera, animated: true, completion: nil)
    }
    
    func displayCameraPermissionAlert() {
        let alertController = BeeMediaHelper.getCameraPermissionAlert()
        showDetailViewController(alertController, sender: nil)
    }
    
    // MARK: - Recording
    
    func recordingButtonTapped(_ sender: Any) {
        createStickyView.textView.endEditing(true)
        let recorder = BeeAudioRecordingController()
        // Disable swipe down to dissmiss recorder
        recorder.isModalInPresentation = true
        recorder.delegate = self
        self.present(recorder, animated: true, completion: nil)
    }
    
    // MARK: - Cancel create sticky route back to StartBee Scene
    
    func swipedRight() {
        router?.routeToStartBee()
    }
    
    // MARK: - Alert controller
    
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
}
