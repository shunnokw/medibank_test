//
//  HeadlinesSceneViewModel.swift
//  newsApp
//
//  Created by Jason Wong on 18/1/2023.
//

import Foundation
import RxSwift
import RxCocoa

final class HeadlinesSceneViewModel: ViewModelType {
    typealias Section = HeadlineListSectionModel
    
    struct Input {
    }
    
    struct Output {
        let dateSourceDriver: Driver<[Section]>
    }
    
    let navigator: HeadlinesSceneNavigator
    let networkManager: NewsApiManagerType
    
    init(navigator: HeadlinesSceneNavigator, networkManager: NewsApiManagerType) {
        self.navigator = navigator
        self.networkManager = networkManager
    }
    
    func transform(input: Input) -> Output {
        
        let articlesObservable = networkManager.getHeadlines()
        
        let dataSourceDriver: Driver<[Section]> = articlesObservable.map {
            articles in
            let articleViewModels: [ArticleCellViewModel] = articles.map { ArticleCellViewModel(article: $0) }
            return [Section(items: articleViewModels)]
        }
            .asDriver(onErrorDriveWith: .empty())
        
        return Output(
            dateSourceDriver: dataSourceDriver
        )
    }
}



