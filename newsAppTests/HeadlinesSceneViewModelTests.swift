//
//  newsAppTests.swift
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
        
        let dataSourceObserver: TestableObserver<[Section]> = scheduler.createObserver([Section].self)
        output.dateSourceDriver.drive(dataSourceObserver).disposed(by: disposeBag)
        output.otherSignal.emit().disposed(by: disposeBag)
        
        scheduler.start()
        
        let cellViewModel = try extractCellViewModel(
            dataSourceObserver: dataSourceObserver,
            event: 1,
            row: 0
        )
        
        scheduler.stop()
        
        let cellViewModelOutput = cellViewModel.transform(input: .init(clickOnCardSignal: .empty()))
        let titleTextObserver: TestableObserver<NSAttributedString> = scheduler.createObserver(NSAttributedString.self)
        cellViewModelOutput.titleTextDriver.drive(titleTextObserver).disposed(by: disposeBag)
        
        scheduler = TestScheduler(initialClock: 0)
        scheduler.start()
        
        let font = UIFont.systemFont(ofSize: 14)
        let attributes = [NSAttributedString.Key.font: font]
        let expectedText = NSAttributedString(string: "test", attributes: attributes)
        
        XCTAssertEqual(titleTextObserver.events, [
            .next(0, expectedText)
        ])
    }
}

extension HeadlinesSceneViewModelTests {
    func extractCellViewModel(
        dataSourceObserver: TestableObserver<[Section]>,
        event: Int,
        row: Int
    ) throws -> ArticleCellViewModel {
        guard let cellViewModel = dataSourceObserver.events[safe: event]?.value.element?[safe: 0]?.items[safe: row]
        else { throw "Failed to extract view model" }
        return cellViewModel
    }
}

extension String: Error {}

extension Collection {
  subscript(safe index: Index) -> Iterator.Element? {
    guard indices.contains(index) else { return nil }
    return self[index]
  }
}
