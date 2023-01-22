//
//  MockNetworkService.swift
//  newsAppTests
//
//  Created by Jason Wong on 19/1/2023.
//

import Foundation
import RxSwift
@testable import newsApp

class MockNewsApiService: NewsApiServiceType {
    var stubHeadlineArticlesObservable: Observable<[Article]>!
    
    var stubSourceObservable: Observable<[Source]>!
    
    var stubImage: Observable<UIImage?>!
    
    func getHeadlines(sources: [Source]) -> Observable<[Article]> {
        return stubHeadlineArticlesObservable
    }
    
    func getSources() -> Observable<[Source]> {
        return stubSourceObservable
    }
    
    func downloadImage(url: URL?) -> Observable<UIImage?> {
        return stubImage
    }
}
