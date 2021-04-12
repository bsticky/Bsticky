//
//  BeeAudioPlayerView.swift
//  bSticky
//
//  Created by mima on 2021/02/28.
//  Copyright © 2021 FiftyPercent. All rights reserved.
//

import UIKit

class BeeAudioPlayerView: UIView {
    
    weak var playerVisualizerView: AudioPlayerVisualizerView?
    
    lazy var playButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var saveButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 40, weight: .heavy, scale: .medium)
        button.setImage(UIImage(systemName: "pin.fill")?
                            .withConfiguration(symbolConfig)
                            .withTintColor(UIColor.white, renderingMode: .alwaysOriginal),
                        for: .normal)
        return button
    }()
    
    lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 40, weight: .bold, scale: .medium)
        button.setImage(UIImage(systemName: "trash")?
                            .withConfiguration(symbolConfig)
                            .withTintColor(UIColor.white, renderingMode: .alwaysOriginal),
                        for: .normal)
        return button
    }()
    
    lazy var buttonsStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.alignment = .fill
        view.distribution = .equalSpacing
        
        view.addArrangedSubview(deleteButton)
        view.addArrangedSubview(playButton)
        view.addArrangedSubview(saveButton)
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
        //fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = UIColor.black
      
        let playerVisualizerView = AudioPlayerVisualizerView()
        self.playerVisualizerView = playerVisualizerView
        
        addSubview(playerVisualizerView)
        addSubview(buttonsStackView)
        
        NSLayoutConstraint.activate([
            playerVisualizerView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 50),
            playerVisualizerView.bottomAnchor.constraint(equalTo: buttonsStackView.topAnchor, constant: -70),
            playerVisualizerView.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 20),
            playerVisualizerView.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -20),
            
            buttonsStackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20),
            buttonsStackView.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 20),
            buttonsStackView.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -20)
        ])
        
        setPlyerButton(false)
    }
    
    func setPlyerButton(_ isPlaying: Bool) {
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 50, weight: .bold, scale: .medium)
        if isPlaying {
            playButton.setImage(UIImage(systemName: "pause.circle")?
                                                .withConfiguration(symbolConfig)
                                                .withTintColor(UIColor.white, renderingMode: .alwaysOriginal),
                                             for: .normal)
        } else {
            playButton.setImage(UIImage(systemName: "play.circle")?
                                                .withConfiguration(symbolConfig)
                                                .withTintColor(UIColor.green, renderingMode: .alwaysOriginal),
                                             for: .normal)
        }
    }

}
