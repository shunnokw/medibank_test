//
//  HeadlinesSceneViewModel.swift
//  newsApp
//
//  Created by Jason Wong on 18/1/2023.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit

final class HeadlinesSceneViewModel: ViewModelType {
    typealias Section = MultipleSectionModel
    
    struct Input {
        let refreshControlSignal: Signal<ControlEvent<()>.Element>
    }
    
    struct Output {
        let isLoadingDriver: Driver<Bool>
        let dateSourceDriver: Driver<[Section]>
        let otherSignal: Signal<Void>
        let refreshSignal: Signal<Void>
        let layoutDriver: Driver<UICollectionViewLayout>
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
            .flatMapLatest { [self] in return newsApiService.getHeadlines(sources: userDefaultService.getSelectedSources()) }
            .map { self.articlesRelay.accept($0) }
            .asSignal(onErrorSignalWith: .empty())
        
        let articlesObservable = newsApiService.getHeadlines(sources: self.userDefaultService.getSelectedSources()).trackActivity(isLoading).map {
            self.articlesRelay.accept($0)
        }
        
        let dataSourceDriver: Driver<[Section]> = articlesRelay.map { [self]
            articles in
            let articleViewModels: [SectionItem] = articles.map {
                .ArticleListSectionItem(viewModel: ArticleCellViewModel(
                    article: $0,
                    navigator: navigator,
                    userDefaultService: userDefaultService,
                    newsApiService: newsApiService
                ))
            }
            return [.ArticleListSectionModel(items: articleViewModels)]
        }
            .asDriver(onErrorDriveWith: .empty())
        
        let otherSignal = articlesObservable.asSignal(onErrorSignalWith: .empty())
        
        let layoutDriver: Driver<UICollectionViewLayout> = Driver.just(
            UICollectionViewFlowLayout()
        ).map {
            $0.itemSize = CGSize(width: UIScreen.main.bounds.size.width * 0.95, height: 300)
            return $0
        }
        
        return Output(
            isLoadingDriver: isLoading.asDriver(),
            dateSourceDriver: dataSourceDriver,
            otherSignal: otherSignal,
            refreshSignal: refreshSignal,
            layoutDriver: layoutDriver
        )
    }
}



