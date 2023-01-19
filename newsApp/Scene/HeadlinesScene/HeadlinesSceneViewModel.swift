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
//        let refreshIndicator: Binder<UIRefreshControl?>
    }
    
    struct Output {
        let isLoadingDriver: Driver<Bool>
        let dateSourceDriver: Driver<[Section]>
    }
    
    private let navigator: HeadlinesSceneNavigator
    private let newsApiService: NewsApiServiceType
    private let userDefaultService: UserDefaultServiceType
    private let isLoading: ActivityIndicator

    init(navigator: HeadlinesSceneNavigator, newsApiService: NewsApiServiceType, userDefaultService: UserDefaultServiceType) {
        self.navigator = navigator
        self.newsApiService = newsApiService
        self.userDefaultService = userDefaultService
        self.isLoading = ActivityIndicator()
    }
    
    func transform(input: Input) -> Output {
        let articlesObservable = newsApiService.getHeadlines().trackActivity(isLoading)
        
        let dataSourceDriver: Driver<[Section]> = articlesObservable.map {
            articles in
            let articleViewModels: [ArticleCellViewModel] = articles.map { ArticleCellViewModel(article: $0, navigator: self.navigator, userDefaultService: self.userDefaultService) }
            return [Section(header: "Articles", items: articleViewModels)]
        }
            .asDriver(onErrorDriveWith: .empty())
        
        return Output(
            isLoadingDriver: isLoading.asDriver(),
            dateSourceDriver: dataSourceDriver
        )
    }
}



