//
//  AudioVisualizationView.swift
//  bSticky
//
//  Created by mima on 2021/02/02.
//  Copyright © 2021 FiftyPercent. All rights reserved.
//

import UIKit
import AVFoundation

// MARK: - Recorder visualizer view

class AudioRecorderVisualizerView: UIView {
    //  From: https://medium.com/@vialyx/ios-avfoundation-avaudioplayer-audio-power-visualizer-28669458c89
    
    // Configuration Settings
     private let updateInterval = 0.05
     private let animatioтDuration = 0.05
     private let maxPowerDelta: CGFloat = 30
     private let minScale: CGFloat = 0.9

    // Internal Timer to schedule updates from player
    private var timer: Timer?

    // Ingected Player to get power Metrics
    weak var player: AVAudioRecorder!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setupUI() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = UIColor.red
    }
    
     // Start scheduled player meters updates
     func start() {
        // Timer for power view
        timer = Timer.scheduledTimer(timeInterval: updateInterval,
                                      target: self,
                                      selector: #selector(self.updateMeters),
                                      userInfo: nil,
                                      repeats: true)
     }

     // Stop scheduled timer, reset self transfrom
     func stop() {
         guard timer != nil, timer!.isValid else {
             return
         }

         timer?.invalidate()
         timer = nil
         transform = .identity
     }

     // Animate self transform depends on player meters
     @objc private func updateMeters() {
        guard self.player != nil else { return}
         player.updateMeters()
        let power = CGFloat(player.averagePower(forChannel: 0))

         UIView.animate(withDuration: animatioтDuration, animations: {
             self.animate(to: power)
         }) { (_) in
            guard self.player != nil else { return }
             if !self.player.isRecording {
                 self.stop()
             }
         }
     }

     // Apply scale transform depends on power
     private func animate(to power: CGFloat) {
         let powerDelta = (maxPowerDelta + power) * 2 / 100
         let compute: CGFloat = minScale + powerDelta
         let scale: CGFloat = CGFloat.maximum(compute, minScale)
         self.transform = CGAffineTransform(scaleX: scale, y: scale)
        //self.backgroundColor = UIColor.systemRed.withAlphaComponent(scale.truncatingRemainder(dividingBy: 1))
     }
}

// MARK: - Player visualizer view

class AudioPlayerVisualizerView: UIView {

    // Configuration Settings
    private let updateInterval = 0.05
    private let animatioтDuration = 0.05
    private let maxPowerDelta: CGFloat = 30
    private let minScale: CGFloat = 0.9

     // Internal Timer to schedule updates from player
    private var timer: Timer?
    private var slideTimer: Timer?

     // Ingected Player to get power Metrics
    weak var player: AVAudioPlayer!
    
    var visualizerSize: CGFloat = 200
    
    let powerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.red
        view.clipsToBounds = true
        return view
    }()
    
    let slider: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        slider.isContinuous = true
        return slider
    }()
    

    // MARK: - Object lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setupUI() {
        translatesAutoresizingMaskIntoConstraints = false
        
        powerView.layer.cornerRadius = visualizerSize / 2
        
        addSubview(powerView)
        addSubview(slider)
        bringSubviewToFront(slider)
        
        NSLayoutConstraint.activate([
            powerView.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor),
            powerView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            powerView.widthAnchor.constraint(equalToConstant: visualizerSize),
            powerView.heightAnchor.constraint(equalToConstant: visualizerSize),

            slider.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: 10),
            slider.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            slider.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 30),
            slider.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -30)
        ])
    }
    
     // Start scheduled player meters updates
     func start() {
        // Timer for power view
        timer = Timer.scheduledTimer(timeInterval: updateInterval,
                                      target: self,
                                      selector: #selector(self.updateMeters),
                                      userInfo: nil,
                                      repeats: true)
        // Timer for slider view
        slideTimer = Timer.scheduledTimer(timeInterval: 0.1,
                                     target: self,
                                     selector: #selector(updateSlider),
                                     userInfo: nil,
                                     repeats: true)
        slider.maximumValue = Float((player?.duration)!)
     }

     // Stop scheduled timer, reset self transfrom
     func stop() {
        guard timer != nil, timer!.isValid, slideTimer != nil, slideTimer!.isValid else {
             return
         }

        timer?.invalidate()
        slideTimer?.invalidate()
    
        timer = nil
        slideTimer = nil
        powerView.transform = .identity
     }

     // Animate self transform depends on player meters
     @objc private func updateMeters() {
         guard self.player != nil else { return }
         player.updateMeters()
         let power = averagePowerFromAllChannels()

         UIView.animate(withDuration: animatioтDuration, animations: {
             self.animate(to: power)
         }) { (_) in
            guard self.player != nil else { return }
             if !self.player.isPlaying {
                 self.stop()
             }
         }
     }

     // Calculate average power from all channels
     private func averagePowerFromAllChannels() -> CGFloat {
         var power: CGFloat = 0.0
         (0..<player.numberOfChannels).forEach { (index) in
             power = power + CGFloat(player.averagePower(forChannel: index))
         }
         return power / CGFloat(player.numberOfChannels)
     }

     // Apply scale transform depends on power
     private func animate(to power: CGFloat) {
        let powerDelta = (maxPowerDelta + power) * 2 / 100
        let compute: CGFloat = minScale + powerDelta
        let scale: CGFloat = CGFloat.maximum(compute, minScale)
        //self.transform = CGAffineTransform(scaleX: scale, y: scale)
        powerView.transform = CGAffineTransform(scaleX: scale, y: scale)
     }
    
    @objc private func sliderValueChanged(_ sender: UISlider) {
        guard player != nil else { return }
        if player.isPlaying {
            player.stop()
            player.currentTime = TimeInterval(slider.value)
            player.play()
        } else {
            player.currentTime = TimeInterval(slider.value)
        }
        
    }
    
    @objc private func updateSlider() {
        guard player != nil else { return }
        slider.value = Float(player.currentTime)
    }
}
