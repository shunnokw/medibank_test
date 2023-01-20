//
//  SavedSceneViewModel.swift
//  newsApp
//
//  Created by Jason Wong on 19/1/2023.
//

import Foundation
import RxSwift
import RxCocoa

class SavedSceneViewModel: ViewModelType {
    typealias Section = HeadlineListSectionModel
    typealias Input = HeadlinesSceneViewModel.Input
    typealias Output = HeadlinesSceneViewModel.Output
    
    private let userDefaultService: UserDefaultServiceType
    private let navigator: HeadlinesSceneNavigator
    private let isLoading: ActivityIndicator
    private let articlesRelay: BehaviorRelay<[Article]>

    init(navigator: HeadlinesSceneNavigator, userDefaultService: UserDefaultServiceType) {
        self.navigator = navigator
        self.userDefaultService = userDefaultService
        self.isLoading = ActivityIndicator()
        self.articlesRelay = BehaviorRelay(value: [])
    }
    
    func transform(input: Input) -> Output {
        let articlesObservable = Observable.just(userDefaultService.getBookmarks()).map {
            self.articlesRelay.accept($0)
        }
        
        let refreshSignal = input.refreshControlSignal
            .map { [self] in
                articlesRelay.accept(userDefaultService.getBookmarks())
            }
            .asSignal(onErrorSignalWith: .empty())
        
        let dataSourceDriver: Driver<[Section]> = articlesRelay.map {
            articles in
            let articleViewModels: [ArticleCellViewModel] = articles.map { ArticleCellViewModel(article: $0, navigator: self.navigator, userDefaultService: self.userDefaultService) }
            return [Section(header: "Articles", items: articleViewModels)]
        }
            .asDriver(onErrorDriveWith: .empty())
        
        return Output(
            isLoadingDriver: .empty(), 
            dateSourceDriver: dataSourceDriver,
            otherSignal: articlesObservable.asSignal(onErrorSignalWith: .empty()),
            refreshSignal: refreshSignal
        )
    }
}
