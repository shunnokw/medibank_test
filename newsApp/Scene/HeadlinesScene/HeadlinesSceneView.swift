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

final class HeadlinesSceneView: UIView {
    let disposeBag = DisposeBag()
    let input: HeadlinesSceneViewModel.Input!
    var collectionView: UICollectionView!
    
    // TODO: Loading Indicator
    
    override init(frame: CGRect) {
        self.input = HeadlinesSceneViewModel.Input()
        super.init(frame: frame)
        setupView()
    }
    
    func setupView() {
        collectionView = self.makeCollectionView()
        
        self.addSubview(collectionView)
        
        self.backgroundColor = .white
        setupConstraints()
    }
    
    func setupConstraints() {
        // TODO: move magic number to constant file
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 10).isActive = true
        collectionView.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -10).isActive = true
        collectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func transform(output: HeadlinesSceneViewModel.Output) {
        let dataSource = makeDataSource()
        output.dateSourceDriver.drive(collectionView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
    }
}

extension HeadlinesSceneView {
    typealias DataSource = RxCollectionViewSectionedReloadDataSource<HeadlineListSectionModel>
    
    func makeCollectionView() -> UICollectionView {
        let uiCollectionViewFlowLayout = UICollectionViewFlowLayout()
        uiCollectionViewFlowLayout.itemSize = CGSize(width: UIScreen.main.bounds.size.width, height: 60)
        
        let collectionView: UICollectionView = .init(
            frame: CGRectZero,
            collectionViewLayout: uiCollectionViewFlowLayout
        )
        
        return collectionView
    }
    
    func makeDataSource() -> DataSource {
        
        collectionView.register(ArticleCell.self, forCellWithReuseIdentifier: "articleCell")
        
        return .init(
            configureCell: { dataSource, collectionView, indexPath, item in
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "articleCell", for: indexPath) as! ArticleCell
                
                let viewModelOutput = item.transform(input: .init())
                cell.transform(output: viewModelOutput)
                return cell
            }
        )
    }
}

struct HeadlineListSectionModel {
    var items: [Item]
}

extension HeadlineListSectionModel: SectionModelType {
    typealias Item = ArticleCellViewModel
    
    init(original: HeadlineListSectionModel, items: [Item]) {
        self = original
        self.items = items
    }
}
