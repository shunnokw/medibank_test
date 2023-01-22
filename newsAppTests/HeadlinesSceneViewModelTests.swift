//
//  HeadlinesSceneViewModelTests.swift
//  newsAppTests
//
//  Created by Jason Wong on 18/1/2023.
//

import XCTest
import RxTest
import RxSwift
import RxCocoa

@testable import newsApp

final class HeadlinesSceneViewModelTests: XCTestCase {
    typealias ViewModel = HeadlinesSceneViewModel
    typealias Section = ViewModel.Section
    typealias NavigationEvent = HeadlinesSceneNavigator.Event
    
    private var scheduler: TestScheduler!
    private var disposeBag: DisposeBag!
    private var mockNewsApiService: MockNewsApiService!
    private var mockUserDefaultService: MockUserDefaultService!

    override func setUpWithError() throws {
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
        mockNewsApiService = MockNewsApiService()
        mockUserDefaultService = MockUserDefaultService()
    }

    func testDataSource() throws {
        let testImage = UIImage(systemName: "plus")
        mockNewsApiService.stubHeadlineArticlesObservable = scheduler.createColdObservable([
            .next(0, [MockStuff.MockArticle])
        ])
        .asObservable()
        
        let viewModel = ViewModel.init(
            navigator: .init(navigator: UINavigationController()),
            newsApiService: mockNewsApiService,
            userDefaultService: mockUserDefaultService
        )
        let output = viewModel.transform(input: .init(refreshControlSignal: .empty()))
        
        let dataSourceObserver = scheduler.createObserver([Section].self)
        output.dateSourceDriver.drive(dataSourceObserver).disposed(by: disposeBag)
        output.otherSignal.emit().disposed(by: disposeBag)
        
        scheduler.start()
        
        let cellViewModel = try extractCellViewModel(
            dataSourceObserver: dataSourceObserver,
            event: 1,
            row: 0
        )
        
        scheduler.stop()
        scheduler = TestScheduler(initialClock: 0)
        
        mockNewsApiService.stubImage = scheduler.createColdObservable([
            .next(0, testImage)
        ])
        .asObservable()

        let cellViewModelOutput = cellViewModel.transform(input: .init(clickOnCardSignal: .empty()))
        
        let titleTextObserver = scheduler.createObserver(NSAttributedString.self)
        cellViewModelOutput.titleTextDriver.drive(titleTextObserver).disposed(by: disposeBag)
        
        let authorTextObserver = scheduler.createObserver(NSAttributedString.self)
        cellViewModelOutput.authorTextDriver.drive(authorTextObserver).disposed(by: disposeBag)
        
        let imgObserver = scheduler.createObserver(UIImage?.self)
        cellViewModelOutput.thumbnailUIImageDriver.drive(imgObserver).disposed(by: disposeBag)
                
        scheduler.start()
        
        let titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]
        let expectedTitleText = NSAttributedString(string: "test", attributes: titleTextAttributes)
        let authorTextAttributes = [NSAttributedString.Key.font:  UIFont.systemFont(ofSize: 10)]
        let expectedAuthorText = NSAttributedString(string: "jason", attributes: authorTextAttributes)
        
        XCTAssertEqual(titleTextObserver.events, [
            .next(0, expectedTitleText)
        ])
        
        XCTAssertEqual(authorTextObserver.events, [
            .next(0, expectedAuthorText)
        ])
        
        XCTAssertEqual(imgObserver.events, [
            .next(0, testImage)
        ])
    }
    
    func testToWebViewScene() throws {
        mockNewsApiService.stubHeadlineArticlesObservable = scheduler.createColdObservable([
            .next(0, [MockStuff.MockArticle])
        ])
        .asObservable()
        mockNewsApiService.stubImage = scheduler.createColdObservable([
            .next(0, nil)
        ])
        .asObservable()
        
        
        let viewModel = ViewModel.init(
            navigator: .init(navigator: UINavigationController()),
            newsApiService: mockNewsApiService,
            userDefaultService: mockUserDefaultService
        )
        let output = viewModel.transform(input: .init(refreshControlSignal: .empty()))
        
        let dataSourceObserver = scheduler.createObserver([Section].self)
        output.dateSourceDriver.drive(dataSourceObserver).disposed(by: disposeBag)
        output.otherSignal.emit().disposed(by: disposeBag)
        
        scheduler.start()
        
        let cellViewModel = try extractCellViewModel(
            dataSourceObserver: dataSourceObserver,
            event: 1,
            row: 0
        )
        
        scheduler.stop()
        scheduler = TestScheduler(initialClock: 0)

        let clickedOnCardSignal: Signal<Void> = scheduler.createHotObservable([
            .next(0, ())
        ]).asSignal(onErrorSignalWith: .empty())
        
        let cellViewModelOutput = cellViewModel.transform(input: .init(clickOnCardSignal: clickedOnCardSignal))
        
        let navigationObserver = scheduler.createObserver(NavigationEvent.self)
        cellViewModelOutput.otherSignal.emit(to: navigationObserver).disposed(by: disposeBag)
        
        scheduler.start()
        
        XCTAssertEqual(navigationObserver.events, [
            .next(0, .toWebViewScene(article: MockStuff.MockArticle, userDefaultServiceType: mockUserDefaultService))
        ])
    }
}

extension HeadlinesSceneViewModelTests {
    func extractCellViewModel(
        dataSourceObserver: TestableObserver<[Section]>,
        event: Int,
        row: Int
    ) throws -> ArticleCellViewModel {
        guard let cellViewModel = dataSourceObserver.events[try: event]?.value.element?[try: 0]?.items[try: row]
        else { throw "Failed to extract view model" }
        
        switch cellViewModel {
        case .ArticleListSectionItem(let viewModel):
            return viewModel
        case .SourceListSectionItem:
            throw "Extracted wrong view model"
        }
    }
}

extension String: Error {}

extension Collection {
  subscript(try index: Index) -> Iterator.Element? {
    guard indices.contains(index) else { return nil }
    return self[index]
  }
}
