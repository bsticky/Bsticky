//
//  BeePhotoPreview.swift
//  bSticky
//
//  Created by mima on 2021/01/26.
//  Copyright © 2021 FiftyPercent. All rights reserved.
//

import UIKit

protocol BeePhotoPrevewDelegate: class {
    func stickButtonTapped(image: UIImage!)
}

class BeePhotoPreview: UIView {
    
    weak var delegate: BeePhotoPrevewDelegate?
    
    lazy var photoImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        //view.layer.cornerRadius = 10
        view.clipsToBounds = true
        view.backgroundColor = UIColor.systemGray3
        return view
    }()
    
    lazy var retakeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(retakeButtonTapped(_:)), for: .touchUpInside)
        let iconConfig = UIImage.SymbolConfiguration(pointSize: 44, weight: .light, scale: .medium)
        button.setImage(UIImage(systemName: "xmark.circle")?.withConfiguration(iconConfig), for: .normal)
        button.tintColor = UIColor.systemRed
        return button
    }()
    
    lazy var stickButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(stickButtonTapped(_:)), for: .touchUpInside)
        let iconConfig = UIImage.SymbolConfiguration(pointSize: 44, weight: .light, scale: .medium)
        button.setImage(UIImage(systemName: "checkmark.circle")?.withConfiguration(iconConfig), for: .normal)
        button.tintColor = UIColor.systemYellow
        return button
    }()
    
    // MARK: - Object lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
        setupConstraints()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(photoImageView)
        addSubview(retakeButton)
        addSubview(stickButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            photoImageView.topAnchor.constraint(equalTo: topAnchor),
            photoImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            photoImageView.rightAnchor.constraint(equalTo: rightAnchor),
            photoImageView.leftAnchor.constraint(equalTo: leftAnchor),
            
            retakeButton.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 30),
            retakeButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20),

            stickButton.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -30),
            stickButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20),
        ])
    }

    // MARK: - Button action
    
    @IBAction func retakeButtonTapped(_ sender: Any) {
        DispatchQueue.main.async {
            self.removeFromSuperview()
        }
    }
    
    @IBAction func stickButtonTapped(_ sender: Any) {
        self.delegate?.stickButtonTapped(image: photoImageView.image)
        
        DispatchQueue.main.async {
            self.removeFromSuperview()
        }
    }
}
