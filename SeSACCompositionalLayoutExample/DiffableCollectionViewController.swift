//
//  DiffableCollectionViewController.swift
//  SeSACCompositionalLayoutExample
//
//  Created by 박관규 on 2022/10/19.
//

import UIKit

class DiffableCollectionViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var list = ["우대갈비", "제주흑오겹살", "제육볶음", "코다리조림", "김치찌개", "된장찌개"]
    
    //                                                              셀을 다양하게 커스텀하여 사용가능하다
//    private var cellRegisteration : UICollectionView.CellRegistration<UICollectionViewListCell, String>!
    
    private var dataSource : UICollectionViewDiffableDataSource<Int, String>!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.collectionViewLayout = createLayout()
        configureDataSource()
        collectionView.delegate = self
        
        searchBar.delegate = self
        
    }
    
}

extension DiffableCollectionViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
        
        let alert = UIAlertController(title: item, message: "클릭!", preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .cancel)
        alert.addAction(ok)
        present(alert, animated: true)
        
    }
    
}

extension DiffableCollectionViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        var snapshot = dataSource.snapshot()
        snapshot.appendItems([searchBar.text!])
        dataSource.apply(snapshot, animatingDifferences: true)
        searchBar.text = ""
    }
    
}

extension DiffableCollectionViewController {
    
    private func createLayout() -> UICollectionViewLayout {
        
        let config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        let layout = UICollectionViewCompositionalLayout.list(using: config)
        
        return layout
        
    }
    
    private func configureDataSource() {
        let cellRegisteration = UICollectionView.CellRegistration<UICollectionViewListCell, String>(handler: { cell, indexPath, itemIdentifier in
            
            var content = UIListContentConfiguration.valueCell()
            
            content.text = itemIdentifier
            content.secondaryText = "\(itemIdentifier.count)"
            
            cell.contentConfiguration = content
            
            var background = UIBackgroundConfiguration.listPlainCell()
            
            background.strokeWidth = 2
            background.strokeColor = .lightGray
            
            cell.backgroundConfiguration = background
            
        })
        
        // collectionView.dataSoure = self 의 기능과 같다
        // numberOfItemsInSection, cellForItemAt 을 대체한다.
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegisteration, for: indexPath, item: itemIdentifier)
            
            return cell
            
        })
        
        var snapshot = NSDiffableDataSourceSnapshot<Int, String>()
        snapshot.appendSections([0])
        snapshot.appendItems(list)
        dataSource.apply(snapshot)
        
    }
    
}
