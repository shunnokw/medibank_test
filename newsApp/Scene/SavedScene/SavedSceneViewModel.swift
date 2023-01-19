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
    
    private let userDefaultManager: UserDefaultManagerType
    private let navigator: HeadlinesSceneNavigator

    init(navigator: HeadlinesSceneNavigator, userDefaultManager: UserDefaultManagerType) {
        self.navigator = navigator
        self.userDefaultManager = userDefaultManager
    }
    
    func transform(input: Input) -> Output {
        let articlesObservable = Observable.just(userDefaultManager.getBookmarks())
        
        let dataSourceDriver: Driver<[Section]> = articlesObservable.map {
            articles in
            let articleViewModels: [ArticleCellViewModel] = articles.map { ArticleCellViewModel(article: $0, navigator: self.navigator, userDefaultManager: self.userDefaultManager) }
            return [Section(header: "Articles", items: articleViewModels)]
        }
            .asDriver(onErrorDriveWith: .empty())
        
        return Output(
            isLoadingDriver: .empty(), 
            dateSourceDriver: dataSourceDriver
        )
    }
}
