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
        setupView()
    }
    
    func setupView() {
        collectionView = self.makeCollectionView()
        spinner.isHidden = true
        self.addSubview(spinner)
        self.addSubview(collectionView)
        
        self.backgroundColor = .white
        setupConstraints()
    }
    
    func setupConstraints() {
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
    }
}

extension ArticleView {
    typealias DataSource = RxCollectionViewSectionedReloadDataSource<HeadlineListSectionModel>
    
    func makeCollectionView() -> UICollectionView {
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewFlowLayout.itemSize = CGSize(width: UIScreen.main.bounds.size.width * 0.95, height: 300)
        let collectionView: UICollectionView = .init(frame: CGRectZero, collectionViewLayout: collectionViewFlowLayout)
        collectionView.refreshControl = refreshControler
        return collectionView
    }
    
    func makeDataSource() -> DataSource {
        
        collectionView.register(ArticleCell.self, forCellWithReuseIdentifier: "articleCell")
        
        return .init(
            configureCell: { dataSource, collectionView, indexPath, item in
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "articleCell", for: indexPath) as! ArticleCell
                let viewModelOutput = item.transform(input: cell.input)
                cell.configure(output: viewModelOutput)
                return cell
            }
        )
    }
}

struct HeadlineListSectionModel {
    var header: String
    var items: [Item]
}

extension HeadlineListSectionModel: SectionModelType {
    typealias Item = ArticleCellViewModel
    
    var identity: String {
        return header
    }
    
    init(original: HeadlineListSectionModel, items: [Item]) {
        self = original
        self.items = items
    }
}
