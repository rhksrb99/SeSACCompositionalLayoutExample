//
//  NewsViewController.swift
//  SeSACCompositionalLayoutExample
//
//  Created by 박관규 on 2022/10/20.
//

import UIKit
import RxSwift
import RxCocoa

class NewsViewController: UIViewController {

    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var btn_load: UIButton!
    @IBOutlet weak var btn_reset: UIButton!
    
    var viewModel = NewsViewModel()
    
//    let disposeBag = DisposeBag()
    
    var dataSource: UICollectionViewDiffableDataSource<Int, News.NewsItem>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureHierachy()
        configureDataSource()
        
        bindData()
        
        configureViews()
    }
    
    func configureViews() {
        
        numberTextField.addTarget(self, action: #selector(numberTextFieldChanged), for: .editingChanged)
        btn_reset.addTarget(self, action: #selector(resetButtonClicked), for: .touchUpInside)
        btn_load.addTarget(self, action: #selector(loadButtonClicked), for: .touchUpInside)
        
    }
    
    func bindData() {
        viewModel.pageNumber.bind { value in
            self.numberTextField.text = value
        }
        
        viewModel.sample.bind { item in
            var snapshot = NSDiffableDataSourceSnapshot<Int, News.NewsItem>()
            snapshot.appendSections([0])
            snapshot.appendItems(item)
            self.dataSource.apply(snapshot, animatingDifferences: false)
        }
            

        
//        viewModel.sample.bind { item in
//            var snapshot = NSDiffableDataSourceSnapshot<Int, News.NewsItem>()
//            snapshot.appendSections([0])
//            snapshot.appendItems(item)
//            self.dataSource.apply(snapshot, animatingDifferences: false)
//        }
        
    }
    
    @objc func numberTextFieldChanged() {
        guard let text = numberTextField.text else { return }
        viewModel.changeFormatPageNumber(text: text)
    }
    
    @objc func resetButtonClicked() {
        viewModel.resetSample()
    }
    
    @objc func loadButtonClicked() {
        viewModel.loadSample()
    }
    
}

extension NewsViewController {
    
    func configureHierachy() {
        collectionView.collectionViewLayout = createLayout()
        collectionView.backgroundColor = .lightGray
    }
    
    func configureDataSource() {
        
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, News.NewsItem> { cell, indexPath, itemIdentifier in
            
            var content = UIListContentConfiguration.valueCell()
            content.text = itemIdentifier.title
            content.secondaryText = itemIdentifier.body
            
            cell.contentConfiguration = content
        }
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
            
            return cell
            
        })
    }
    
    func createLayout() -> UICollectionViewLayout {
        let configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        
        return layout
    }
    
}
