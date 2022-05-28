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
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "musicCell")
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "musicCell", for: indexPath)
        cell.textLabel?.text = "test"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = detailMusicViewController()
        self.navigationController?.pushViewController(detailVC, animated: true)
    }

}
