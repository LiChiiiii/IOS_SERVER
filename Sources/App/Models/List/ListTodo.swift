//
//  File.swift
//  
//
//  Created by Kao Li Chi on 2021/9/24.
//

import Foundation
import Fluent
import Vapor

//--------------------------------新增電影評價（POST)----------------------------------------//
struct NewListMovie: Content{
    var listTitle : String
    var UserName : String
    var movieID : Int
    var movietitle : String
    var posterPath : String
    var feeling : String
    var ratetext : Int

}

//--------------------------------編輯電影評價（PUT)----------------------------------------//
struct UpdateListMovie: Encodable{       //取片單
    var ListDetailID : UUID
    var feeling : String
    var ratetext : Int
}