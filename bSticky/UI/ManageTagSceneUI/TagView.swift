//
//  TagView.swift
//  bSticky
//
//  * TagView hierarchy:
//    |TagView(UIScrollView)
//       |- containerView(UIView)
//          |- editTagView(EditTagView)
//             |- colorView(UIButton)
//             |- nameView(BeeTextView)
//             |- descriptionView(BeeTextView)
//             |- dateView(BeeTextView)
//             |- pathView(UIView)
//             |- colorPickerView(BeeColorPickerView)
//          |- margineView(UIView)
//
//  * Class
//    - TagView
//    - EditTagView
//    - BeeTextView
//
//  Created by mima on 21/01/2021.
//  Copyright © 2021 FiftyPercent. All rights reserved.

import UIKit


// MARK: - TagView (scroll view)

class TagView: UIScrollView {
    
    var isEditMode: Bool = false
    var isCreateTagMode: Bool = false
    
    let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let editTagView = BeeEditTagView()
    
    let margineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .purple
        return view
    }()
    
    // MARK:- Object lifecycle
    
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
    
    // MARK:- Set up
    
    func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        isUserInteractionEnabled = true
        canCancelContentTouches = true
        isExclusiveTouch = true
        contentInsetAdjustmentBehavior = .never
        keyboardDismissMode = .onDrag
        backgroundColor = .systemBackground
        
        // View hierarchy
        addSubview(containerView)
        containerView.addSubview(editTagView)
        containerView.addSubview(margineView)
        
        // keyboard
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    // Set up constraints
    func setupConstraints() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: self.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            containerView.widthAnchor.constraint(equalTo: self.widthAnchor),
            
            editTagView.topAnchor.constraint(equalTo: containerView.topAnchor),
            editTagView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            editTagView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            
            margineView.topAnchor.constraint(equalTo: editTagView.bottomAnchor),
            margineView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            margineView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            margineView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
        ])
    }
    
    // Adjust Keyboard (source from StackOverFlow)
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = convert(keyboardScreenEndFrame, from: window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            self.contentInset = .zero
        } else {
            contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - self.safeAreaInsets.bottom, right: 0)
        }
        self.scrollIndicatorInsets = self.contentInset
    }
}
