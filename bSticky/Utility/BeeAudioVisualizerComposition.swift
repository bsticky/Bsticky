//
//  BeeAudioVisualizerComposition.swift
//  bSticky
//
//  Created by mima on 2021/03/01.
//  Copyright © 2021 FiftyPercent. All rights reserved.
//

import AVFoundation

// MARK: - Audio recorder composition

class BeeAudioRecorderComposition {
    // Source From: https://medium.com/@vialyx/ios-avfoundation-avaudioplayer-audio-power-visualizer-28669458c89
    
    //private var recorder: AVAudioRecorder
    var audioRecorder: AVAudioRecorder
    private weak var view: AudioRecorderVisualizerView!

    init(Recorder: AVAudioRecorder, view: AudioRecorderVisualizerView) {
        self.audioRecorder = Recorder
        self.view = view
        Recorder.isMeteringEnabled = true
        view.player = audioRecorder
    }

    // Start audio playing, view updates
    func record() {
        guard !audioRecorder.isRecording else {
            return
        }

        audioRecorder.record()
        view.start()
    }

    // Stop audio playing, stop view updates
    func stop() {
        guard audioRecorder.isRecording else {
            return }
        
        audioRecorder.stop()
        view.stop()
    }
}

// MARK: - Audio player composition

class BeeAudioPlayerComposition {
    // Source From: https://medium.com/@vialyx/ios-avfoundation-avaudioplayer-audio-power-visualizer-28669458c89
    
    var audioPlayer: AVAudioPlayer!
    private weak var view: AudioPlayerVisualizerView!

    init(player: AVAudioPlayer, view: AudioPlayerVisualizerView) {
        self.audioPlayer = player
        self.view = view
        
        player.isMeteringEnabled = true
        view.player = player
    }
    
    deinit {
        self.view = nil
    }

    // Start audio playing, view updates
    func play() {
        guard !audioPlayer.isPlaying else {
            return
        }

        audioPlayer.play()
        view.start()
    }

    // Pause audio playing, stop view updates
    func pause() {
        guard audioPlayer.isPlaying else {
            return
        }

        audioPlayer.pause()
        view.stop()
    }

    // Stop audio playing, stop view updates
    func stop() {
        guard audioPlayer.isPlaying else {
            return
        }

        view.stop()
        audioPlayer.stop()
    }
}


