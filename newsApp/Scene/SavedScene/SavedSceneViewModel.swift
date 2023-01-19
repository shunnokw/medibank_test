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

    init(navigator: HeadlinesSceneNavigator, userDefaultService: UserDefaultServiceType) {
        self.navigator = navigator
        self.userDefaultService = userDefaultService
    }
    
    func transform(input: Input) -> Output {
        let articlesObservable = Observable.just(userDefaultService.getBookmarks())
        
        let dataSourceDriver: Driver<[Section]> = articlesObservable.map {
            articles in
            let articleViewModels: [ArticleCellViewModel] = articles.map { ArticleCellViewModel(article: $0, navigator: self.navigator, userDefaultService: self.userDefaultService) }
            return [Section(header: "Articles", items: articleViewModels)]
        }
            .asDriver(onErrorDriveWith: .empty())
        
        return Output(
            isLoadingDriver: .empty(), 
            dateSourceDriver: dataSourceDriver
        )
    }
}
