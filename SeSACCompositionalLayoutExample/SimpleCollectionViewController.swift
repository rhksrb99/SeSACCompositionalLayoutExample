//
//  SimpleCollectionViewController.swift
//  SeSACCompositionalLayoutExample
//
//  Created by 박관규 on 2022/10/18.
//

import UIKit

struct User : Hashable {
    let id = UUID().uuidString
    let name: String
    let age: Int
}

class SimpleCollectionViewController: UICollectionViewController {

    var list = [
        User(name: "어른이", age: 24),
        User(name: "어린이", age: 23),
        User(name: "오른이", age: 22),
        User(name: "오린이", age: 21)
    ]
    
    // 임의의 매개변수를 생성
    // 보통 함수 바깥에 생성한다. -> cellForItemAt 전에 생성되어야 한다. => register 코드와 유사한 역할이다.
    var cellRegistration: UICollectionView.CellRegistration<UICollectionViewListCell, User>!
    
    var dataSource: UICollectionViewDiffableDataSource<Int, User>!
    
//    var hello : (() -> Void)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        // welcome만 부르는 것은 함수 자체를 부르는 것이고
//        // welcome() 을 부르는 것은 호출까지 하는 것이다.
//        hello = {
//            print("hello")
//        }
        
        // 위의 hello와 cellRegistration은 같은 구조라고 볼 수 있다.
        // 호출하고있지않은 함수를 생성만 해둔 것.
        
        
        // 이러한 구조를 사용하는 장점 = 1. Identifier를 사용하지 않는다.
        //                        2. 구조체로 이루어져 있다.
        
        // 3. 뷰에 레이아웃 적용
        collectionView.collectionViewLayout = createLayout()
        // 4. cell 내부 데이터 적용
        cellRegistration = UICollectionView.CellRegistration { cell, indexPath, itemIdentifier in
            
            var content = UIListContentConfiguration.valueCell() //cell.defaultContentConfiguration()
            
            
            // 텍스트가 공간을 넘어가면 자동으로 셀의 크기가 달라진다.
            content.text = itemIdentifier.name
            content.textProperties.color = .white

            // 기본 텍스트가 길어지면 자동으로 내려간다.
            content.secondaryText = "\(itemIdentifier.age)살"
            content.secondaryTextProperties.color = .white
            // secondaryText가 밑으로 내려간다.
            content.prefersSideBySideTextAndSecondaryText = false
            // 밑으로의 padding 넓이 적용
            content.textToSecondaryTextVerticalPadding = 20

            content.image = itemIdentifier.age < 22 ? UIImage(systemName: "heart.fill") : UIImage(systemName: "star.fill")
            content.imageProperties.tintColor = .systemMint
            
            cell.contentConfiguration = content
            
            var backgroundConfig = UIBackgroundConfiguration.listPlainCell()
            backgroundConfig.backgroundColor = .darkGray
            backgroundConfig.cornerRadius = 10
            backgroundConfig.strokeWidth = 2
            backgroundConfig.strokeColor = .white
            
            cell.backgroundConfiguration = backgroundConfig
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            
            let cell = collectionView.dequeueConfiguredReusableCell(using: self.cellRegistration, for: indexPath, item: itemIdentifier)
            
            return cell
            
        })
        
        var snapshot = NSDiffableDataSourceSnapshot<Int, User>()
        snapshot.appendSections([0])
        snapshot.appendItems(list)
        dataSource.apply(snapshot, animatingDifferences: true)
        
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return list.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let item = list[indexPath.row]
        
        // using 부분에 무엇이 들어올지 모르기 때문에 Generic형태로 이루어져있다.
        let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
        
        
        return cell
    }
    
}

extension SimpleCollectionViewController {
    
    private func createLayout() -> UICollectionViewLayout {
        
        // 14버전 이상에선 컬렉션뷰를 테이블뷰 스타일처럼 사용 가능 (List Configuration)
        // 1. configutation 그룹스타일 지정
        var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        configuration.showsSeparators = false
        configuration.backgroundColor = .lightGray
        
        // 2. 레이아웃에 적용
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        
        return layout
    }
    
}
