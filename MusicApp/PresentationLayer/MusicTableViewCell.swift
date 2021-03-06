//
//  MusicTableViewCell.swift
//  MusicApp
//
//  Created by Adji Firmansyah on 5/28/22.
//

import UIKit

class MusicTableViewCell: UITableViewCell {
    private lazy var musicImage: UIImageView = {
        var musicImage = UIImageView()
        musicImage.backgroundColor = .gray
        musicImage.contentMode = .scaleAspectFit
        musicImage.clipsToBounds = true
        musicImage.layer.cornerRadius = 4
        
        return musicImage
    }()
    
    private lazy var musicArtist: UILabel = {
        var musicArtis = UILabel()
        musicArtis.font = .systemFont(ofSize: 24, weight: .bold)
        musicArtis.textColor = .black
        return musicArtis
    }()
    
    private lazy var musicTitle: UILabel = {
        var musicArtis = UILabel()
        musicArtis.font = .systemFont(ofSize: 16, weight: .regular)
        musicArtis.textColor = .lightGray
        return musicArtis
    }()
    
    private lazy var musicDuration: UILabel = {
        var musicArtis = UILabel()
        musicArtis.font = .systemFont(ofSize: 16, weight: .regular)
        musicArtis.textColor = .lightGray
        return musicArtis
    }()
    
    private lazy var bottomTitleStackView: UIStackView = {
       var bottomStackView = UIStackView(arrangedSubviews: [musicTitle, musicDuration])
        bottomStackView.axis = .horizontal
        bottomStackView.distribution = .equalSpacing
        return bottomStackView
    }()
    
    private lazy var titleStackView: UIStackView = {
       var titleSV = UIStackView(arrangedSubviews: [musicArtist, bottomTitleStackView])
        titleSV.axis = .vertical
        titleSV.spacing = 8
        return titleSV
    }()
    
    private lazy var musicStackView: UIStackView = {
       var stackView = UIStackView(arrangedSubviews: [musicImage, titleStackView])
        stackView.axis = .horizontal
        stackView.spacing = 8
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(musicStackView)
        setupConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(image: UIImage?, artist: String?, musicTitle: String?, duration: String?) {
        self.musicImage.image = image
        self.musicArtist.text = artist
        self.musicTitle.text = musicTitle
        self.musicDuration.text = duration
    }
    
    private func setupConstraint() {
        musicStackView.translatesAutoresizingMaskIntoConstraints = false
        
        musicStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        musicStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 24).isActive = true
        musicStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        musicStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -24).isActive = true
        
        musicImage.heightAnchor.constraint(equalToConstant: 64).isActive = true
        musicImage.widthAnchor.constraint(equalToConstant: 64).isActive = true
    }
}
