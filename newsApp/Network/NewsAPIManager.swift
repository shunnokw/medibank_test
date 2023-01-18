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
        return Observable.create {
            (observer) -> Disposable in
            
            var urlComponents = URLComponents(string: self.baseUrl + "top-headlines")!
            urlComponents.queryItems = [
                URLQueryItem(name: "country", value: "au"),
                URLQueryItem(name: "apiKey", value: self.apiKey)
            ]
            
            var request = URLRequest(url: urlComponents.url!)
            request.httpMethod = "GET"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let session = URLSession.shared
            var articles: [Article] = []
            let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
                do {
                    let newsResponse = try JSONDecoder().decode(NewsResponse.self, from: data!) as NewsResponse
                    articles = newsResponse.articles
                    observer.onNext(articles)
                } catch {
                    print(error)
                }
            })
            
            task.resume()
            
            return Disposables.create()
        }
    }
    
//    func getSources() -> [Source] {
//        return Observable.create {
//            (observer) -> Disposable in
//
//            var urlComponents = URLComponents(string: self.baseUrl + "top-headlines")!
//            urlComponents.queryItems = [
//                URLQueryItem(name: "country", value: "au"),
//                URLQueryItem(name: "apiKey", value: self.apiKey)
//            ]
//
//            var request = URLRequest(url: urlComponents.url!)
//            request.httpMethod = "GET"
//            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//
//            let session = URLSession.shared
//            var articles: [Article] = []
//            let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
//                do {
//                    let newsResponse = try JSONDecoder().decode(NewsResponse.self, from: data!) as NewsResponse
//                    articles = newsResponse.articles
//                    observer.onNext(articles)
//                } catch {
//                    print(error)
//                }
//            })
//
//            task.resume()
//
//            return Disposables.create()
//        }
//    }
}
