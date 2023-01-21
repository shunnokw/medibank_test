//
//  SourceSceneViewModel.swift
//  newsApp
//
//  Created by Jason Wong on 19/1/2023.
//

import Foundation
import RxSwift
import RxCocoa

final class SourceSceneViewModel: ViewModelType {
    typealias Section = MultipleSectionModel
    typealias Input = HeadlinesSceneViewModel.Input
    typealias Output = HeadlinesSceneViewModel.Output
    
    private let newsApiService: NewsApiServiceType
    private let userDefaultService: UserDefaultServiceType
    private let isLoading: ActivityIndicator
    private let sourcesRelay: BehaviorRelay<[Source]>
    private let selectedSources: [Source]
    
    init(newsApiService: NewsApiServiceType, userDefaultService: UserDefaultServiceType) {
        self.newsApiService = newsApiService
        self.isLoading = ActivityIndicator()
        self.sourcesRelay = BehaviorRelay(value: [])
        self.userDefaultService = userDefaultService
        selectedSources = userDefaultService.getSelectedSources()
    }
    
    func transform(input: Input) -> Output {
        let refreshSignal = input.refreshControlSignal
            .asObservable()
            .flatMapLatest { return self.newsApiService.getSources() }
            .map { self.sourcesRelay.accept($0) }
            .asSignal(onErrorSignalWith: .empty())
        
        let sourcesObservable = newsApiService.getSources().trackActivity(isLoading).map {
            self.sourcesRelay.accept($0)
        }
        
        let dataSourceDriver: Driver<[Section]> = sourcesRelay.map { [self]
            sources in
            let sourceCellViewModels: [SectionItem] = sources.map {
                .SourceListSectionItem(viewModel: SourceCellViewModel(source: $0, isSelected: selectedSources.contains($0), userDefaultService: userDefaultService))
            }
            return [.SourceListSectionModel(items: sourceCellViewModels)]
        }
        .asDriver(onErrorDriveWith: .empty())
        
        let otherSignal = sourcesObservable.asSignal(onErrorSignalWith: .empty())
        
        let layoutDriver: Driver<UICollectionViewLayout> = Driver.just(
            UICollectionViewFlowLayout()
        ).map { 
            $0.itemSize = CGSize(width: UIScreen.main.bounds.size.width * 0.95, height: 50)
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
