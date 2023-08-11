//
//  CustomCollectionView.swift
//  band_instagram
//
//  Created by t2023-m0056 on 2023/08/08.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    var movieImg: UIImageView = {
        let movieImg = UIImageView()
        movieImg.backgroundColor = .blue
        movieImg.image = UIImage(systemName: "photo")
        movieImg.translatesAutoresizingMaskIntoConstraints = false
        movieImg.layer.cornerRadius = 10
        return movieImg
    }()
    
    var movieName: UILabel!
    var movieRate: UILabel!
    var moviePopular: UILabel!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpCell()
        setUpLabel()
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setUpCell()
        setUpLabel()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.movieImg.image = UIImage(systemName: "photo")
    }
    
    func setUpCell() {
        movieName = UILabel()
        movieRate = UILabel()
        moviePopular = UILabel()
        
        contentView.layer.cornerRadius = 10
        contentView.layer.borderWidth = 0.3
        contentView.addSubview(movieImg)
        contentView.addSubview(movieName)
        contentView.addSubview(movieRate)
        contentView.addSubview(moviePopular)
        
        movieImg.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 5).isActive = true
        movieImg.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 5).isActive = true
        movieImg.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -5).isActive = true
        movieImg.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        movieName.translatesAutoresizingMaskIntoConstraints = false
        movieName.topAnchor.constraint(equalTo: movieImg.bottomAnchor).isActive = true
        movieName.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 5).isActive = true
        movieName.bottomAnchor.constraint(equalTo: movieRate.topAnchor).isActive = true
        movieName.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -5).isActive = true
       
        movieRate.translatesAutoresizingMaskIntoConstraints = false
        movieRate.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 5).isActive = true
        movieRate.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -5).isActive = true
        
        moviePopular.translatesAutoresizingMaskIntoConstraints = false
        moviePopular.topAnchor.constraint(equalTo: movieRate.bottomAnchor).isActive = true
        moviePopular.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 5).isActive = true
        moviePopular.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -5).isActive = true
        moviePopular.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -5).isActive = true
    }
    
    func setUpLabel() {
        movieName.textAlignment = .center
        movieName.font = UIFont.boldSystemFont(ofSize: 18)
        
        movieRate.textAlignment = .center
        movieRate.font = UIFont.systemFont(ofSize: 14)
        movieRate.textColor = .gray
        
        moviePopular.textAlignment = .center
        moviePopular.font = UIFont.systemFont(ofSize: 12)
        moviePopular.textColor = .gray
    }
}
