//
//  StartSceneViewController.swift
//  bSticky
//
//  Created by mima on 21/12/2020.
//  Copyright © 2020 FiftyPercent. All rights reserved.
//

import UIKit

protocol StartBeeDisplayLogic: class {
    var numberOfTags: Int { get set }
    func displayFetchedTags(viewModel: StartBee.FetchTags.ViewModel)
    func displayManageTag(viewModel: StartBee.StartManageTag.ViewModel)
    func displayCreateSticky(viewModel: StartBee.StartCreateSticky.ViewModel)
    func displayListStickies(viewModel: StartBee.StartListStickies.ViewModel)
}

class StartBeeViewController: UIViewController, StartBeeDisplayLogic, HexagonTagViewDelegate {

    var interactor: StartBeeBusinessLogic?
    var router: (NSObjectProtocol & StartBeeRoutingLogic & StartBeeDataPassing)?
    
    var numberOfTags: Int = 6
    weak var tagContainerView: HexagonTagView!
    
    
    // MARK: - Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    
    // MARK: - View Lifecycle
    
    override func loadView() {
        super.loadView()
        setupUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = true
        setupConstraints()
        self.tagContainerView?.layoutTrait(traitCollection: UIScreen.main.traitCollection)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        traitCollectionDidChange(UIScreen.main.traitCollection)
        fetchTags()
        setWallpaper()
    }
    
    // MARK: - Setup
    
    private func setup() {
        let viewController = self
        let interactor = StartBeeInteractor()
        let presenter = StartBeePresenter()
        let router = StartBeeRouter()
        router.dataStore = interactor
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
    }
   
    private func setupUI() {
        let tagContainerView = HexagonTagView()
        view.addSubview(tagContainerView)
        self.tagContainerView = tagContainerView
        self.tagContainerView.delegate = self
        
        setWallpaper()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tagContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tagContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tagContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tagContainerView.topAnchor.constraint(equalTo: view.topAnchor),
        ])
    }

    //MARK: - Fetch tags
    
    func fetchTags() {
        let request = StartBee.FetchTags.Request()
        interactor?.fetchTags(request: request)
    }
    
    func displayFetchedTags(viewModel: StartBee.FetchTags.ViewModel) {
        for tagButton in self.tagContainerView.tagButtons {
            let tag = viewModel.displayedTags[tagButton.position]
            tagButton.setTagProfile(tagId: tag.id, title: tag.name, bgColor: UIColor(tag.color))
        }
    }

    // MARK: - StartManageTag scene

    func tagButtonLongTapped(tagId: Int, tagPosition:Int) {
        let request = StartBee.StartManageTag.Request(tagId: tagId, tagButtonPosition: tagPosition)
        interactor?.startManageTag(request: request)
    }
    
    func displayManageTag(viewModel: StartBee.StartManageTag.ViewModel) {
        router?.routeToManageTag()
    }

    // MARK: - StartCreatSticky scene

    func tagButtonTapped(tagId: Int, tagColor: UIColor) {
        if tagId == 0 {
            displayAlert(title: "First Set tag", message: "Please, long press this button to set the tag for this button.")
        } else {
            let request = StartBee.StartCreateSticky.Request(tagId: tagId, tagColor: tagColor.toHex!)
            interactor?.startCreateSticky(request: request)
        }
    }

    func displayCreateSticky(viewModel: StartBee.StartCreateSticky.ViewModel) {
        router?.routeToCreateSticky()
    }

    // MARK: - Start ListStickies scene
    
    func hiveButtonTapped() {
        // List all stickies without specific tag
        let request = StartBee.StartListStickies.Request(tagId: 0,
                                                         tagName: "",
                                                         tagColor: "#B22939")
        interactor?.startListStickies(request: request)
    }
    
    func tagButtonDropInHiveButton(tagId: Int, tagName: String, tagColor: UIColor) {
        // List stickies of chosen tag
        if tagId == 0 { return }
        let request = StartBee.StartListStickies.Request(tagId: tagId,
                                                         tagName: tagName,
                                                         tagColor: tagColor.toHex!)
        interactor?.startListStickies(request: request)
    }

    func displayListStickies(viewModel: StartBee.StartListStickies.ViewModel) {
        router?.routeToListStickies()
    }
    
    // MARK: - Route to settings scene
    
    func hiveButtonLongTapped() {
        router?.routeToSettings()
    }
    
    // MARK: - Helper
    
    private func setWallpaper() {
        let wallpaper = Preferences.shared.wallpaper
        if wallpaper != nil {
            if wallpaper == "wallpaper.jpg" {
                let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
                let url = urls[urls.endIndex-1].appendingPathComponent("wallpaper.jpg")
                
                if FileManager.default.fileExists(atPath: url.path) {
                    UIGraphicsBeginImageContext(self.view.frame.size)
                    UIImage(contentsOfFile: url.path)?.draw(in: self.view.bounds)
                    let bg: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
                    UIGraphicsEndImageContext()
                    self.tagContainerView.backgroundColor = UIColor(patternImage: bg)
                }
            } else {
                self.tagContainerView.backgroundColor = UIColor(wallpaper!)
            }
        }
    }
    
    private func displayAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

        // route to start bee
        let okAction = UIAlertAction(title: "OK",
                                     style: .default,
                                     handler: nil)
        
        alertController.addAction(okAction)
        showDetailViewController(alertController, sender: nil)
    }
}
