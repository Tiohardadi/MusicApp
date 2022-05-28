//
//  MusicTableViewController.swift
//  MusicApp
//
//  Created by Tio Hardadi Somantri on 5/28/22.
//

import UIKit

final class musicTableViewController: UITableViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Music App"
        tableView.register(MusicTableViewCell.self, forCellReuseIdentifier: "musicCell")
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "musicCell", for: indexPath) as? MusicTableViewCell else { return UITableViewCell() }
        cell.configure(image: UIImage(systemName: "music.note"), artist: "Rich Brian", musicTitle: "Kidz", duration: "04:02")
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = detailMusicViewController()
        self.navigationController?.pushViewController(detailVC, animated: true)
    }

}
