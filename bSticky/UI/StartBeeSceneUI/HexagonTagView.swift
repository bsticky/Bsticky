//
//  sixHexagonTagView.swift
//  bSticky
//
//  Created by mima on 21/01/2021.
//  Copyright © 2021 FiftyPercent. All rights reserved.
//

import UIKit

protocol HexagonTagViewDelegate: class {
    func hiveButtonTapped()
    func hiveButtonLongTapped()
    func tagButtonTapped(tagId: Int, tagColor: UIColor)
    func tagButtonLongTapped(tagId: Int, tagPosition: Int)
    func tagButtonDropInHiveButton(tagId: Int, tagName: String, tagColor: UIColor)
}

class HexagonTagView: UIView {
    var numberOfTag: Int = 6
    weak var delegate: HexagonTagViewDelegate?
    
    var compactConstraints: [NSLayoutConstraint] = []
    var regularConstraints: [NSLayoutConstraint] = []
    var sharedConstraints: [NSLayoutConstraint] = []
    var smallTagSizeConstraints: [NSLayoutConstraint] = []
    var largeTagSizeConstraints: [NSLayoutConstraint] = []
    
    lazy var hiveButton: TagButton = {
        let button = TagButton()
        // TODO: change with user defaults user can set
        button.backgroundColor = UIColor.systemYellow.withAlphaComponent(0.8)
        return button
    }()
    
    lazy var tagButtons: [TagButton] = {
        var tagButtons: [TagButton] = []
        for i in 0...5 {
            tagButtons.append(TagButton(position: i))
        }
        return tagButtons
    }()

    
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
    
    // MARK: - Setup

    func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        // User settings
        backgroundColor = UIColor.systemBackground

        // View hierarchy
        addSubview(hiveButton)
        for tagButton in tagButtons {addSubview(tagButton)}
                
        // Hive button action
        hiveButton.addTarget(self, action: #selector(hiveButtonTapped(_:)), for: .touchUpInside)
        hiveButton.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(hiveButtonLongTapped(_:))))

        // Tag button action
        for tagButton in tagButtons {
            // Tap
            tagButton.addTarget(self, action: #selector(tagButtonTapped(_:)), for: .touchUpInside)
            // Long press
            tagButton.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(tagButtonLongTapped(_:))))
            // Drag
            //let dragGestrueRecognizer = UIPanGestureRecognizer(target: self, action: #selector(dragged(_:)))
            //tagButton.addGestureRecognizer(dragGestrueRecognizer)
            tagButton.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(tagButtonDragged(_:))))
        }
    }
    
    // MARK: - Tag button drag Action
   
    var initialTagPosition: CGPoint = .zero

    @objc func tagButtonDragged(_ gestureRecognizer: UIGestureRecognizer) {
        if let draggedTag = gestureRecognizer.view {
            if gestureRecognizer.state == .began {
                initialTagPosition = CGPoint(x: draggedTag.frame.midX,
                                             y: draggedTag.frame.midY)
                draggedTag.alpha = 0.4
            }
            else if gestureRecognizer.state == .changed {
                let newLocation = gestureRecognizer.location(in: draggedTag)
                
                draggedTag.center = CGPoint(x: draggedTag.frame.origin.x + newLocation.x,
                                            y: draggedTag.frame.origin.y + newLocation.y)
            }
            else if gestureRecognizer.state == .ended {
                if draggedTag.frame.intersects(hiveButton.frame) {
                    tagButtonDroppedInHiveButton(draggedTag as! TagButton)
                }
                draggedTag.alpha = 1
                draggedTag.center = initialTagPosition
            }
        }
    }
    // MARK: - Constraints
    
    func setupConstraints() {
        // Set tag button size for ipad
        for tagButton in tagButtons {
            largeTagSizeConstraints.append(contentsOf: [
                tagButton.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 1/5, constant: -8),
                tagButton.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 1/5, constant: -10)
            ])
        }
        
        for tagButton in tagButtons {
            compactConstraints.append(contentsOf: [
                tagButton.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 1/3, constant: -8),
                tagButton.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 1/5, constant: -10),
                
            ])
        }
        
        for tagButton in tagButtons {
            regularConstraints.append(contentsOf: [
                tagButton.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 1/5, constant: -8),
                tagButton.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 1/3, constant: -10),
            ])
        }
        
        sharedConstraints.append(contentsOf: [
            tagButtons[1].bottomAnchor.constraint(equalTo: hiveButton.topAnchor),
            tagButtons[1].trailingAnchor.constraint(equalTo: hiveButton.leadingAnchor),
            tagButtons[2].bottomAnchor.constraint(equalTo: hiveButton.topAnchor),
            tagButtons[2].leadingAnchor.constraint(equalTo: hiveButton.trailingAnchor),
            
            tagButtons[3].topAnchor.constraint(equalTo: hiveButton.bottomAnchor),
            tagButtons[3].trailingAnchor.constraint(equalTo: hiveButton.leadingAnchor),
            tagButtons[4].topAnchor.constraint(equalTo: hiveButton.bottomAnchor),
            tagButtons[4].leadingAnchor.constraint(equalTo: hiveButton.trailingAnchor),
            
            hiveButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            hiveButton.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
        
        // Landscape
        regularConstraints.append(contentsOf: [
            tagButtons[0].topAnchor.constraint(equalTo: tagButtons[1].bottomAnchor),
            tagButtons[0].trailingAnchor.constraint(equalTo: tagButtons[1].leadingAnchor),
            
            tagButtons[5].bottomAnchor.constraint(equalTo: tagButtons[4].topAnchor),
            tagButtons[5].leadingAnchor.constraint(equalTo: tagButtons[4].trailingAnchor),
            
            hiveButton.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 1/5, constant: -8),
            hiveButton.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 1/3, constant: -10)
        ])
        
        // Portrait
        compactConstraints.append(contentsOf: [
            tagButtons[0].bottomAnchor.constraint(equalTo: tagButtons[1].topAnchor),
            tagButtons[0].leadingAnchor.constraint(equalTo: tagButtons[1].trailingAnchor),
            
            tagButtons[5].trailingAnchor.constraint(equalTo: tagButtons[4].leadingAnchor),
            tagButtons[5].topAnchor.constraint(equalTo: tagButtons[4].bottomAnchor),
            
            hiveButton.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 1/3, constant: -8),
            hiveButton.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 1/5, constant: -10),
        ])
        
        largeTagSizeConstraints.append(contentsOf: [
            hiveButton.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 1/5, constant: -8),
            hiveButton.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 1/5, constant: -10)
        ])
    }
    
    // MARK: Layout trait
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        layoutTrait(traitCollection: traitCollection)
    }
    
    func layoutTrait(traitCollection: UITraitCollection) {
        if (!sharedConstraints[0].isActive) {
            NSLayoutConstraint.activate(sharedConstraints)
        }
        
        if traitCollection.horizontalSizeClass == .compact && traitCollection.verticalSizeClass == .regular {
            if regularConstraints.count > 0 && regularConstraints[0].isActive {
                NSLayoutConstraint.deactivate(regularConstraints)
            }
            NSLayoutConstraint.activate(compactConstraints)
        }
        else if traitCollection.horizontalSizeClass == .regular && traitCollection.verticalSizeClass == .regular {
            // Ipad
            if compactConstraints.count > 0 && regularConstraints[0].isActive {
                NSLayoutConstraint.deactivate(regularConstraints)
            }
            NSLayoutConstraint.activate(compactConstraints)
        }
        else {
            if compactConstraints.count > 0 && compactConstraints[0].isActive {
                NSLayoutConstraint.deactivate(compactConstraints)
            }
            NSLayoutConstraint.activate(regularConstraints)
        }
    }

    // MARK: - Button actions
    
    @objc func hiveButtonTapped(_ sender: TagButton) {
        self.delegate?.hiveButtonTapped()
    }
    
    @objc func hiveButtonLongTapped(_ gesture: UIPanGestureRecognizer) {
        if gesture.state == UIGestureRecognizer.State.began {
            self.delegate?.hiveButtonLongTapped()
        }
    }

    @objc func tagButtonTapped(_ sender: TagButton) {
        self.delegate?.tagButtonTapped(tagId: sender.tagId,
                                       tagColor: sender.backgroundColor!)
    }
    
    @objc func tagButtonLongTapped(_ gesture: UIPanGestureRecognizer) {
        guard let tagButton = gesture.view as? TagButton else {
            return
        }
        if gesture.state == UIGestureRecognizer.State.began {
            self.delegate?.tagButtonLongTapped(tagId: tagButton.tagId,
                                               tagPosition: tagButton.position) }
    }
    
    func tagButtonDroppedInHiveButton(_ sender: TagButton) {
        delegate?.tagButtonDropInHiveButton(tagId: sender.tagId,
                                            tagName: sender.title(for: .normal)!,
                                            tagColor: sender.backgroundColor!)
    }
}

// MARK: - TagButton

class TagButton: UIButton {
    var tagId: Int = 0
    var position: Int = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    convenience init(position: Int) {
        self.init()
        self.position = position
    }
    
    func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .darkGray
        titleLabel?.lineBreakMode = .byWordWrapping
        titleLabel?.textAlignment = .center
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // Circle
        clipsToBounds = true
        layer.cornerRadius = frame.width / 2
    }
    
    func setTagProfile(tagId: Int, title: String, bgColor: UIColor) {
        self.tagId = tagId
        self.setTitle(title, for: .normal)
        self.backgroundColor = bgColor.withAlphaComponent(0.8)
    }
}
