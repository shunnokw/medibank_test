//
//  SavedSceneViewModelTests.swift
//  newsAppTests
//
//  Created by Jason Wong on 22/1/2023.
//

import XCTest
import RxTest
import RxSwift
import RxCocoa

@testable import newsApp

final class SavedSceneViewModelTests: XCTestCase {
    typealias ViewModel = SavedSceneViewModel
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
        mockUserDefaultService.stubBookmarks = [MockStuff.MockArticle]
        mockNewsApiService.stubImage = scheduler.createColdObservable([
            .next(0, nil)
        ])
        .asObservable()
        
        let viewModel = ViewModel.init(
            navigator: .init(navigator: UINavigationController()),
            userDefaultService: mockUserDefaultService, newsAPIService: mockNewsApiService
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

        let cellViewModelOutput = cellViewModel.transform(input: .init(clickOnCardSignal: .empty()))
        let titleTextObserver = scheduler.createObserver(NSAttributedString.self)
        cellViewModelOutput.titleTextDriver.drive(titleTextObserver).disposed(by: disposeBag)
        
        scheduler.start()
        
        let font = UIFont.systemFont(ofSize: 14)
        let attributes = [NSAttributedString.Key.font: font]
        let expectedText = NSAttributedString(string: "test", attributes: attributes)
        
        XCTAssertEqual(titleTextObserver.events, [
            .next(0, expectedText)
        ])
    }
}

extension SavedSceneViewModelTests {
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
