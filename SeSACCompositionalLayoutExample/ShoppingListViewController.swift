//
//  ShoppingListViewController.swift
//  SeSACCompositionalLayoutExample
//
//  Created by 박관규 on 2022/10/19.
//

import UIKit

class ShoppingListViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var shoppingCollectionView: UICollectionView!
    
    var list = ["모자", "후드티", "양말", "조거팬츠", "와이드 슬랙스", "연청바지"]
    
    private var dataSource : UICollectionViewDiffableDataSource<Int, String>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        shoppingCollectionView.collectionViewLayout = createLayout()
        configureDataSource()
        shoppingCollectionView.delegate = self
        searchBar.delegate = self
        
    }
    
    func alert(item: String, message: String) {
        let alert = UIAlertController(title: item, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .default)
        alert.addAction(ok)
        present(alert, animated: true)
    }

}

extension ShoppingListViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
        
        alert(item: item, message: "\(item)을(를) 선택하셨습니다!")
        
    }
    
}

extension ShoppingListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        
        if searchBar.text == "" {
            alert(item: "경고", message: "입력값이 없습니다.\n올바른 품명을 입력하세요.")
        } else {
            var snapshot = dataSource.snapshot()
            snapshot.appendItems([searchBar.text!])
            dataSource.apply(snapshot, animatingDifferences: true)
            alert(item: searchBar.text! , message: "\(searchBar.text!)를 쇼핑리스트에 넣습니다!")
            searchBar.text = ""
        }
    }
    
}

extension ShoppingListViewController {
    
    private func createLayout() -> UICollectionViewLayout {
        
        let config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        let layout = UICollectionViewCompositionalLayout.list(using: config)
        
        return layout
        
    }
    
    private func configureDataSource() {
        let cellRegisteration = UICollectionView.CellRegistration<UICollectionViewListCell, String>(handler: { cell, indexPath, itemIdentifier in
            
            var content = UIListContentConfiguration.valueCell()
            
            content.text = itemIdentifier
            
            cell.contentConfiguration = content
            
            var background = UIBackgroundConfiguration.listPlainCell()
            
            background.strokeWidth = 2
            background.strokeColor = .lightGray
            
            cell.backgroundConfiguration = background
            
        })
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: shoppingCollectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegisteration, for: indexPath, item: itemIdentifier)
            
            return cell
            
        })
        
        var snapshot = NSDiffableDataSourceSnapshot<Int, String>()
        snapshot.appendSections([0])
        snapshot.appendItems(list)
        dataSource.apply(snapshot)
        
    }
    
}
