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
        let refreshControlSignal: Signal<ControlEvent<()>.Element>
    }
    
    struct Output {
        let isLoadingDriver: Driver<Bool>
        let dateSourceDriver: Driver<[Section]>
        let otherSignal: Signal<Void>
        let refreshSignal: Signal<Void>
    }
    
    private let navigator: HeadlinesSceneNavigator
    private let newsApiService: NewsApiServiceType
    private let userDefaultService: UserDefaultServiceType
    private let isLoading: ActivityIndicator
    private let articlesRelay: BehaviorRelay<[Article]>
    
    init(navigator: HeadlinesSceneNavigator, newsApiService: NewsApiServiceType, userDefaultService: UserDefaultServiceType) {
        self.navigator = navigator
        self.newsApiService = newsApiService
        self.userDefaultService = userDefaultService
        self.isLoading = ActivityIndicator()
        self.articlesRelay = BehaviorRelay(value: [])
    }
    
    func transform(input: Input) -> Output {
        let refreshSignal = input.refreshControlSignal
            .asObservable()
            .flatMap { return self.newsApiService.getHeadlines() }
            .map { self.articlesRelay.accept($0) }
            .asSignal(onErrorSignalWith: .empty())
        
        let articlesObservable = newsApiService.getHeadlines().trackActivity(isLoading).map {
            self.articlesRelay.accept($0)
        }
        
        let dataSourceDriver: Driver<[Section]> = articlesRelay.map {
            articles in
            let articleViewModels: [ArticleCellViewModel] = articles.map { ArticleCellViewModel(article: $0, navigator: self.navigator, userDefaultService: self.userDefaultService) }
            return [Section(header: "Articles", items: articleViewModels)]
        }
            .asDriver(onErrorDriveWith: .empty())
        
        let otherSignal = articlesObservable.asSignal(onErrorSignalWith: .empty())
        
        return Output(
            isLoadingDriver: isLoading.asDriver(),
            dateSourceDriver: dataSourceDriver,
            otherSignal: otherSignal,
            refreshSignal: refreshSignal
        )
    }
}



