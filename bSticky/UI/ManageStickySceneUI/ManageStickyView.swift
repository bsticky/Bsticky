//
//  ManageStickyView.swift
//  bSticky
//
//  Created by mima on 2021/02/19.
//  Copyright © 2021 FiftyPercent. All rights reserved.
//

import UIKit

protocol ManageStickyViewDelegate: class {
    func swipedRight()
    func nextButtonTapped()
    func previousButtonTapped()
    func bottomMiddleButtonTapped()
}

class ManageStickyView: UIView {
    
    weak var delegate: ManageStickyViewDelegate?
    var tagId: Int?
    
    // Header views
    
    lazy var tagNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        label.text = "Project BSticky"
        return label
    }()
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.monospacedSystemFont(ofSize: 12, weight: .light)
        label.textAlignment = .right
        label.text = "14.Feb.2021"
        return label
    }()
    
    // Content views
    
    lazy var textView: UITextView = {
        let view = UITextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.systemFont(ofSize: 18, weight: .light)
        view.isScrollEnabled = true
        view.textAlignment = .center
        view.backgroundColor = UIColor.systemGray4.withAlphaComponent(0.7)
        view.layer.cornerRadius = 10
        view.isEditable = false
        return view
    }()
    
    lazy var beeImageView: BeeZoomImageView = {
        let view = BeeZoomImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var audioPlayerView: BeeAudioPlayerView = {
        let view = BeeAudioPlayerView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.systemGray.withAlphaComponent(0.7)
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        
        view.deleteButton.removeFromSuperview()
        view.saveButton.removeFromSuperview()
        return view
    }()

    // Bottom buttons
    
    lazy var previousButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let buttonConfig = UIImage.SymbolConfiguration(pointSize: 44, weight: .bold)
        button.setImage(UIImage(systemName: "lessthan.circle.fill")?
                            .withConfiguration(buttonConfig)
                            .withTintColor(UIColor.systemGray4)
                            .withRenderingMode(.alwaysOriginal),
                        for: .normal)
        button.addTarget(self, action: #selector(previousButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var nextButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let buttonConfig = UIImage.SymbolConfiguration(pointSize: 44, weight: .bold)
        button.setImage(UIImage(systemName: "greaterthan.circle.fill")?
                            .withConfiguration(buttonConfig)
                            .withTintColor(UIColor.systemGray4)
                            .withRenderingMode(.alwaysOriginal),
                        for: .normal)
        button.addTarget(self, action: #selector(nextButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var bottomMiddleButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let buttonConfig = UIImage.SymbolConfiguration(pointSize: 44, weight: .bold)
        button.setImage(UIImage(systemName: "minus")?
                            .withConfiguration(buttonConfig)
                            .withTintColor(UIColor.systemGray4)
                            .withRenderingMode(.alwaysOriginal),
                        for: .normal)
        button.addTarget(self, action: #selector(bottomMiddleButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var topStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.distribution = .fillEqually
        view.spacing = 5

        view.addArrangedSubview(tagNameLabel)
        view.addArrangedSubview(dateLabel)
        return view
    }()
    
    lazy var contentsStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.alignment = .fill
        view.distribution = .equalSpacing
        return view
    }()
    
    lazy var bottomStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.alignment = .fill
        view.distribution = .equalSpacing

        view.addArrangedSubview(previousButton)
        view.addArrangedSubview(bottomMiddleButton)
        view.addArrangedSubview(nextButton)
        
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
    
    // MARK: - Set up
    
    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = UIColor.systemBackground
        
        // Swipe action
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swipedRight))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.addGestureRecognizer(swipeRight)
        
        addSubview(topStackView)
        addSubview(contentsStackView)
        addSubview(bottomStackView)
        
        
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            topStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            topStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
            topStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20),

            contentsStackView.topAnchor.constraint(equalTo: topStackView.bottomAnchor, constant: 20),
            contentsStackView.bottomAnchor.constraint(equalTo: bottomStackView.topAnchor, constant: -10),
            contentsStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 10),
            contentsStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -10),

            bottomStackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -10),
            bottomStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
            bottomStackView.trailingAnchor.constraint(greaterThanOrEqualTo: safeAreaLayoutGuide.trailingAnchor, constant: -20),
        ])
    }

    // MARK: - Delegate function
    
    @objc func swipedRight() {
        delegate?.swipedRight()
    }
    
    @objc func nextButtonTapped(_ sender: Any) {
        delegate?.nextButtonTapped()
    }
    
    @objc func previousButtonTapped(_ sender: Any) {
        delegate?.previousButtonTapped()
    }
    
    @objc func bottomMiddleButtonTapped(_ sender: Any) {
        delegate?.bottomMiddleButtonTapped()
    }
    
    // MARK: Helper function
    
    func dismissSubviews() {
        if self.beeImageView.image != nil {
            self.beeImageView.image = nil
        }
        contentsStackView.subviews.forEach({ $0.removeFromSuperview() })
    }
    
    // Text view delegate
    /*
     // Should be coped in to setup function
     // keyboard
     let notificationCenter = NotificationCenter.default
     notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
     notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
     
     // textview delegate function
    func textViewDidChange(_ textView: UITextView) {
        print("text did chagned")
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        print("text did end editing")
    }
    
    // MARK: - Adjust keyboard
    
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
    */
}
