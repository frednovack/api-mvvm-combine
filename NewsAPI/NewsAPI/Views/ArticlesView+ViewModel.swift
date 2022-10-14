//
//  ArticlesView+ViewModel.swift
//  NewsAPI
//
//  Created by Frederico Novack on 10/14/22.
//

import Foundation
import Combine

class ArticlesViewModel {
    
    @Published var articles: [Article] = []
    var subscriptions: Set<AnyCancellable> = []
    
    func getBrazilianBusinessHeadlines() {
        Connector().getTopHeadlines(for: "br", category: "business") { [weak self] articles, err in
            guard let self = self else { return }
            if let err = err {
                print("🚨 Something wrong with the API Call. \(err.localizedDescription)")
                return
            }
            guard let articles = articles else {
                print("🚨 Could not retrieve articles!")
                return
            }
            self.articles.append(contentsOf: articles)
        }
    }
    
}
