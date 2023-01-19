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

    func getHeadlines() -> Observable<[Article]> {
        return stubHeadlineArticlesObservable
    }
    
    func getSources() -> RxSwift.Observable<[newsApp.Source]> {
        return stubSourceObservable
    }
}
