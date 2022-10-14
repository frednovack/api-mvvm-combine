//
//  Connector.swift
//  NewsAPI
//
//  Created by Frederico Novack on 10/14/22.
//

import Foundation


class Connector {
    private let hostURL = "https://newsapi.org"
    private let topHeadlinesEndpoint = "/v2/top-headlines"
    private let apiKey = ""
    private let genericError = NSError(domain: "Failed to make request due to internal issues", code: -1)
    
    func getTopHeadlines(for countryCode: String, category: String, completion: @escaping ([Article]?, Error?) -> Void) {
        guard let url = URL(string: "\(hostURL)\(topHeadlinesEndpoint)?country=\(countryCode)&category=\(category)&apiKey=\(apiKey)") else {
            let error = NSError(domain: "Failed to generate URL", code: -1)
            completion(nil, error)
            return
        }
        let urlSession = URLSession(configuration: .default)
        let request = URLRequest(url: url)
        let task = urlSession.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(nil, error)
                return
            }
            guard let httpResponse = (response as? HTTPURLResponse) else {
                completion(nil, self.genericError)
                return
            }
            if httpResponse.statusCode == 200 {
                guard let responseTransformed = self.transformData(data) else {
                    let error = NSError(domain: "Failed to parse data", code: -1)
                    completion(nil, error)
                    return
                }
                completion(responseTransformed.articles, nil)
            } else {
                let statusError = NSError(domain: "Server Error", code: httpResponse.statusCode)
                completion(nil, statusError)
            }
        }
        
        task.resume()
    }
    
    private func transformData(_ data: Data?) -> TopHeadlinesResponse? {
        guard let data = data else { return nil }
        guard let transformedResponse = try? JSONDecoder().decode(TopHeadlinesResponse.self, from: data) else { return nil }
        return transformedResponse
    }
}
