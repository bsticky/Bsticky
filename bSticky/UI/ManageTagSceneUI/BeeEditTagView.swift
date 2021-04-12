//
//  BeeEditTagView.swift
//  bSticky
//
//  Created by mima on 2021/03/11.
//  Copyright © 2021 FiftyPercent. All rights reserved.
//

import UIKit

class BeeEditTagView: UIView, BeeColorPickerViewDelegate {
    lazy var colorView: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemPink
        view.layer.cornerRadius = 45
        view.clipsToBounds = true
        view.isEnabled = false
        return  view
    }()
    
    lazy var nameView: BeeTextView = {
        let view = BeeTextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.boldSystemFont(ofSize: 20)
        view.isEditable = false
        view.text = "No tag on this button"
        return view
    }()

    lazy var descriptionView: BeeTextView = {
        let view = BeeTextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.systemFont(ofSize: 16)
        view.isEditable = false
        view.isScrollEnabled = false
        view.text = "Tap the + button to create new tag."
        return view
    }()
    
    lazy var dateView: BeeTextView = {
        let view = BeeTextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.monospacedSystemFont(ofSize: 12, weight: .light)
        return view
    }()
    
    lazy var pathView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.systemGray6
        view.heightAnchor.constraint(equalToConstant: 2).isActive = true
        return view
    }()
    
    lazy var colorPickerView = BeeColorPickerView()

    // MARK: - Object lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        setupConstraints()
    }
    
    required init?(coder aDcoder: NSCoder) {
        super.init(coder: aDcoder)
        setup()
        setupConstraints()
    }
    
    // MARK: - Set up
    
    func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(colorView)
        addSubview(nameView)
        addSubview(descriptionView)
        addSubview(dateView)
        addSubview(pathView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            colorView.widthAnchor.constraint(equalToConstant: 90),
            colorView.heightAnchor.constraint(equalToConstant: 90),
            colorView.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            colorView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            nameView.topAnchor.constraint(equalTo: colorView.bottomAnchor, constant: 20),
            nameView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            nameView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            
            descriptionView.topAnchor.constraint(equalTo: nameView.bottomAnchor, constant: 15),
            descriptionView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            descriptionView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            
            dateView.topAnchor.constraint(equalTo: descriptionView.bottomAnchor, constant: 10),
            //dateView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            dateView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            dateView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            
            pathView.topAnchor.constraint(equalTo: dateView.bottomAnchor, constant: 30),
            pathView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            pathView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            pathView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
        ])
    }
    
    // MARK: - ColorPicker View (iOS < 14.0)
    
    func setColorPickerView() {
        colorPickerView.displayView.backgroundColor = colorView.backgroundColor
        colorPickerView.delegate = self
        
        self.endEditing(true)
        self.addSubview(self.colorPickerView)
        self.bringSubviewToFront(self.colorPickerView)
        
        NSLayoutConstraint.activate([
            colorPickerView.topAnchor.constraint(equalTo: self.topAnchor, constant: 30),
            //colorPickerView.heightAnchor.constraint(equalToConstant: 400),
            colorPickerView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            colorPickerView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            colorPickerView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10)
        ])
    }
    
    func saveButtonTapped(_ sender: Any, selectedColor: UIColor) {
        self.colorView.backgroundColor = selectedColor
        self.endEditing(false)
        if let colorPickerView = self.viewWithTag(4781) {
            colorPickerView.removeFromSuperview()
        }
    }
    
    func cancelButtonTapped(_ sender: Any) {
        self.endEditing(false)
        if let colorView = self.viewWithTag(4781) {
            colorView.removeFromSuperview()
        }
    }
}
