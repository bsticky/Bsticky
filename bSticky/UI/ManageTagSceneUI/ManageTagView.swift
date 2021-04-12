//
//  CustomUIObjects.swift
//  bSticky
//
//  * ManageTagView hierarchy:
//    |ManageTagView(UIView, UITableViewDelegate, ColorPickerViewDelegate)
//       |- navBar(UINavigationBar)
//       |- chooseTagView(UITableView)
//       |- tagView(TagView(UIScrollView))
//
//    - This view implement view controller helper functions
//      - buildTagFormFields() -> ManageTag.TagFormFields
//      - setTag(tagToEdit: ManageTag.TagFormFields)
//      - setViewMode()
//      - setEditMode()
//
//  Created by mima on 09/01/2021.
//  Copyright © 2021 FiftyPercent. All rights reserved.
//

import UIKit

protocol ManageTagViewDelegate: class {
    func saveButtonTapped(_ sender: Any, tagFormFields: ManageTag.TagFormFields)
    func closeButtonTapped(_ sender: Any)
    func cancelButtonTapped(_ sender: Any)
    func doneButtonTapped(_ sener: Any, tagFormFields: ManageTag.TagFormFields)
    func deleteButtonTapped(_ sender: Any, tagId: Int)
    func colorViewTapped()
    func swipedRight()
}

class ManageTagView: UIView, UITableViewDelegate {
    
    var tagId: Int = 0
    var isChooseMode: Bool = false
    var isEditMode: Bool = false
    var isCreateMode: Bool = false

    weak var delegate: ManageTagViewDelegate?
    
    // MARK: - Init sub views
    
    let navBar: UINavigationBar = {
        let bar = UINavigationBar()
        bar.translatesAutoresizingMaskIntoConstraints = false
        //bar.barTintColor = UIColor.systemYellow.withAlphaComponent(0.7)
        bar.barTintColor = UIColor("#F4116F").withAlphaComponent(0.7)
        bar.tintColor = UIColor.black
        bar.layer.cornerRadius = 10
        bar.clipsToBounds = true
        return bar
    }()
    
    var chooseTagView = ChooseTagView()
    
    let tagView = TagView()
    
    // MARK: - Object lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
        setupConstraints()
    }
    
    // MARK: - Set up
    
    func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = UIColor.systemBackground

        addSubview(navBar)
        addSubview(tagView)
        addSubview(chooseTagView)
        sendSubviewToBack(chooseTagView)
        
        chooseTagView.delegate = self
        chooseTagView.allowsSelection = true
        setNavbarItems()
        
        // Swipe action
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swipedRight))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.addGestureRecognizer(swipeRight)
        
        // color view
        tagView.editTagView.colorView.addTarget(self, action: #selector(colorViewTapped(_:)), for: .touchUpInside)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            navBar.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 15),
            navBar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            navBar.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),

            tagView.topAnchor.constraint(equalTo: navBar.bottomAnchor),
            tagView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tagView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tagView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tagView.widthAnchor.constraint(equalTo: widthAnchor),
            
            chooseTagView.topAnchor.constraint(equalTo: navBar.bottomAnchor),
            chooseTagView.leadingAnchor.constraint(equalTo: leadingAnchor),
            chooseTagView.trailingAnchor.constraint(equalTo: trailingAnchor),
            chooseTagView.bottomAnchor.constraint(equalTo: bottomAnchor),
            chooseTagView.widthAnchor.constraint(equalTo: widthAnchor),
        ])
    }

    // MARK: - Navigation Bar Items
    
    func setNavbarItems(mode: String = "") {
        let navItem = UINavigationItem(title: "")

        let cancelButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: nil, action: #selector(navCancelButtonTapped(_:)))
        let closeButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: nil, action: #selector(navCloseButtonTapped(_:)))
        let createButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: nil, action: #selector(navCreateButtonTapped(_:)))
        let chooseButtonItem = UIBarButtonItem(image: UIImage(systemName: "cube.fill"), style: .plain, target: nil, action: #selector(navChooseButtonTapped(_:)))
        let saveButtonItem = UIBarButtonItem(image: UIImage(systemName: "pin"), style: .plain, target: nil, action: #selector(navSaveButtonTapped(_:)))
        
        switch mode {
        case "view":
            let editButtonItem = UIBarButtonItem(image: UIImage(systemName: "scissors.badge.ellipsis"), style: .plain, target: nil, action: #selector(navEditButtonTapped(_:)))
            navItem.setRightBarButtonItems([createButtonItem, chooseButtonItem, editButtonItem], animated: true)
            navItem.setLeftBarButton(closeButtonItem, animated: true)
        case "edit":
            navItem.setLeftBarButton(cancelButtonItem, animated: true)
            navItem.setRightBarButton(saveButtonItem, animated: true)
        case "create":
            let doneButtonItem = UIBarButtonItem(image: UIImage(systemName: "pin.fill"), style: .plain, target: nil, action: #selector(navDoneButtonTapped(_:)))
            //navItem.setLeftBarButton(closeButtonItem, animated: true)
            navItem.setLeftBarButton(cancelButtonItem, animated: true)
            navItem.setRightBarButton(doneButtonItem, animated: true)
        case "choose":
            navItem.setRightBarButton(saveButtonItem, animated: true)
            navItem.setLeftBarButton(cancelButtonItem, animated: true)
        default:
            navItem.setLeftBarButton(closeButtonItem, animated: false)
            navItem.setRightBarButtonItems([createButtonItem, chooseButtonItem], animated: false)
        }
        navBar.setItems([navItem], animated: true)
    }
    
    // MARK: - Navbar button action
    
    @objc func navCancelButtonTapped(_ sender: Any) {
        if isChooseMode {
            self.isChooseMode = false
            self.setNavbarItems()
            self.setDefaultText()
            sendSubviewToBack(chooseTagView)
        } else if isCreateMode {
            self.isCreateMode = false
            self.setNavbarItems()
            self.setDefaultText()
        }
        self.setViewMode()
        self.delegate?.cancelButtonTapped(sender)
    }
    
    @objc func navCloseButtonTapped(_ sender: Any) {
        self.delegate?.closeButtonTapped(sender)
    }
    
    @objc func navEditButtonTapped(_ sender: Any) {
        self.setNavbarItems(mode: "edit")
        self.setEditMode()
    }

    @objc func navChooseButtonTapped(_ sender: Any) {
        self.isChooseMode = true
        self.setNavbarItems(mode: "choose")
        self.bringSubviewToFront(chooseTagView)
    }
    
    @objc func navCreateButtonTapped(_ sender: Any) {
        self.isCreateMode = true
        self.setNavbarItems(mode: "create")
        self.setEditMode()
    }
    
    @objc func navDoneButtonTapped(_ sender: Any) {
        let tagFormFields = buildTagFormFields()
        self.delegate?.doneButtonTapped(sender, tagFormFields: tagFormFields)
    }
    
    @objc func navSaveButtonTapped(_ sender: Any) {
        var tagFormFields: ManageTag.TagFormFields
        
        if isChooseMode {
            guard let indexPath = chooseTagView.indexPathForSelectedRow else {
                return
            }
            guard let cell = chooseTagView.cellForRow(at: indexPath) as? TagCell else { return }
            tagFormFields = ManageTag.TagFormFields(id: cell.id, name: "", color: "", createdDate: "", description: "")
        } else {
            // Edit tag
            tagFormFields = buildTagFormFields()
        }
        self.delegate?.saveButtonTapped(sender, tagFormFields: tagFormFields)
    }
    
    @objc func swipedRight(_ sender: Any) {
        delegate?.swipedRight()
    }
    
    @objc func colorViewTapped(_ sender: Any) {
        delegate?.colorViewTapped()
    }
    
    // MARK: - ChooseTagView : table view delegate methods
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? TagCell {
            cell.contentView.backgroundColor = UIColor.systemYellow.withAlphaComponent(0.7)
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? TagCell {
            cell.contentView.backgroundColor = UIColor.clear
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // Delete tag
        let deleteAction = UIContextualAction(style: .normal, title: "Delete", handler: {
            (ac:UIContextualAction, view: UIView, success:(Bool) -> Void) in
            guard let tagCell = tableView.cellForRow(at: indexPath) as? TagCell else {
                return
            }
            tagCell.marker.isHidden = true
            self.delegate?.deleteButtonTapped(tagCell, tagId: tagCell.id)
        })
        
        deleteAction.backgroundColor = UIColor.systemPink
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }

    // MARK: - Controller helper function
    
    private func buildTagFormFields() -> ManageTag.TagFormFields {
        let id = self.tagId
        let color = self.tagView.editTagView.colorView.backgroundColor?.toHex
        let name = self.tagView.editTagView.nameView.text!
        let description = self.tagView.editTagView.descriptionView.text!
        let createdDate = self.tagView.editTagView.dateView.text!
        
        return ManageTag.TagFormFields(id: id, name: name, color: color!, createdDate: createdDate, description: description)
    }
    
    func setTag(tagToEdit: ManageTag.TagFormFields) {
        let tagToEdit = tagToEdit
        self.tagId = tagToEdit.id
        self.tagView.editTagView.colorView.backgroundColor = UIColor(tagToEdit.color)
        self.tagView.editTagView.nameView.text = tagToEdit.name
        self.tagView.editTagView.descriptionView.text = tagToEdit.description
        self.tagView.editTagView.dateView.text = tagToEdit.createdDate
        
        self.setViewMode()
        setNavbarItems(mode: "view")
    }
    
    func setViewMode() {
        self.tagView.editTagView.colorView.isEnabled = false
        self.tagView.editTagView.colorView.setImage(UIImage(systemName: ""), for: .normal)
        self.tagView.editTagView.nameView.isEditable = false
        self.tagView.editTagView.nameView.backgroundColor = UIColor.clear
        self.tagView.editTagView.descriptionView.isEditable = false
        self.tagView.editTagView.descriptionView.backgroundColor = UIColor.clear

        self.tagView.editTagView.nameView.textViewDidChange(self.tagView.editTagView.nameView)
        self.tagView.editTagView.descriptionView.textViewDidChange(self.tagView.editTagView.descriptionView)
    }
    
    func setEditMode() {
        self.isEditMode = true
        if isCreateMode {
            self.tagView.editTagView.colorView.backgroundColor = UIColor.systemRed
            self.tagView.editTagView.nameView.text = "Tag Name"
            self.tagView.editTagView.descriptionView.text = "Description"
            self.tagView.editTagView.descriptionView.textColor = UIColor.lightGray
            self.tagView.editTagView.dateView.text = ""
            self.tagView.editTagView.nameView.textColor = UIColor.lightGray
            self.tagView.editTagView.descriptionView.textColor = UIColor.lightGray
        } else {
            self.tagView.editTagView.nameView.becomeFirstResponder()
        }
        self.tagView.editTagView.colorView.isEnabled = true
        self.tagView.editTagView.colorView.setImage(UIImage(systemName: "eyedropper")?.withTintColor(UIColor.white, renderingMode: .alwaysOriginal), for: .normal)
        
        self.tagView.editTagView.nameView.isEditable = true
        self.tagView.editTagView.descriptionView.isEditable = true
        self.tagView.editTagView.nameView.backgroundColor = UIColor.systemFill
        self.tagView.editTagView.descriptionView.backgroundColor = UIColor.systemFill
    }
    
    func setDefaultText() {
        self.tagView.editTagView.colorView.backgroundColor = UIColor.systemPink
        self.tagView.editTagView.nameView.textColor = UIColor.label
        self.tagView.editTagView.nameView.text = "No tag for this button"
        self.tagView.editTagView.descriptionView.text = "Tap the + button to create new tag or manage existing tags."
        self.tagView.editTagView.dateView.text = ""
    }
}
