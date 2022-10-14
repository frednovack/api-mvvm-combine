//
//  Article.swift
//  NewsAPI
//
//  Created by Frederico Novack on 10/14/22.
//

import Foundation

struct Article : Codable {
    var author: String?
    var urlToImage: String?
    var title: String?
    var description: String?
}

struct TopHeadlinesResponse : Codable {
    var status: String
    var totalResults: Int
    var articles: [Article]
}
