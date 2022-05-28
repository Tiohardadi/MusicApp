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
    var isPlayed: Bool = true
    var timer: Timer?
    let playedMusicTitles: [String] =
    ["y2meta.com - Rich Brian ft. RZA - Rapapapa (Lyric Video) (128 kbps)",
     "y2meta.com - Rich Brian - Kids (Official Video) (128 kbps)"]
    var playedMusicIndex: Int = 0
    var playedMusicTitle: String {
        let res: String = playedMusicTitles[playedMusicIndex]
        return res
    }

    
    private lazy var frameInfoView: UIView = {
        let view = UIView()
//        view.backgroundColor = .brown
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var musicImage : UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        imgView.layer.cornerRadius = 20
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()
    
    private lazy var titleLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.boldSystemFont(ofSize: 20)
        lbl.textAlignment = .left
        lbl.numberOfLines = 2
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    
    lazy var playButton: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 40, weight: .bold, scale: .large)
        let symbol = UIImage(systemName: "play.circle.fill", withConfiguration: config)
        button.setImage(symbol, for: .normal)
        button.addTarget(self, action: #selector(playAction), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var prevButton: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 25, weight: .bold, scale: .large)
        let symbol = UIImage(systemName: "backward.end", withConfiguration: config)
        button.setImage(symbol, for: .normal)
        button.tintColor = .systemGray
        button.addTarget(self, action: #selector(prevAction), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var nextButton: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 25, weight: .bold, scale: .large)
        let symbol = UIImage(systemName: "forward.end", withConfiguration: config)
        button.setImage(symbol, for: .normal)
        button.tintColor = .systemGray
        button.addTarget(self, action: #selector(nextAction), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var frameControllerView: UIStackView = {
        var view = UIStackView(arrangedSubviews: [
            prevButton,
            playButton,
            nextButton,
        ])
        view.axis = .horizontal
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var slider: UISlider = {
        let progress = UISlider()
        progress.minimumValue = 0.0
        progress.maximumValue = 100.0
        progress.tintColor = .systemBlue
        progress.translatesAutoresizingMaskIntoConstraints = false
        progress.addTarget(self, action: #selector(onDrag(slider:event:)), for: .valueChanged)
        return progress
    }()

    func imageWith(name: String?) -> UIImage? {
         let frame = CGRect(x: 0, y: 0, width: 100, height: 100)
         let nameLabel = UILabel(frame: frame)
         nameLabel.textAlignment = .center
         nameLabel.backgroundColor = .black
         nameLabel.textColor = .white
         nameLabel.font = UIFont.boldSystemFont(ofSize: 10)
         nameLabel.text = name
         UIGraphicsBeginImageContext(frame.size)
          if let currentContext = UIGraphicsGetCurrentContext() {
             nameLabel.layer.render(in: currentContext)
             let nameImage = UIGraphicsGetImageFromCurrentImageContext()
             return nameImage
          }
          return UIImage()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        UIApplication.shared.beginReceivingRemoteControlEvents()
        setupAudioBackground()
        setupRemoteCommandCenter()
        setupLayout()
        playMusic()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.endReceivingRemoteControlEvents()
    }
    
    private func playMusic() {
        stopMusic()
        let fileUrl: URL? = Bundle.main.url(forResource: playedMusicTitle, withExtension: "mp3")
        guard let _fileUrl = fileUrl else { return }
        
        do {
            player = try AVAudioPlayer(contentsOf: _fileUrl)
            player?.prepareToPlay()
            player?.play()
            isPlayed = true
            slider.maximumValue = Float((player?.duration)!)
            timer = Timer.scheduledTimer(timeInterval: 0.0001, target: self, selector: #selector(updateSlider), userInfo: nil, repeats: true)
            musicImage.image = imageWith(name: playedMusicTitle)
            titleLabel.text = playedMusicTitle
            let config = UIImage.SymbolConfiguration(pointSize: 40, weight: .bold, scale: .large)
            let symbol = UIImage(systemName: "stop.circle.fill", withConfiguration: config)
            playButton.setImage(symbol, for: .normal)
            
        } catch {
            print(String(describing: error))
        }
    }
    
    @objc func onDrag(slider: UISlider, event: UIEvent) {
        if let touchEvent = event.allTouches?.first {
            switch touchEvent.phase {
            case .began:
                timer?.invalidate()
            case .ended:
                player?.currentTime = TimeInterval(slider.value)
                timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateSlider), userInfo: nil, repeats: true)
            default:
                break
            }
        }
    }
    
    @objc func updateSlider(){
        slider.value = Float(player?.currentTime ?? 0.0)
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
    
    private func stopMusic(){
        player?.stop()
        isPlayed = false
        timer?.invalidate()
        let config = UIImage.SymbolConfiguration(pointSize: 40, weight: .bold, scale: .large)
        let symbol = UIImage(systemName: "play.circle.fill", withConfiguration: config)
        playButton.setImage(symbol, for: .normal)
    }
    
    @objc func playAction(){
        if !isPlayed{
            playMusic()
        }else{
            stopMusic()
        }
        
    }
    
    @objc func prevAction(){
        if playedMusicIndex == 0 {
            playedMusicIndex = (playedMusicTitles.count - 1)
            playMusic()
        }else{
            playedMusicIndex -= 1
            playMusic()
        }
        
    }
    
    @objc func nextAction(){
        print(playedMusicTitles.count - 1,"max")
        if playedMusicIndex == (playedMusicTitles.count - 1){
            playedMusicIndex = 0
            playMusic()
        }else{
            playedMusicIndex = +1
            playMusic()
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
    
    private func setupLayout() {
        view.addSubview(frameInfoView)
        frameInfoView.addSubview(musicImage)
        frameInfoView.addSubview(titleLabel)
        view.addSubview(frameControllerView)
        view.addSubview(slider)
        
        NSLayoutConstraint.activate([
            //framView Constraint
            frameInfoView.topAnchor.constraint(equalTo: view.topAnchor, constant: 150),
            frameInfoView.heightAnchor.constraint(equalToConstant: 350),
            frameInfoView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            frameInfoView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            
            //musicImage Constraint
            musicImage.leadingAnchor.constraint(equalTo: frameInfoView.leadingAnchor),
            musicImage.trailingAnchor.constraint(equalTo: frameInfoView.trailingAnchor),
            musicImage.topAnchor.constraint(equalTo: frameInfoView.topAnchor),
            musicImage.bottomAnchor.constraint(equalTo: frameInfoView.bottomAnchor, constant: -50),

            //titleLabel
            titleLabel.topAnchor.constraint(equalTo: musicImage.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: frameInfoView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: frameInfoView.trailingAnchor, constant: -20),
            
            frameControllerView.topAnchor.constraint(equalTo: frameInfoView.bottomAnchor, constant: 50),
            frameControllerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            frameControllerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            frameControllerView.heightAnchor.constraint(equalToConstant: 100),

            slider.topAnchor.constraint(equalTo: frameControllerView.bottomAnchor, constant: 20),
            slider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            slider.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            slider.heightAnchor.constraint(equalToConstant: 100),
        ])
    }
    
}
