//
//  DetailMusicViewController.swift
//  MusicApp
//
//  Created by Tio Hardadi Somantri on 5/28/22.
//

import AVFoundation
import MediaPlayer
import UIKit


class detailMusicViewController: UIViewController{
    private(set) var player: AVAudioPlayer?
    
    var playedMusicTitles: [String] = ["Rich Brian - Kids (Official Video) (128 kbps)"]
    private(set) var playedMusicIndex: Int = 0
    var playedMusicTitle: String {
        let res: String = playedMusicTitles[playedMusicIndex]
        return res
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        UIApplication.shared.beginReceivingRemoteControlEvents()
        setupAudioBackground()
        setupRemoteCommandCenter()
        playMusic()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.endReceivingRemoteControlEvents()
    }
    
    private func playMusic() {
        let fileUrl: URL? = Bundle.main.url(forResource: playedMusicTitle, withExtension: "mp3")

        print(fileUrl)
        guard let _fileUrl = fileUrl else { return }
        
        do {
            player = try AVAudioPlayer(contentsOf: _fileUrl)
            player?.prepareToPlay()
            player?.play()
        } catch {
            print(String(describing: error))
        }
    }
    
    private func setupAudioBackground() {
        do {
            try AVAudioSession.sharedInstance().setCategory(
                .playback,
                mode: .default,
                options: []
            )
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print(String(describing: error))
        }
    }
    
    private func setupRemoteCommandCenter() {
        let musicInfo: [String: Any] = [MPMediaItemPropertyTitle: playedMusicTitle]
        MPNowPlayingInfoCenter.default().nowPlayingInfo = musicInfo
        let commandCenter = MPRemoteCommandCenter.shared()
        commandCenter.playCommand.isEnabled = true
        commandCenter.playCommand.addTarget { [weak self] (event) -> MPRemoteCommandHandlerStatus in
            guard let _self = self else { return .success }
            _self.player?.play()
            print("Play Music")
            return .success
        }
        
        commandCenter.pauseCommand.isEnabled = true
        commandCenter.pauseCommand.addTarget { [weak self] (event) -> MPRemoteCommandHandlerStatus in
            guard let _self = self else { return .success }
            _self.player?.pause()
            print("Pause Music")
            return .success
        }
        
        commandCenter.stopCommand.isEnabled = true
        commandCenter.stopCommand.addTarget { [weak self] event -> MPRemoteCommandHandlerStatus in
            guard let _self = self else { return .success }
            _self.player?.stop()
            print("Stop Music")
            return .success
        }
    }
}
