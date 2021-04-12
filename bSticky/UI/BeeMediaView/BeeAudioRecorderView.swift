//
//  BeeAudioRecorderView.swift
//  bSticky
//
//  Created by mima on 2021/02/28.
//  Copyright © 2021 FiftyPercent. All rights reserved.
//

import UIKit

class BeeAudioRecorderView: UIView {
    
    //weak var recorderVisualizerView: AudioRecorderPowerVisualizerView?
    private let visualizerSize: CGFloat = 120
    
    lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 40,
                                                       weight: .heavy,
                                                       scale: .medium)
        button.setImage(UIImage(systemName: "xmark.circle.fill")?
                            .withConfiguration(symbolConfig)
                            .withTintColor(UIColor.white, renderingMode: .alwaysOriginal),
                        for: .normal)
        button.tintColor = UIColor.white
        return button
    }()
    
    lazy var recorderVisualizerView: AudioRecorderVisualizerView = {
        let view = AudioRecorderVisualizerView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.frame.size.width = CGFloat(visualizerSize)
        view.frame.size.height = CGFloat(visualizerSize)
        view.layer.cornerRadius = visualizerSize / 2
        return view
    }()
    
    lazy var recordingTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        label.font = UIFont.boldSystemFont(ofSize: 30.0)
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        return label
    }()
    
    lazy var recordingButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
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
        // fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - set up
    
    private func setupUI() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = UIColor.black
        
        addSubview(cancelButton)
        addSubview(recorderVisualizerView)
        addSubview(recordingTimeLabel)
        addSubview(recordingButton)
        
        setRecordingButton(false)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            cancelButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            cancelButton.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 20),
            
            recorderVisualizerView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            recorderVisualizerView.bottomAnchor.constraint(equalTo: recordingTimeLabel.topAnchor, constant: -20),
            recorderVisualizerView.widthAnchor.constraint(equalToConstant: visualizerSize),
            recorderVisualizerView.heightAnchor.constraint(equalToConstant: visualizerSize),
            
            recordingTimeLabel.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            recordingTimeLabel.bottomAnchor.constraint(equalTo: recordingButton.topAnchor, constant: -40),
            
            recordingButton.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            recordingButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
    
    // Set recording button
    
    func setRecordingButton(_ isRecording: Bool) {
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 50, weight: .bold, scale: .large)
        if isRecording {
            recordingButton.setImage(UIImage(systemName: "stop.circle")?
                                                    .withConfiguration(symbolConfig)
                                                    .withTintColor(UIColor.red, renderingMode: .alwaysOriginal),
                                     for: .normal)
            
            recordingTimeLabel.isHidden = false
        } else {
            recordingButton.setImage(UIImage(systemName: "record.circle")?
                                                    .withConfiguration(symbolConfig)
                                                    .withTintColor(UIColor.red,renderingMode: .alwaysOriginal),
                                                  for: .normal)
        }
    }

}
