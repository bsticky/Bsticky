//
//  BeeCameraView.swift
//  bSticky
//
//  Created by mima on 2021/01/27.
//  Copyright © 2021 FiftyPercent. All rights reserved.
//

import UIKit

protocol BeeCameraViewDelegate: class {
    func cancelButtonTapped()
    func shutterButtonTapped()
    func flashButtonTapped()
    func switchCameraButtonTapped()
}

class BeeCameraView: UIView {
    weak var delegate: BeeCameraViewDelegate?
  
    let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        button.tintColor = UIColor.white
        button.layer.cornerRadius = 20
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.systemYellow.cgColor
        return button
    }()
    
    let shutterButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(shutterButtonTapped), for: .touchUpInside)
        button.backgroundColor = UIColor.red
        button.layer.cornerRadius = 30
        button.layer.borderWidth = 2
        button.layer.borderColor = CGColor(srgbRed: 12, green: 45, blue: 8, alpha: 0.7)
        button.clipsToBounds = true
        return button
    }()
    
    let flashButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(flashButtonTapped(_:)), for: .touchUpInside)
        button.setImage(UIImage(systemName: "bolt.slash.fill"), for: .normal)
        button.tintColor = UIColor.systemYellow
        button.layer.cornerRadius = 20
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.systemYellow.cgColor
        return button
    }()
    
    let switchCameraButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(switchCameraButtonTapped(_:)), for: .touchUpInside)
        button.setImage(UIImage(named: "cameraSwitch"), for: .normal)
        button.tintColor = UIColor.systemYellow
        button.layer.cornerRadius = 20
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.systemYellow.cgColor
        return button
    }()
    
    // MARK: - Object lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Setup
    
    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(cancelButton)
        addSubview(shutterButton)
        addSubview(flashButton)
        addSubview(switchCameraButton)
           
        NSLayoutConstraint.activate([

            cancelButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 15),
            cancelButton.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -15),
            cancelButton.widthAnchor.constraint(equalToConstant: 40),
            cancelButton.heightAnchor.constraint(equalToConstant: 40),
            
            shutterButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20),
            shutterButton.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            shutterButton.widthAnchor.constraint(equalToConstant: 60),
            shutterButton.heightAnchor.constraint(equalToConstant: 60),

            flashButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -30),
            flashButton.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -30),
            flashButton.widthAnchor.constraint(equalToConstant: 40),
            flashButton.heightAnchor.constraint(equalToConstant: 40),
            
            switchCameraButton.topAnchor.constraint(equalTo: flashButton.topAnchor),
            switchCameraButton.rightAnchor.constraint(equalTo: flashButton.leftAnchor, constant: -20),
            switchCameraButton.widthAnchor.constraint(equalToConstant: 40),
            switchCameraButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    // MARK: - Button action
    
    @objc func cancelButtonTapped(_ sender: Any) {
        delegate?.cancelButtonTapped()
    }
    @objc func shutterButtonTapped(_ sender: Any) {
        delegate?.shutterButtonTapped()
    }
    @objc func flashButtonTapped(_ sender: Any) {
        delegate?.flashButtonTapped()
    }
    @objc func switchCameraButtonTapped(_ sender: Any) {
        delegate?.switchCameraButtonTapped()
    }
}
