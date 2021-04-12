//
//  BeeColorPickerView.swift
//  bSticky
//
//  * BeeColorPickerView hierarchy:
//    |BeeColorPickerView(UIView,
//                        UICollectionViewDelegate,
//                        UICollectionViewDataSource)
//       |- displayView(UIView)
//          |- colorSwatchView(UICollectionView)
//          |- saveButton(UIButton)
//          |- cancelButton(UIButton)
//
//
//  Created by mima on 21/01/2021.
//  Copyright © 2021 FiftyPercent. All rights reserved.
//

import UIKit

// MARK: - BeeColorPickerView Protocol

protocol BeeColorPickerViewDelegate: class {
    func saveButtonTapped(_ sender: Any, selectedColor: UIColor)
    func cancelButtonTapped(_ sender: Any)
}

// MARK: - BeeColorPickerView

class BeeColorPickerView: UIView, UICollectionViewDelegate, UICollectionViewDataSource {
    weak var delegate: BeeColorPickerViewDelegate?
    
    let defaultColorSwatch = ["Maraschino": "#FF2600",
                              "Tangerine": "#FF9300",
                              "Lemon": "#FFFB00",
                              "Lime": "#8EFA00",
                              "Spring": "#00F900",
                              "SeaFoam": "#00FA92",
                              "Turquoise": "#00FDFF",
                              "Aqua": "#0096FF",
                              "Blueberry": "#0433FF",
                              "Grape": "#9437FF",
                              "Magenta": "#FF40FF",
                              "Strawberry": "#FF2F92"
    ]
    
    let displayView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 40
        view.clipsToBounds = true
        return view
    }()
    
    let colorSwatchView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 30, height: 30)
        layout.scrollDirection = .horizontal
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.systemGray5
        return view
    }()
    
    let saveButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Save", for: .normal)
        button.backgroundColor = UIColor.systemPink
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.sizeToFit()
        return button
    }()
    
    let cancelButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("X", for: .normal)
        button.backgroundColor = UIColor.systemGray
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.sizeToFit()
        return button
    }()
    
    // MARK: Object life cycle
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

    // MARK: Set up
    func setup() {
        tag = 4781
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = UIColor.systemGray2
        layer.cornerRadius = 10
        
        addSubview(displayView)
        addSubview(colorSwatchView)
        addSubview(saveButton)
        addSubview(cancelButton)
        
        colorSwatchView.delegate = self
        colorSwatchView.dataSource = self
        colorSwatchView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "testCell")
        
        saveButton.addTarget(nil, action: #selector(saveButtonTapped(_:)), for: UIControl.Event.touchUpInside)
        cancelButton.addTarget(nil, action: #selector(cancelButtonTapped(_:)), for: UIControl.Event.touchUpInside)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            cancelButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 15),
            cancelButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 10),
            
            displayView.topAnchor.constraint(equalTo: cancelButton.bottomAnchor),
            displayView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            displayView.widthAnchor.constraint(equalToConstant: 80),
            displayView.heightAnchor.constraint(equalToConstant: 80),
            
            colorSwatchView.topAnchor.constraint(equalTo: displayView.bottomAnchor, constant: 20),
            colorSwatchView.bottomAnchor.constraint(equalTo: saveButton.topAnchor),
            colorSwatchView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            colorSwatchView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            saveButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            saveButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            saveButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
        ])
    }
    
    // ColorSwatchView (Collection view delegate, datastore)
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let testCell = collectionView.dequeueReusableCell(withReuseIdentifier: "testCell", for: indexPath)
        let color = Array(defaultColorSwatch)[indexPath.row].value
        testCell.backgroundColor = UIColor(color)
        return testCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        self.displayView.backgroundColor = cell?.backgroundColor
    }
    
    // Button Action
    @IBAction func saveButtonTapped(_ sender: Any) {
        let selectedColor = displayView.backgroundColor!
        delegate?.saveButtonTapped(sender, selectedColor: selectedColor)
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        delegate?.cancelButtonTapped(sender)
    }
}
