//
//  Movie.swift
//  Animated Movies Make Me Cry
//
//  Created by Gustavo F Oliveira on 5/31/16.
//  Copyright © 2016 Gustavo F Oliveira. All rights reserved.
//

import UIKit

class Movie {

    var name: String!
    var thumb: String!
    var video: String!
    var like: Int!
    
    init(name: String, thumb: String, video: String, like: Int) {
        self.name = name
        self.thumb = thumb
        self.video = video
        self.like = like
    }

}
