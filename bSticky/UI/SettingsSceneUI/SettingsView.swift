//
//  SettingsView.swift
//  bSticky
//
//  Created by mima on 2021/03/15.
//  Copyright © 2021 FiftyPercent. All rights reserved.
//
import UIKit

class BeeSettingsView: UIView {

    lazy var navBar: UINavigationBar = {
        let bar = UINavigationBar()
        bar.translatesAutoresizingMaskIntoConstraints = false
        bar.barTintColor = UIColor(named: "camellia")?.withAlphaComponent(0.7)
        bar.tintColor = UIColor.black
        bar.layer.cornerRadius = 10
        bar.clipsToBounds = true
        return bar
    }()
    
    // Appearance menu bar
    
    lazy var appearanceIconView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.image = UIImage(systemName: "sun.max")
        return view
    }()
    
    lazy var appearanceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Appreance"
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    lazy var appearanceMenuButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        return button
    }()

    lazy var wallpaperMenu: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        
        view.axis = .horizontal
        view.alignment = .fill
        view.distribution = .equalSpacing
        view.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        view.isLayoutMarginsRelativeArrangement = true
        
        view.addArrangedSubview(appearanceIconView)
        view.addArrangedSubview(appearanceLabel)
        view.addArrangedSubview(appearanceMenuButton)
        return view
    }()
    
    // MARK: - Object lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = UIColor.systemBackground
        
        addSubview(navBar)
        addSubview(wallpaperMenu)

        NSLayoutConstraint.activate([
            navBar.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            navBar.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 10),
            navBar.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -10),
            
            wallpaperMenu.topAnchor.constraint(equalTo: navBar.bottomAnchor, constant: 20),
            wallpaperMenu.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
            wallpaperMenu.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
    }
}
