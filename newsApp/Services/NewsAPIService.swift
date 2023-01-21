//
//  NewsAPIService.swift
//  newsApp
//
//  Created by Jason Wong on 18/1/2023.
//

import Foundation
import RxSwift

protocol NewsApiServiceType {
    func getHeadlines(sources: [Source]) -> Observable<[Article]>
    func getSources() -> Observable<[Source]>
}

class NewsAPIService: NewsApiServiceType {
    private let apiKey: String
    private let baseUrl = "https://newsapi.org/v2/"
    
    init() {
        guard let filePath = Bundle.main.path(forResource: "key", ofType: "plist"),
              let plist = NSDictionary(contentsOfFile: filePath) else {
            fatalError("key file not found")
        }
        apiKey = plist.value(forKey: "apiKey") as? String ?? ""
    }
    
    func getHeadlines(sources: [Source]) -> Observable<[Article]> {
        let sourceNames = sources.filter { $0.id?.isEmpty == false }.map { $0.id ?? "" }
        var urlComponents = URLComponents(string: self.baseUrl + "top-headlines")!
        var queryItems = [URLQueryItem(name: "apiKey", value: self.apiKey)]
        if (sources.count > 0) {
            queryItems.append(URLQueryItem(name: "sources", value: sourceNames.joined(separator: ",")))
        } else {
            queryItems.append(URLQueryItem(name: "country", value: "au"))
        }
        urlComponents.queryItems = queryItems
        
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
