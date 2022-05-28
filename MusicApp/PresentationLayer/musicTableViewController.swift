//
//  MusicTableViewController.swift
//  MusicApp
//
//  Created by Tio Hardadi Somantri on 5/28/22.
//

import UIKit
import AVFoundation

final class musicTableViewController: UITableViewController{
    
    var listMusic = musicList.getList()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Music App"
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.register(MusicTableViewCell.self, forCellReuseIdentifier: "musicCell")
        configure()
        
    }
    
    
    private func configure() {
        //        tableView.rowHeight = 80
        //        tableView.estimatedRowHeight = UITableView.automaticDimension
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listMusic.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "musicCell", for: indexPath) as? MusicTableViewCell else { return UITableViewCell() }
        
        
        let row = indexPath.row
        let data = listMusic[row]
        let artist = data.components(separatedBy: "-")
        
        let _fileUrl: URL? = Bundle.main.url(forResource: data, withExtension: "mp3")
        guard let fileUrl = _fileUrl else { return UITableViewCell() }
        let asset = AVURLAsset(url: fileUrl)
        let duration = asset.duration
        let durationTime = CMTimeGetSeconds(duration)
        cell.configure(image: UIImage(systemName: "music.note"), artist: artist.first, musicTitle: artist.last, duration: stringFromTimeInterval(interval: durationTime))
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = detailMusicViewController()
        detailVC.playedMusicIndex = indexPath.row
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func stringFromTimeInterval(interval: TimeInterval) -> String {
        
        let interval = Int(interval)
        let seconds = interval % 60
        let minutes = (interval / 60) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
}
