//
//  LoadingAnimatedMovieCell.swift
//  Animated Movies Make Me Cry
//
//  Created by Gustavo F Oliveira on 6/1/16.
//  Copyright © 2016 Gustavo F Oliveira. All rights reserved.
//

import UIKit

class LoadingAnimatedMovieCell: UITableViewCell {

    @IBOutlet weak var imageShimmering: FBShimmeringView!
    @IBOutlet weak var movieImage: UIView!
    
    @IBOutlet weak var loveShimmering: FBShimmeringView!
    @IBOutlet weak var love: UIView!
    
    @IBOutlet weak var commentShimmering: FBShimmeringView!
    @IBOutlet weak var comment: UIView!
    
    @IBOutlet weak var labelShimmering: FBShimmeringView!
    @IBOutlet weak var label: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.imageShimmering.contentView = movieImage
        self.imageShimmering.shimmering = true
        
        self.loveShimmering.contentView = love
        self.loveShimmering.shimmering = true
        
        self.commentShimmering.contentView = comment
        self.commentShimmering.shimmering = true
        
        self.labelShimmering.contentView = label
        self.labelShimmering.shimmering = true
        
    }

}
