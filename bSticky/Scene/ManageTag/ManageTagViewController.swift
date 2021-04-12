//
//  ManageTagViewController.swift
//  bSticky
//
//  Created by mima on 29/12/2020.
//  Copyright © 2020 FiftyPercent. All rights reserved.
//

import UIKit
import Combine

protocol ManageTagDisplayLogic: class {
    func displayTagToEdit(viewModel: ManageTag.EditTag.ViewModel)
    func displayTagsToChoose(viewModel: ManageTag.ChooseTag.ViewModel)
    func displayCreatedTag(viewModel: ManageTag.CreateTag.ViewModel)
    func displayUpdatedTag(viewModel: ManageTag.UpdateTag.ViewModel)
    func displayDeletedTag(viewModel: ManageTag.DeleteTag.VieWModel)
}

class ManageTagViewController: UIViewController, ManageTagDisplayLogic, ManageTagViewDelegate, UITableViewDataSource {

    var interactor: ManageTagBuisinessLogic?
    var router: (ManageTagRoutingLogic & ManageTagDataPassing)?
    
    weak var manageTagView: ManageTagView!

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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showTagToEdit()
        showTagsToChoose()
    }
    
    // MARK: - Set up
    
    private func setup() {
        let viewController = self
        let interactor = ManageTagInteractor()
        let presenter = ManageTagPresenter()
        let router = ManageTagRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    private func setupUI() {
        let manageTagView = ManageTagView()
        view.addSubview(manageTagView)
        self.manageTagView = manageTagView
        self.manageTagView.delegate = self
        self.manageTagView.chooseTagView.dataSource = self
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            manageTagView.topAnchor.constraint(equalTo: view.topAnchor),
            manageTagView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            manageTagView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            manageTagView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    // MARK: -  Create Tag
    
    func doneButtonTapped(_ sender: Any, tagFormFields: ManageTag.TagFormFields) {
        // Get tag form fields from ManageTagView
        let tagFormFields = tagFormFields
        interactor?.createTag(request: ManageTag.CreateTag.Request(tagFormFields: tagFormFields))
    }

    func displayCreatedTag(viewModel: ManageTag.CreateTag.ViewModel) {
        if viewModel.tag != nil {
            router?.routeToStartBee()
        } else {
           showTagFailureAlert(title: "Failed to create tag",
                               message: "Please correct your tag and submit again.\n If you still encounter problem, please report a bug.")
        }
    }

    // MARK: - Edit tag
    
    func showTagToEdit() {
        let request = ManageTag.EditTag.Request()
        interactor?.showTagToEdit(request: request)
    }
    
    func displayTagToEdit(viewModel: ManageTag.EditTag.ViewModel) {
        let tagToEdit = viewModel.tagFormFields
        self.manageTagView.setTag(tagToEdit: tagToEdit)
    }
    
    // MARK: - Update tag
    
    func saveButtonTapped(_ sender: Any, tagFormFields: ManageTag.TagFormFields) {
        // Get tag form fields from ManageTagView
        let tagFormFields = tagFormFields
        interactor?.updateTag(request: ManageTag.UpdateTag.Request(tagFormFields: tagFormFields))
    }
    
    func displayUpdatedTag(viewModel: ManageTag.UpdateTag.ViewModel) {
        if viewModel.tag != nil {
            router?.routeToStartBee()
        } else {
            showTagFailureAlert(title: "Failed to update tag",
                                message: "Please correct your tag and submit again.\n If you still encounter problems, please report a bug.")
        }
    }
    
    // MARK: - Delete Tag
    
    func deleteButtonTapped(_ sender: Any, tagId: Int) {
        let message = "Are you sure you want to delete this tag?\nThis action cannot be undone."
        let alertController = UIAlertController(title: "Delete tag", message: message, preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "Yes", style: .default, handler: {(alert: UIAlertAction!) in
            self.deleteTag(tagId: tagId)
        })
        let noAction = UIAlertAction(title: "No", style: .default, handler: {(alert: UIAlertAction!) in
            self.manageTagView.chooseTagView.setEditing(false, animated: true)
        })

        alertController.addAction(yesAction)
        alertController.addAction(noAction)

        showDetailViewController(alertController, sender: nil)
    }
    
    func deleteTag(tagId: Int) {
        interactor?.deleteTag(request: ManageTag.DeleteTag.Request(tagId: tagId))
    }

    func displayDeletedTag(viewModel: ManageTag.DeleteTag.VieWModel) {
        if viewModel.tagId != nil {
            //router?.routeToStartBee()
            let index = self.displayedTags.firstIndex(where: { $0.id == viewModel.tagId})
            self.displayedTags.remove(at: index!)
            self.manageTagView.chooseTagView.reloadData()
        } else {
            showTagFailureAlert(title: "Failed to delete tag", message: "Please try again. If you still encounter problems, please report a bug.")
        }
    }

    // MARK: - Choose tag
    
    var displayedTags: [ManageTag.ChooseTag.ViewModel.DisplayedTag] = []
    
    func showTagsToChoose() {
        let request = ManageTag.ChooseTag.Request()
        interactor?.showTagsToChoose(request: request)
    }
    
    func displayTagsToChoose(viewModel: ManageTag.ChooseTag.ViewModel) {
        displayedTags = viewModel.displayedTags!
        self.manageTagView.chooseTagView.reloadData()
    }
    
    //  tableView data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayedTags.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tagCell", for: indexPath) as! TagCell
        let tag = displayedTags[indexPath.row]
        
        cell.id = tag.id
        /*
        if cell.id == interactor?.chosenTagId {
            cell.isSelected = true
            cell.marker.isHidden = false
        }
        */
        cell.colorView.backgroundColor = UIColor(tag.color)
        cell.titleLabel.text = tag.name
        if tag.activated {
            cell.marker.isHidden = false
        }

        return cell
    }

    // MARK: - Button action
    
    @objc func closeButtonTapped(_ sender: Any) {
        router?.routeToStartBee()
    }
    
    @objc func cancelButtonTapped(_ sender: Any) {
        showTagToEdit()
    }
    
    func swipedRight() {
        router?.routeToStartBee()
    }
    
    // Show color picker
    func colorViewTapped() {
        if #available(iOS 14.0, *) {
            let picker = UIColorPickerViewController()
            picker.selectedColor = self.manageTagView.tagView.editTagView.colorView.backgroundColor!
            picker.delegate = self
            self.present(picker, animated: true, completion: nil)
        } else {
            manageTagView.tagView.editTagView.setColorPickerView()
        }
    }
    
    // MARK: - Error handling
    
    private func showTagFailureAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

        // route to start bee
        let okAction = UIAlertAction(title: "OK",
                                     style: .default,
                                     handler: {(alert: UIAlertAction!)
                                        in self.closeButtonTapped(self)})
        
        alertController.addAction(okAction)
        showDetailViewController(alertController, sender: nil)
    }
}

// MARK: - Color picker view

@available(iOS 14.0, *)
extension ManageTagViewController: UIColorPickerViewControllerDelegate {
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        self.manageTagView.tagView.editTagView.colorView.backgroundColor = viewController.selectedColor
    }
    
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        self.manageTagView.tagView.editTagView.colorView.backgroundColor = viewController.selectedColor
    }
}
