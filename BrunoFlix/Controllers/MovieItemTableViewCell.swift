//
//  MovieItemTableViewCell.swift
//  BrunoFlix
//
//  Created by Bruno Garcia on 05/11/18.
//  Copyright © 2018 Bruno Garcia. All rights reserved.
//

import UIKit

class MovieItemTableViewCell: UITableViewCell {

    @IBOutlet weak var ivCover: UIImageView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbGenre: UILabel!
    @IBOutlet weak var lbReleaseDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func prepare(with movie: Movie) {
        lbTitle.text = movie.title
        lbReleaseDate.text = movie.releaseDate?.formatted
        lbGenre.text = movie.strGenres
        
        if let photoData = movie.cover {
            ivCover.image = UIImage(data: photoData)
        }
    }
    

}
