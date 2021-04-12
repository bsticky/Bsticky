//
//  ViewController.swift
//  bSticky
//
//  Created by mima on 14/12/2020.
//  Copyright © 2020 FiftyPercent. All rights reserved.
//

import UIKit

protocol ListStickiesDisplayLogic: class {
    func displayFetchedStickies(viewModel: ListStickies.FetchStickies.ViewModel)
    func displayManageSticky(viewModel: ListStickies.ManageSticky.ViewModel)
}

class ListStickiesViewController: UIViewController, ListStickiesDisplayLogic, ListStickiesViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    var interactor: ListStickiesBusinessLogic?
    var router: (ListStickiesRoutingLogic & ListStickiesDataPassing)?
    
    weak var listStickiesView: ListStickiesView!
    var scale: CGFloat = 1.0
    var scaleStart: CGFloat = 1.0

    // MARK:- Object lifecycle
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchStickies()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // pinch screen to zoom
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(pinchGestrueReceived(_:)))
        self.listStickiesView.collectionView.addGestureRecognizer(pinchGesture)
    }
    
    // MARK: - Setup
    
    func setup() {
        let viewController = self
        let interactor = ListStickiesInteractor()
        let presenter = ListStickiesPresenter()
        let router = ListStickiesRounter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    private func setupUI() {
        let listStickiesView = ListStickiesView(frame: self.view.bounds)
        view.addSubview(listStickiesView)
        
        self.listStickiesView = listStickiesView
        self.listStickiesView.delegate = self

        self.listStickiesView.collectionView.delegate = self
        self.listStickiesView.collectionView.dataSource = self
        
        NSLayoutConstraint.activate([
            listStickiesView.topAnchor.constraint(equalTo: view.topAnchor),
            listStickiesView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            listStickiesView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            listStickiesView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }

    // MARK: - Fetch stickies
    
    //var displayedStickies: [Sticky] = []
    var displayedStickies: [ListStickies.FetchStickies.ViewModel.DisplayedSticky] = []
    
    var isLoading: Bool = false
    var noMoreSticky: Bool = false

    func fetchStickies() {
        let request = ListStickies.FetchStickies.Request(offset: displayedStickies.count)
        interactor?.fetchStickies(request: request)
    }
    
    func displayFetchedStickies(viewModel: ListStickies.FetchStickies.ViewModel) {
        // navigation bar
        listStickiesView.navBar.topItem?.title = viewModel.tagName
        listStickiesView.navBar.barTintColor = UIColor(viewModel.tagColor)
        
        // load more
        isLoading = false
        if viewModel.displayedStickies.count == 0 {
            noMoreSticky = true
            // When no more sticies are fetched It should call load more
            // then thumbnail image will show up in worng cell
            return
        }

        // colection view items
        displayedStickies.append(contentsOf: viewModel.displayedStickies)
        listStickiesView.collectionView.reloadData()
    }
    
    // MARK: - Manage sticky
    
    @objc func stickyCellTapped(_ sender: UIButton) {
        guard let selectedCell = sender.superview as? StickyCell else {
            return }
        let request = ListStickies.ManageSticky.Request(stickyId: selectedCell.id!)
        interactor?.manageSticky(request: request)
    }
    
    func displayManageSticky(viewModel: ListStickies.ManageSticky.ViewModel) {
        router?.routeToManageSticky()
    }

    // MARK: - CollectionViewDelegate & UICollectionViewDataSource & UICollectionViewDelegateFlowLayout

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 111 * self.scale, height: 122 * self.scale)
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return displayedStickies.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "stickyCell",
                                                            for: indexPath) as? StickyCell else {
            return UICollectionViewCell() }
        
        // set sticky cell
        let sticky = displayedStickies[indexPath.row]
        cell.id = sticky.id

        switch sticky.contentsType {
        case .Text:
            cell.text = sticky.text
        case .Image:
            cell.generateThumbnail(fileName: sticky.fileName)
        case.Audio:
            cell.image = cell.playImage
        default:
            break
        }

        cell.backgroundColor = sticky.tagColor.withAlphaComponent(0.7)
        cell.viewButton.addTarget(self,
                                  action: #selector(stickyCellTapped(_:)),
                                  for: .touchUpInside)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        // Load more stickies
        if indexPath.row == displayedStickies.count - 1 && !isLoading && !noMoreSticky {
            self.isLoading = true
            fetchStickies()
        }
    }

    // MARK: - User actions
    
    @objc func navCancelButtonTapped(_ sender: Any) {
        router?.routeToStartBee()
    }
    
    func swipedRight() {
        router?.routeToStartBee()
    }

    @objc func pinchGestrueReceived(_ gesture: UIPinchGestureRecognizer) {
        if gesture.state == .began {
            scaleStart = self.scale
        }
        else if gesture.state == .changed {
            self.scale = scaleStart * gesture.scale
            self.listStickiesView.collectionView.collectionViewLayout.invalidateLayout()
        }
    }
    
}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
