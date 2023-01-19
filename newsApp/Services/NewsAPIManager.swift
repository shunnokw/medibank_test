//
//  NewsAPIManager.swift
//  newsApp
//
//  Created by Jason Wong on 18/1/2023.
//

import Foundation
import RxSwift

protocol NewsApiManagerType {
    func getHeadlines() -> Observable<[Article]>
    func getSources() -> Observable<[Source]>
}

class NewsAPIManger: NewsApiManagerType {
    private let apiKey: String
    private let baseUrl = "https://newsapi.org/v2/"
    
    init() {
        guard let filePath = Bundle.main.path(forResource: "key", ofType: "plist"),
              let plist = NSDictionary(contentsOfFile: filePath) else {
            fatalError("key file not found")
        }
        apiKey = plist.value(forKey: "apiKey") as? String ?? ""
    }
    
    func getHeadlines() -> Observable<[Article]> {
        var urlComponents = URLComponents(string: self.baseUrl + "top-headlines")!
        urlComponents.queryItems = [
            URLQueryItem(name: "country", value: "au"),
            URLQueryItem(name: "apiKey", value: self.apiKey)
        ]
        
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return URLSession.shared.rx
            .data(request: request)
            .map { data in try JSONDecoder().decode(NewsResponse.self, from: data).articles! }
            .catchAndReturn([])
    }
    
    func getSources() -> Observable<[Source]> {
        var urlComponents = URLComponents(string: self.baseUrl + "top-headlines/sources")!
        urlComponents.queryItems = [
            URLQueryItem(name: "language", value: "en"),
            URLQueryItem(name: "apiKey", value: self.apiKey)
        ]

        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return URLSession.shared.rx
            .data(request: request)
            .map { data in try JSONDecoder().decode(NewsResponse.self, from: data).sources! }
            .catchAndReturn([])
    }
}
