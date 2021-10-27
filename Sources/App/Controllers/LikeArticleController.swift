//
//  File.swift
//  
//
//  Created by Kao Li Chi on 2021/10/27.
//

import Foundation
import Fluent
import Vapor

struct LikeArticleController: RouteCollection{
    
    func boot(routes: RoutesBuilder) throws {
        
        let likeArticle = routes.grouped("likeArticle")
        likeArticle.group("my"){ li in
            li.get(":userID",use: GetMyLike)
        }
        likeArticle.post("new",use: postLike)
        likeArticle.group("delete"){ li in
            li.delete(":likeArticleID",use: deleteLike)
        }
    }
    
    
    //----------------------------我的喜愛文章--------------------------------//

    func GetMyLike(req: Request) throws -> EventLoopFuture<[LikeArticle]> {

        guard let userID = req.parameters.get("userID") as UUID? else{
            throw Abort(.badRequest)
        }
        
        return  LikeArticle.query(on: req.db)
            .with(\.$user)
            .filter(LikeArticle.self, \LikeArticle.$user.$id == userID )
            .sort(\.$updatedOn, .descending)
            .all()

    }
    
    

    //----------------------------post喜愛文章-------------------------------//
    func postLike(req: Request) throws -> EventLoopFuture<LikeArticle> {
        let todo = try req.content.decode(NewLikeArticle.self)
        
        return User.query(on: req.db)
            .filter(\.$id == todo.userID)
            .first()
            .unwrap(or: Abort(.notFound))
            .flatMap{ usr in
                Article.query(on: req.db)
                    .filter(\.$id == todo.articleID)
                    .first()
                    .unwrap(or: Abort(.notFound))
                    .flatMap{ arti in
                        let likeArticle = LikeArticle(user: usr, article: arti)
                        return likeArticle.create(on: req.db).map{ likeArticle }
                    }
            }
    }
    
    
    
   //-----------------------------delete喜愛文章-------------------------------//
   
   func deleteLike(req: Request) throws -> EventLoopFuture<HTTPStatus> {
       return LikeArticle.find(req.parameters.get("likeArticleID"), on: req.db)
           .unwrap(or: Abort(.notFound))
           .flatMap{ $0.delete(on: req.db) }
           .transform(to: .ok)
   }
    
    
   
}
