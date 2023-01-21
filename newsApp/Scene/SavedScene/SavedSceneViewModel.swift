//
//  SavedSceneViewModel.swift
//  newsApp
//
//  Created by Jason Wong on 19/1/2023.
//

import Foundation
import RxSwift
import RxCocoa

final class SavedSceneViewModel: ViewModelType {
    typealias Section = MultipleSectionModel
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
            let articleViewModels: [SectionItem] = articles.map {
                .ArticleListSectionItem(viewModel: ArticleCellViewModel(article: $0, navigator: self.navigator, userDefaultService: self.userDefaultService))
            }
            return [
                .ArticleListSectionModel(items: articleViewModels)
            ]
        }
            .asDriver(onErrorDriveWith: .empty())
        
        let layoutDriver: Driver<UICollectionViewLayout> = Driver.just(
            UICollectionViewFlowLayout()
        ).map {
            $0.itemSize = CGSize(width: UIScreen.main.bounds.size.width * 0.95, height: 300)
            return $0
        }
        
        return Output(
            isLoadingDriver: .empty(), 
            dateSourceDriver: dataSourceDriver,
            otherSignal: articlesObservable.asSignal(onErrorSignalWith: .empty()),
            refreshSignal: refreshSignal,
            layoutDriver: layoutDriver
        )
    }
}
