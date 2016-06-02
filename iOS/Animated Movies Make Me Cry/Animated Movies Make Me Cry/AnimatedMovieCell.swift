//
//  AnimatedMovieCell.swift
//  Animated Movies Make Me Cry
//
//  Created by Gustavo F Oliveira on 6/1/16.
//  Copyright © 2016 Gustavo F Oliveira. All rights reserved.
//

import UIKit

class AnimatedMovieCell: UITableViewCell {

    @IBOutlet weak var movieName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
