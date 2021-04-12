//
//  SettingsViewDev.swift
//  bSticky
//
//  Created by mima on 2021/03/21.
//  Copyright © 2021 FiftyPercent. All rights reserved.
//

import UIKit

class AppreanceSettingView: UIScrollView {
    
    lazy var navBar: UINavigationBar = {
        let bar = UINavigationBar()
        bar.translatesAutoresizingMaskIntoConstraints = false
        bar.barTintColor = UIColor(named: "camellia")?.withAlphaComponent(0.7)
        bar.tintColor = UIColor.black
        bar.layer.cornerRadius = 10
        bar.clipsToBounds = true
        return bar
    }()
    
    lazy var wallpaperPreview: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()

    lazy var menuStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        
        view.axis = .vertical
        view.distribution = .fillEqually
        view.spacing = 20
        // view.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        // view.isLayoutMarginsRelativeArrangement = true
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
        addSubview(wallpaperPreview)
        addSubview(menuStackView)
        
        NSLayoutConstraint.activate([
            navBar.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            navBar.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 10),
            navBar.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -10),
            
            wallpaperPreview.topAnchor.constraint(equalTo: navBar.bottomAnchor, constant: 30),
            wallpaperPreview.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.4),
            wallpaperPreview.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.4),
            wallpaperPreview.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            
            menuStackView.topAnchor.constraint(equalTo: wallpaperPreview.bottomAnchor, constant: 20),
            menuStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 10),
            menuStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -10)
        ])
    }
    
}

class SettingMenuSection: UIStackView {
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        return label
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = UIColor.systemGray4.withAlphaComponent(0.6)
        layer.cornerRadius = 10
        clipsToBounds = true
        axis = .vertical
        distribution = .fillEqually
        spacing = 20
        layoutMargins = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        isLayoutMarginsRelativeArrangement = true
        insertArrangedSubview(titleLabel, at: 0)
    }
}

class SettingMenuBar: UIStackView {
    lazy var iconView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    lazy var arrowButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let boldconfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold)
        button.setImage(UIImage(systemName: "chevron.right")?.withConfiguration(boldconfig), for: .normal)
        return button
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        translatesAutoresizingMaskIntoConstraints = false
        axis = .horizontal
        alignment = .fill
        distribution = .equalSpacing

        addArrangedSubview(iconView)
        addArrangedSubview(titleLabel)
        addArrangedSubview(arrowButton)
    }
    
    func setMenu(iconName: String, title: String) {
        self.iconView.image = UIImage(systemName: iconName)
        self.titleLabel.text = title
    }
}
