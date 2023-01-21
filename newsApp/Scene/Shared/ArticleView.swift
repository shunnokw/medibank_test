//
//  HeadlinesSceneView.swift
//  newsApp
//
//  Created by Jason Wong on 18/1/2023.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

final class ArticleView: UIView {
    let input: HeadlinesSceneViewModel.Input!

    private let disposeBag = DisposeBag()
    private var collectionView: UICollectionView!
    private let spinner = UIActivityIndicatorView()
    private let refreshControler = UIRefreshControl()
    
    override init(frame: CGRect) {
        self.input = HeadlinesSceneViewModel.Input(
            refreshControlSignal: refreshControler.rx.controlEvent(.valueChanged).asSignal()
        )
        super.init(frame: frame)
        
        collectionView = self.makeCollectionView()
        spinner.isHidden = true
        self.addSubview(spinner)
        self.addSubview(collectionView)
        
        self.backgroundColor = .white
        setupConstraints()
    }
    
    private func setupConstraints() {
        // TODO: move magic number to constant file
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(output: HeadlinesSceneViewModel.Output) {
        let dataSource = makeDataSource()
        output.dateSourceDriver.drive(collectionView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        output.isLoadingDriver.drive(onNext: {
            isLoading in
            if isLoading {
                self.collectionView.isHidden = true
                self.spinner.isHidden = false
                self.spinner.startAnimating()
            } else {
                self.collectionView.isHidden = false
                self.spinner.isHidden = true
                self.spinner.stopAnimating()
            }
        }).disposed(by: disposeBag)
        output.otherSignal.emit().disposed(by: disposeBag)
        output.refreshSignal.emit(onNext: ({
            self.refreshControler.endRefreshing()
        })).disposed(by: disposeBag)
        output.layoutDriver.drive(collectionView.rx.collectionViewLayout).disposed(by: disposeBag)
    }
}

extension ArticleView {
    typealias DataSource = RxCollectionViewSectionedReloadDataSource<MultipleSectionModel>
    
    private func makeCollectionView() -> UICollectionView {
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        let collectionView: UICollectionView = .init(frame: CGRectZero, collectionViewLayout: collectionViewFlowLayout)
        collectionView.refreshControl = refreshControler
        return collectionView
    }
    
    private func makeDataSource() -> DataSource {
        collectionView.register(ArticleCell.self, forCellWithReuseIdentifier: "articleCell")
        collectionView.register(SourceCell.self, forCellWithReuseIdentifier: "sourceCell")

        return .init(
            configureCell: { dataSource, collectionView, indexPath, item in
                switch dataSource[indexPath] {
                case .ArticleListSectionItem(let viewModel):
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "articleCell", for: indexPath) as! ArticleCell
                    let viewModelOutput = viewModel.transform(input: cell.input)
                    cell.configure(output: viewModelOutput)
                    return cell
                case .SourceListSectionItem(let viewModel):
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sourceCell", for: indexPath) as! SourceCell
                    let viewModelOutput = viewModel.transform(input: cell.input)
                    cell.configure(output: viewModelOutput)
                    return cell
                }
            }
        )
    }
}

enum MultipleSectionModel {
    case ArticleListSectionModel(items: [SectionItem])
    case SourceListSectionModel(items: [SectionItem])
}

enum SectionItem {
    case ArticleListSectionItem(viewModel: ArticleCellViewModel)
    case SourceListSectionItem(viewModel: SourceCellViewModel)
}

extension MultipleSectionModel: SectionModelType {
    typealias Item = SectionItem
    
    var items: [SectionItem] {
        switch  self {
        case .ArticleListSectionModel(items: let items):
            return items.map { $0 }
        case .SourceListSectionModel(items: let items):
            return items.map { $0 }
        }
    }
    
    init(original: MultipleSectionModel, items: [Item]) {
        switch original {
        case .ArticleListSectionModel(items: _):
            self = .ArticleListSectionModel(items: items)
        case .SourceListSectionModel(items: _):
            self = .SourceListSectionModel(items: items)
        }
    }
}
