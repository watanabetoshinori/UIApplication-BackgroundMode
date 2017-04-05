//
//  UIApplication+isBackgroundModeEnabled.swift
//  UIApplication-BackgroundMode
//
//  Created by Watanabe Toshinori on 4/5/17.
//  Copyright © 2017 Watanabe Toshinori. All rights reserved.
//

import UIKit
import AVFoundation

//
// # Setup
// Turn on background mode.
// - Project > Capabilities > Background Modes : ON
// - Audio, AirPlay, and Picture in Picture: Checked
//
// # Useage
// UIApplication.isBackgroundModeEnabled = true
//
// # Acknowledgments
// Cordova Background Plugin
// https://github.com/katzer/cordova-plugin-background-mode
//
// Technical Q&A QA1668 - Playing media while in the background using AV Foundation on iOS
// https://developer.apple.com/library/content/qa/qa1668/_index.html
//

extension UIApplication {

    var isBackgroundModeEnabled: Bool {
        set {
            BackgroundModeManager.shared.isEnabled = newValue
        }
        get {
            return BackgroundModeManager.shared.isEnabled
        }
    }

    class BackgroundModeManager {

        static let shared = BackgroundModeManager()

        var isEnabled = false

        private var silentAudioPlayer: AVAudioPlayer?

        private init() {
            do {
                // Configure audio session
                let session = AVAudioSession.sharedInstance()
                try session.setCategory(AVAudioSessionCategoryPlayback, with: [.mixWithOthers])
                try session.setActive(true)

                // Configure audio manager
                if let url = Bundle.main.url(forResource: "silent", withExtension: "mp3") {
                    silentAudioPlayer = try! AVAudioPlayer(contentsOf: url)
                    silentAudioPlayer?.volume = 0
                    silentAudioPlayer?.numberOfLoops = -1
                }

            } catch {
                fatalError()
            }

            NotificationCenter.default.addObserver(self, selector: #selector(BackgroundModeManager.playSilentAudio), name: .UIApplicationDidEnterBackground, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(BackgroundModeManager.stopSilentAudio), name: .UIApplicationWillEnterForeground, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(BackgroundModeManager.playSilentAudio), name: .AVAudioSessionInterruption, object: nil)
        }

        deinit {
            NotificationCenter.default.removeObserver(self, name: .UIApplicationDidEnterBackground, object: nil)
            NotificationCenter.default.removeObserver(self, name: .UIApplicationWillEnterForeground, object: nil)
            NotificationCenter.default.removeObserver(self, name: .AVAudioSessionInterruption, object: nil)
        }

        @objc private func playSilentAudio() {
            if isEnabled {
                silentAudioPlayer?.play()
            }
        }

        @objc private func stopSilentAudio() {
            silentAudioPlayer?.stop()
        }

    }

}
