//
//  newsAppTests.swift
//  newsAppTests
//
//  Created by Jason Wong on 18/1/2023.
//

import XCTest
import RxTest
import RxSwift

@testable import newsApp

final class HeadlinesSceneViewModelTests: XCTestCase {
    typealias ViewModel = HeadlinesSceneViewModel
    typealias Section = ViewModel.Section
    
    private var scheduler: TestScheduler!
    private var disposeBag: DisposeBag!
    private var mockNetworkManager: MockNewsAPIManger!

    override func setUpWithError() throws {
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
        mockNetworkManager = MockNewsAPIManger()
    }

    func testDataSource() throws {
        mockNetworkManager.stubArticlesObservable = scheduler.createColdObservable([
            .next(0, [MockStuff.MockArticle])
        ])
        .asObservable()
        
        let viewModel = ViewModel.init(navigator: .init(), networkManager: mockNetworkManager)
        let output = viewModel.transform(input: .init())
        
        let dataSourceObserver: TestableObserver<[Section]> = scheduler.createObserver([Section].self)
        output.dateSourceDriver.drive(dataSourceObserver).disposed(by: disposeBag)
        
        scheduler.start()
        
        let cellViewModel = try extractCellViewModel(
            dataSourceObserver: dataSourceObserver,
            testTime: 0,
            indexPath: 0
        )
        
        scheduler.stop()
        
        let cellViewModelOutput = cellViewModel.transform(input: .init())
        let titleTextObserver: TestableObserver<String> = scheduler.createObserver(String.self)
        cellViewModelOutput.titleTextDriver.drive(titleTextObserver).disposed(by: disposeBag)
        
        scheduler = TestScheduler(initialClock: 0)
        scheduler.start()
        
        XCTAssertEqual(titleTextObserver.events, [
            .next(0, "test"),
            .completed(0)
        ])
    }
}

extension HeadlinesSceneViewModelTests {
    func extractCellViewModel(
        dataSourceObserver: TestableObserver<[Section]>,
        testTime: Int,
        indexPath: Int
    ) throws -> ArticleCellViewModel {
        guard let cellViewModel = dataSourceObserver.events[testTime].value.element?[0].items[indexPath]
        else { throw "error" }
        return cellViewModel
    }
}

extension String: Error {}
