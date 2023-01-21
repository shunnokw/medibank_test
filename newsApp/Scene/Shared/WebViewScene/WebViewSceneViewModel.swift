//
//  WebViewSceneViewModel.swift
//  newsApp
//
//  Created by Jason Wong on 19/1/2023.
//

import Foundation
import RxCocoa
import RxSwift

final class WebViewSceneViewModel: ViewModelType {
    struct Input {
        let bookmarkBtnTapEvent: Signal<Void>
    }
    
    struct Output {
        let urlDriver: Driver<URL?>
        let isBookmarkedDriver: Driver<Bool>
        let otherSignal: Signal<Void>
    }
    
    let title: String?
    private let article: Article
    private let isBookmarkRelay: BehaviorRelay<Bool>
    private let userDefaultService: UserDefaultServiceType
    
    init(article: Article, userDefaultService: UserDefaultServiceType) {
        self.article = article
        self.title = article.title
        self.userDefaultService = userDefaultService
        self.isBookmarkRelay = .init(value: userDefaultService.checkIsBookmarked(article: article))
    }
    
    func transform(input: Input) -> Output {
        
        let urlDriver: Driver<URL?> = Driver.of(article.url).map {
            urlString in
            guard let urlString = urlString,
                  let url = URL(string: urlString)
            else { return nil }
            return url
        }
        
        let otherSignal = input.bookmarkBtnTapEvent.map {
            _ in
            if self.isBookmarkRelay.value {
                self.userDefaultService.removeBookmark(article: self.article)
            } else {
                self.userDefaultService.addBookmark(article: self.article)
            }
            self.isBookmarkRelay.accept(self.userDefaultService.checkIsBookmarked(article: self.article))
        }
        
        return Output(
            urlDriver: urlDriver,
            isBookmarkedDriver: isBookmarkRelay.asDriver(),
            otherSignal: otherSignal
        )
    }
}
