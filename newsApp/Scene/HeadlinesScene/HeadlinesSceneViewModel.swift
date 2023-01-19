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
    private let networkManager: NewsApiManagerType
    private let userDefaultManager: UserDefaultManagerType
    private let isLoading: ActivityIndicator

    init(navigator: HeadlinesSceneNavigator, networkManager: NewsApiManagerType, userDefaultManager: UserDefaultManagerType) {
        self.navigator = navigator
        self.networkManager = networkManager
        self.userDefaultManager = userDefaultManager
        self.isLoading = ActivityIndicator()
    }
    
    func transform(input: Input) -> Output {
        let articlesObservable = networkManager.getHeadlines().trackActivity(isLoading)
        
        let dataSourceDriver: Driver<[Section]> = articlesObservable.map {
            articles in
            let articleViewModels: [ArticleCellViewModel] = articles.map { ArticleCellViewModel(article: $0, navigator: self.navigator, userDefaultManager: self.userDefaultManager) }
            return [Section(header: "Articles", items: articleViewModels)]
        }
            .asDriver(onErrorDriveWith: .empty())
        
        return Output(
            isLoadingDriver: isLoading.asDriver(),
            dateSourceDriver: dataSourceDriver
        )
    }
}



