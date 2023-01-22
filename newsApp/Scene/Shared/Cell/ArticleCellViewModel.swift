//
//  ArticleCellViewModel.swift
//  newsApp
//
//  Created by Jason Wong on 18/1/2023.
//

import Foundation
import RxCocoa
import RxSwift

final class ArticleCellViewModel: ViewModelType {
    typealias NavigationEvent = HeadlinesSceneNavigator.Event
    
    struct Input {
        let clickOnCardSignal: Signal<Void>
    }
    
    struct Output {
        let titleTextDriver: Driver<NSAttributedString>
        let thumbnailUIImageDriver: Driver<UIImage?>
        let authorTextDriver: Driver<NSAttributedString>
        let otherSignal: Signal<NavigationEvent>
    }
    
    private let article: Article
    private let navigator: HeadlinesSceneNavigatorType
    private let userDefaultService: UserDefaultServiceType
    private let newsApiService: NewsApiServiceType
    
    init(
        article: Article,
        navigator: HeadlinesSceneNavigator,
        userDefaultService: UserDefaultServiceType,
        newsApiService: NewsApiServiceType
    ) {
        self.article = article
        self.navigator = navigator
        self.userDefaultService = userDefaultService
        self.newsApiService = newsApiService
    }
    
    func transform(input: Input) -> Output {
        // TODO: Maybe we can pass a "Image not found here
        let urlString = article.urlToImage ?? ""
        let imageUrl = URL(string: urlString)
        
        let thumbnailImageUrlDriver = newsApiService.downloadImage(url: imageUrl).asDriver(onErrorDriveWith: .empty())
        
        let titleTextDriver: Driver<NSAttributedString> = Driver.of(article.title ?? "").map {
            let font = UIFont.systemFont(ofSize: 14)
            let attributes = [NSAttributedString.Key.font: font]
            return NSAttributedString(string: $0, attributes: attributes)
        }
        
        let authorTextDriver = Driver.of(article.author ?? "").map {
            let font = UIFont.systemFont(ofSize: 10)
            let attributes = [NSAttributedString.Key.font: font]
            return NSAttributedString(string: $0, attributes: attributes)
        }
        
        let otherSignal: Signal<NavigationEvent> = input.clickOnCardSignal.map { [self] in
            let event: NavigationEvent = .toWebViewScene(article: article, userDefaultServiceType: userDefaultService)
            self.navigator.eventOccurred(with: event)
            return event
        }
        
        return Output(
            titleTextDriver: titleTextDriver,
            thumbnailUIImageDriver: thumbnailImageUrlDriver,
            authorTextDriver: authorTextDriver,
            otherSignal: otherSignal
        )
    }
}
