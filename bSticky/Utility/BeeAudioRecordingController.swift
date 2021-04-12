//
//  AudioRecordingViewController.swift
//  bSticky
//
//  Created by mima on 23/01/2021.
//  Copyright © 2021 FiftyPercent. All rights reserved.
//

import UIKit
import AVFoundation

protocol BeeAudioRecordingControllerDelegate: class {
    func audioPlayerSaveButtonTapped(filePath: String!)
}

class BeeAudioRecordingController: UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    
    weak var delegate: BeeAudioRecordingControllerDelegate?

    weak var recorderView: BeeAudioRecorderView!
    weak var playerView: BeeAudioPlayerView!
    
    var recorder: BeeAudioRecorderComposition!
    var player: BeeAudioPlayerComposition!

    var url: URL!
    var meterTimer: Timer!
    var isRecording = false
    var isPlaying = false
    
    // MARK: - View lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // only portrait
        AppUtility.lockOrientation(.portrait)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        openRecorder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        AppUtility.lockOrientation(.allButUpsideDown)
    }
    
    // MARK: - Permission check
    
    func openRecorder() {
        switch AVAudioSession.sharedInstance().recordPermission {
        case .undetermined:
            AVAudioSession.sharedInstance().requestRecordPermission({ (allowed) in
                if allowed {
                    DispatchQueue.main.async {
                        self.setupUI()
                    }
                } else {
                    self.handleDismiss()
                }
            })
            break
        
        case .denied:
            self.handleDismiss()
        
        case .granted:
            DispatchQueue.main.async {
                self.setupUI()
            }
        @unknown default:
            self.handleDismiss()
        }
    }
    
    // MARK: - Setup UI
    
    func setupUI() {
        let recorderView = BeeAudioRecorderView()
        let playerView = BeeAudioPlayerView()
        
        view.addSubview(recorderView)
        view.addSubview(playerView)
        view.bringSubviewToFront(recorderView)
        
        self.recorderView = recorderView
        self.playerView = playerView
        
        NSLayoutConstraint.activate([
            recorderView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            recorderView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            recorderView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            recorderView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            
            playerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            playerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            playerView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            playerView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
        ])
        
        recorderView.cancelButton.addTarget(self, action: #selector(cancelButtonTapped(_:)), for: .touchUpInside)
        recorderView.recordingButton.addTarget(self, action: #selector(recordingButtonTapped(_:)), for: .touchUpInside)
        
        playerView.playButton.addTarget(self, action: #selector(playButtonTapped(_:)), for: .touchUpInside)
        playerView.saveButton.addTarget(self, action: #selector(saveButtonTapped(_:)), for: .touchUpInside)
        playerView.deleteButton.addTarget(self, action: #selector(deleteButtonTapped(_:)), for: .touchUpInside)
    }
    
    // MARK: - Init audio recorder
    
    func prepareRecorder() {
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(AVAudioSession.Category.playAndRecord)
            try session.setActive(true)
            let settings = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 44100,
                AVNumberOfChannelsKey: 2,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]
          
            url = try BeeMediaHelper.generateNewFileURL(mediaType: BeeMediaHelper.MediaType.audio)
            
            let audioRecorder = try AVAudioRecorder(url: url, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.isMeteringEnabled = true
            audioRecorder.prepareToRecord()
            
            recorder = BeeAudioRecorderComposition(Recorder: audioRecorder, view: recorderView.recorderVisualizerView)
        
        } catch let error {
            displayAlert(title: "Audio Recording Error", message: "Recording failed. \n detail:\(error.localizedDescription)", actionTitle: "Ok")
        }
    }
    
    @objc func recordingButtonTapped(_ sender: Any) {
        if isRecording {
            isRecording = false
            recorder.stop()
            meterTimer.invalidate()
            // When recording is done init player
            preparePlayer()
            setView(isPlayerMode: true)
            recorderView.setRecordingButton(isRecording)
        } else {
            isRecording = true
            // Init recorder
            prepareRecorder()
            recorder.record()
            
            meterTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.updateAudioMeter(timer:)), userInfo: nil, repeats: true)
            recorderView.setRecordingButton(isRecording)
        }
    }
    
    // time label
    @objc func updateAudioMeter(timer: Timer) {
        if recorder.audioRecorder.isRecording {
            let hr = Int((recorder.audioRecorder.currentTime / 60) / 60)
            let min = Int(recorder.audioRecorder.currentTime / 60)
            let sec = Int(recorder.audioRecorder.currentTime.truncatingRemainder(dividingBy: 60))
            let totalTimeString = String(format: "%02d:%02d:%02d", hr, min, sec)
            recorderView.recordingTimeLabel.text = totalTimeString
            recorder.audioRecorder.updateMeters()
        }
    }

    // MARK: - Init audio player
    
    func preparePlayer() {
        do {
            if player != nil {
                player.stop()
                player = nil
            }
            let audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer.delegate = self
            audioPlayer.prepareToPlay()
            
            player = BeeAudioPlayerComposition(player: audioPlayer, view: playerView.playerVisualizerView!)
            playerView.setPlyerButton(isPlaying)
        } catch let error {
            displayAlert(title: "Audio Player Error",
                         message: "Recording failed. \n detail:\(error.localizedDescription)",
                         actionTitle: "Ok")
        }
    }

    @objc func playButtonTapped(_ sender: Any) {
        if isPlaying {
            isPlaying = false
            player.stop()
            playerView.setPlyerButton(isPlaying)
        } else {
            if FileManager.default.fileExists(atPath: url.path) {
                isPlaying = true
                player.play()
                playerView.setPlyerButton(isPlaying)
            } else {
                displayAlert(title: "Audio Play Error",
                             message: "Audio file is missing\ndetail: url =\(url.path)",
                             actionTitle: "Ok")
            }
        }
    }
    
    // MARK: - Button actions
    
    @objc func cancelButtonTapped(_ sender: Any) {
        DispatchQueue.main.async {
            if self.isRecording {
                self.recordingButtonTapped(sender)
            }
            if self.isPlaying {
                self.playButtonTapped(sender)
            }
            
            if self.recorder != nil {
                self.recorder.audioRecorder.deleteRecording()
            }
            self.handleDismiss()
        }
    }
    
    @objc func saveButtonTapped(_ sender: Any) {
        if isPlaying { player.stop() }
        
        recorder = nil
        player = nil
        
        // File name
        let fileName = url.lastPathComponent
        delegate?.audioPlayerSaveButtonTapped(filePath: fileName)
        handleDismiss()
    }
    
    @objc func deleteButtonTapped(_ sender: Any) {
        if isPlaying { playButtonTapped(sender) }
        // Delete audio file
        recorder.audioRecorder.deleteRecording()
        
        player = nil
        recorder = nil
        
        setView(isPlayerMode: false)
    }
    
    // MARK: - Delegate
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            deleteButtonTapped(recorder)
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        isPlaying = false
        playerView.setPlyerButton(isPlaying)
        playerView.playerVisualizerView?.slider.value = 0
    }
    
    // MARK: - Dismiss
    
    private func handleDismiss() {
        DispatchQueue.main.async {
            self.recorder = nil
            self.player = nil
            // self.recorderView = nil
            self.dismiss(animated: true, completion: nil)
        }
    }

    // MARK: - Helper Functions

    func displayAlert(title: String, message: String, actionTitle: String) {
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: actionTitle,
                                     style: .default,
                                     handler: {(alert: UIAlertAction!)
                                        in self.handleDismiss()})
        
        alertController.addAction(okAction)
        
        showDetailViewController(alertController, sender: nil)
    }
    
    func setView(isPlayerMode: Bool) {
        if isPlayerMode {
            playerView.playerVisualizerView?.slider.value = 0
            view.bringSubviewToFront(playerView)
        } else {
            recorderView.recordingTimeLabel.text = "00:00:00"
            view.bringSubviewToFront(recorderView)
        }
    }
    
    // MARK: - Error
    
    enum BeeRecorderError: Swift.Error {
        case invalidUrl
    }
}
