//
//  File.swift
//  bSticky
//
//  Created by mima on 21/01/2021.
//  Copyright © 2021 FiftyPercent. All rights reserved.
//

import UIKit

protocol CreateStickyViewDelegate: class {
    func swipedRight()
    func swipedLeft()
    func cameraButtopTapped(_ sender: Any)
    func recordingButtonTapped(_ sender: Any)
}


class CreateStickyView: UIView {
    weak var delegate: CreateStickyViewDelegate?
    
    lazy var cameraButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(cameraButtonTapped(_:)), for: UIControl.Event.touchUpInside)
        let iconConfig = UIImage.SymbolConfiguration(pointSize: 33, weight: .light, scale: .medium)
        button.setImage(UIImage(systemName: "camera.fill")?.withConfiguration(iconConfig), for: .normal)
        button.tintColor = UIColor.black

        return button
    }()
    
    lazy var recordingButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(recordingButtonTapped(_:)), for: UIControl.Event.touchUpInside)
        let iconConfig = UIImage.SymbolConfiguration(pointSize: 33, weight: .light, scale: .medium)
        button.setImage(UIImage(systemName: "mic.fill")?.withConfiguration(iconConfig), for: .normal)
        button.tintColor = UIColor.black
        return button
    }()
    
    lazy var toolBar: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.backgroundColor = UIColor.yellow.withAlphaComponent(0.5)
        view.axis = .horizontal
        view.alignment = .fill
        view.distribution = .equalSpacing
        view.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        view.isLayoutMarginsRelativeArrangement = true
        
        view.addArrangedSubview(cameraButton)
        view.addArrangedSubview(recordingButton)
        return view
    }()

    lazy var textView: UITextView = {
        let view = UITextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isEditable = true
        view.isScrollEnabled = true
        view.keyboardDismissMode = .onDrag
        view.layer.cornerRadius = 10
        view.font = UIFont.systemFont(ofSize: 18)
        view.backgroundColor = UIColor.systemGray.withAlphaComponent(0.7)
        view.text = ""
        return view
    }()

    lazy var savedAnimationView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 120, weight: .bold)
        view.image = UIImage(systemName: "checkmark.seal.fill")?
            .withConfiguration(imageConfig)
            .withTintColor(UIColor.white)
            .withRenderingMode(.alwaysOriginal)
        
        view.backgroundColor = UIColor.systemGreen
        view.layer.cornerRadius = 10
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
        backgroundColor = UIColor.systemGray4

        // Swipe action
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swipedRight))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.addGestureRecognizer(swipeRight)
        
        let swipteLeft = UISwipeGestureRecognizer(target: self, action: #selector(swipedLeft))
        swipteLeft.direction = UISwipeGestureRecognizer.Direction.left
        self.addGestureRecognizer(swipteLeft)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(swipedDown))
        swipeDown.direction = UISwipeGestureRecognizer.Direction.down
        self.addGestureRecognizer(swipeDown)

        addSubview(toolBar)
        addSubview(textView)
        toolBar.addSubview(cameraButton)
        toolBar.addSubview(recordingButton)
        
        // keyboard
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            textView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 10),
            textView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -10),
            textView.bottomAnchor.constraint(equalTo: toolBar.topAnchor, constant: -15),
            
            toolBar.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -15),
            toolBar.heightAnchor.constraint(equalToConstant: 44),
            toolBar.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 10),
            toolBar.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -10)
        ])
    }

    // Adjust keyboard for text view
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = convert(keyboardScreenEndFrame, from: window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            textView.contentInset = .zero
        } else {
            textView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - self.safeAreaInsets.bottom, right: 0)
        }
        textView.scrollIndicatorInsets = textView.contentInset
    }

    // MARK: - View Delegate
    
    @objc func swipedRight() {
        delegate?.swipedRight()
    }
    
    @objc func swipedLeft() {
        delegate?.swipedLeft()
    }
    
    @objc func swipedDown() {
        // Dismiss keyboard
        textView.endEditing(true)
    }

    @objc func cameraButtonTapped(_ sender: Any) {
        delegate?.cameraButtopTapped(sender)
    }
    
    @objc func recordingButtonTapped(_ sender: Any) {
        delegate?.recordingButtonTapped(sender)
    }
    
    func showSavedAnimation() {
        textView.endEditing(true)
        textView.alpha = 0
        toolBar.alpha = 0

        self.addSubview(savedAnimationView)
        
        NSLayoutConstraint.activate([
            savedAnimationView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            savedAnimationView.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor),
        ])
        
        savedAnimationView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        
        UIView.animate(
            withDuration: 0, delay: 0.5, usingSpringWithDamping: 0.3, initialSpringVelocity: 2,
            options: .curveEaseOut, animations: {
                self.savedAnimationView.transform = .identity
                self.savedAnimationView.alpha = 0
        }, completion: nil)

        /*
        UIView.animate(withDuration: 1, delay: 1, options: .curveEaseOut, animations: { [self] in
            savedAnimationView.alpha = 0
        }, completion: { [self]_ in savedAnimationView.backgroundColor = .blue})
        */

        /*
        let offset = CGPoint(x: frame.maxX, y: 0)
        let x: CGFloat = 0, y: CGFloat = 0
        savedAnimationView.transform = CGAffineTransform(translationX: offset.x + x, y: offset.y + y)
        UIView.animate(
            withDuration: 0.7, delay: 0.5, usingSpringWithDamping: 0.3, initialSpringVelocity: 2,
            options: .curveEaseOut, animations: {
                self.textView.alpha = 0
                self.savedAnimationView.transform = .identity
                self.savedAnimationView.alpha = 1
        })
        */
    }
}
