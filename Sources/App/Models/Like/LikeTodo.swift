//
//  File.swift
//  
//
//  Created by Kao Li Chi on 2021/10/27.
//

import Foundation
import Fluent
import Vapor


struct NewLikeArticle: Content{
    var userID : UUID
    var articleID : UUID
}

struct NewLikeMovie: Content{   
    var userID : UUID
    var movie : Int
    var title : String
    var posterPath : String
}
