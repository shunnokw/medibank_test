//
//  ArticleCellViewModel.swift
//  newsApp
//
//  Created by Jason Wong on 18/1/2023.
//

import Foundation
import RxCocoa
import RxSwift

class ArticleCellViewModel: ViewModelType {
    struct Input {
        let clickOnCardSignal: Signal<Void>
    }
    
    struct Output {
        let titleTextDriver: Driver<NSAttributedString>
        let thumbnailUIImageDriver: Driver<UIImage?>
        let authorTextDriver: Driver<NSAttributedString>
        let otherSignal: Signal<Void>
    }
    
    private let article: Article
    private let navigator: HeadlinesSceneNavigator
    private let userDefaultManager: UserDefaultManagerType
    
    init(article: Article, navigator: HeadlinesSceneNavigator, userDefaultManager: UserDefaultManagerType) {
        self.article = article
        self.navigator = navigator
        self.userDefaultManager = userDefaultManager
    }
    
    func transform(input: Input) -> Output {
        // TODO: Maybe we can pass a "Image not found here
        let urlString = article.urlToImage ?? ""
        let imageUrl = URL(string: urlString)
        
        let thumbnailImageUrlDriver = downloadImage(url: imageUrl).asDriver(onErrorDriveWith: .empty())
        
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
        
        let otherSignal = input.clickOnCardSignal.do(onNext: {
            self.navigator.toWebViewScene(article: self.article, userDefaultManager: self.userDefaultManager)
        })
        
        return Output(
            titleTextDriver: titleTextDriver,
            thumbnailUIImageDriver: thumbnailImageUrlDriver,
            authorTextDriver: authorTextDriver,
            otherSignal: otherSignal
        )
    }
}

extension ArticleCellViewModel {
    // TODO: Image caching
    func downloadImage(url: URL?) -> Observable<UIImage?> {
        guard let url = url else { return Observable.of(nil) }
        return URLSession.shared.rx
            .data(request: URLRequest(url: url))
            .map { data in UIImage(data: data) }
            .catchAndReturn(nil)
    }
}
