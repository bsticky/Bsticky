//
//  SettingsViewController.swift
//  bSticky
//
//  Created by mima on 2021/03/18.
//  Copyright © 2021 FiftyPercent. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    weak var settingsView: BeeSettingsView!
    
    // MARK: - Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        setupUI()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        let settingsView = BeeSettingsView()

        view.addSubview(settingsView)
        self.settingsView = settingsView
        
        NSLayoutConstraint.activate([
            settingsView.topAnchor.constraint(equalTo: view.topAnchor),
            settingsView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            settingsView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            settingsView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        // set navBar
        
        let navItem = UINavigationItem(title: "Settings")
        
        let doneButton = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(navDoneButtonTapped(_:)))
        
        navItem.setLeftBarButton(doneButton, animated: true)
        settingsView.navBar.setItems([navItem], animated: true)
        
        // menu bar button
        
        settingsView.appearanceMenuButton.addTarget(self, action: #selector(appreanceMenuButtonTapped(_:)), for: .touchUpInside)
    }
    
    @objc func appreanceMenuButtonTapped(_ sender: Any) {
        self.navigationController?.present(AppreanceSettingViewController(), animated: true, completion: nil)
    }

    @objc func navDoneButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
