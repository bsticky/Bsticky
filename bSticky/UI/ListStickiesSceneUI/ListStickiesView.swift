//
//  ListStickiesView.swift
//  bSticky
//
//  Created by mima on 2021/02/08.
//  Copyright © 2021 FiftyPercent. All rights reserved.
//

import UIKit

protocol ListStickiesViewDelegate: class {
    func navCancelButtonTapped(_ sender: Any)
    func swipedRight()
}

class ListStickiesView: UIView {

    weak var delegate: ListStickiesViewDelegate?
    
    let navBar: UINavigationBar = {
        let bar = UINavigationBar()
        bar.translatesAutoresizingMaskIntoConstraints = false
        bar.barTintColor = UIColor.systemYellow.withAlphaComponent(0.7)
        bar.tintColor = UIColor.black
        bar.layer.cornerRadius = 10
        bar.clipsToBounds = true
        return bar
    }()
    
    var collectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
        //layout.itemSize = CGSize(width: 100, height: 110)
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(StickyCell.self, forCellWithReuseIdentifier: "stickyCell")
        view.backgroundColor = UIColor.clear
        
        return view
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
    
    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = UIColor.systemBackground
        setNavbarItem()
        
        addSubview(navBar)
        addSubview(collectionView)
        
        // Swipe action
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swipedRight))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.addGestureRecognizer(swipeRight)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            navBar.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 5),
            navBar.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 10),
            navBar.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -10),
            navBar.heightAnchor.constraint(equalToConstant: 40),

            collectionView.topAnchor.constraint(equalTo: navBar.bottomAnchor, constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 10),
            collectionView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -10),
            collectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }

    // MARK: - Navigatino bar
    
    func setNavbarItem() {
        let navItem = UINavigationItem(title: "Tag Name")

        let cancelButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: nil, action: #selector(navCancelButtonTapped(_:)))
        
        navItem.setLeftBarButton(cancelButtonItem, animated: true)
        
        navBar.setItems([navItem], animated: true)
    }
    
    @objc func navCancelButtonTapped(_ sender: Any) {
        delegate?.navCancelButtonTapped(sender)
    }
    
    @objc func swipedRight(_ sender: Any) {
        delegate?.swipedRight()
    }
}
