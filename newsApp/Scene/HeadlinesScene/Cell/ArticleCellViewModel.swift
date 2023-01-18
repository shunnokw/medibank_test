//
//  ArticleCellViewModel.swift
//  newsApp
//
//  Created by Jason Wong on 18/1/2023.
//

import Foundation
import RxCocoa

class ArticleCellViewModel: ViewModelType {
    
    struct Input {
    }
    
    struct Output {
        let titleTextDriver: Driver<String>
    }
    
    let article: Article
    
    init(article: Article) {
        self.article = article
    }
    
    func transform(input: Input) -> Output {
        return Output(
            titleTextDriver: .just(article.title ?? "")
        )
    }
}
