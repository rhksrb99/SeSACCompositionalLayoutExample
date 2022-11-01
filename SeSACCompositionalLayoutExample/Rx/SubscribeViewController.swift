//
//  SubscribeViewController.swift
//  SeSACCompositionalLayoutExample
//
//  Created by 박관규 on 2022/10/26.
//

import UIKit
import RxAlamofire
import RxDataSources
import RxCocoa
import RxSwift

class SubscribeViewController: UIViewController {

    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    let disposeBag = DisposeBag()
    
    lazy var dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, Int>>(configureCell: { dataSource, tableView, IndexPath, item in
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        cell.textLabel?.text = "\(item)"
        return cell
        
    })
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        testRxAlamofire()
        textRxDataSource()
        
        
        Observable.of(1,2,3,4,5,6,7,8,9,10)
            .skip(3)
            .filter { $0 % 2 == 0 }
            .map { $0 * 2 }
            .subscribe { value in
                
            }
            .disposed(by: disposeBag)

        // 탭 -> 레이블: "안녕 반가워"
        // 1.
//        let sample = button.rx.tap
//
//        sample
//            .subscribe { [weak self] _ in
//                self?.label.text = "안녕 반가워"
//            }
//            .disposed(by: disposeBag)
        
        // 2.
//        button.rx.tap
//            .withUnretained(self)
//            .subscribe { (vc, _) in
//                DispatchQueue.main.async {
//                    vc.label.text = "안녕 반가워"
//                }
//            }
//            .disposed(by: disposeBag)
        
        // 3. 네티워크 통신이나 파일 다운로드 등 백그라운드에서 작업이 이루어질 수 있다.
//        button.rx.tap
//            .observe(on: MainScheduler.instance) // 다른 쓰레드로 동작하게 변경
//            .withUnretained(self)
//            .subscribe { (vc, _) in
//                vc.label.text = "안녕 반가워"
//            }
//            .disposed(by: disposeBag)
        
        // 4. bind: subscribe, mainSchedular, error 처리가 가능하다
//        button.rx.tap
//            .withUnretained(self)
//            .bind { (vc, _) in
//                vc.label.text = "안녕 반가워"
//            }
//            .disposed(by: disposeBag)
        
        // 5. operator로 데이터의 stream 조작
//        button
//            .rx
//            .tap
//            .map { "안녕 반가워" }
//            .bind(to: label.rx.text)
//            .disposed(by: disposeBag)
        
        // 6. driver traits: bind + stream 공유 ( 리소스 낭비 방지, share() )
//        button.rx.tap
//            .map { "안녕 반가웡" }
//            .asDriver(onErrorJustReturn: "")
//            .drive(label.rx.text)
//            .disposed(by: disposeBag)
    }
    
    func textRxDataSource() {
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        dataSource.titleForHeaderInSection = { dataSource, index in
            return dataSource.sectionModels[index].model
        }
        
        Observable.just([
            SectionModel(model: "title", items: [1, 2, 3]),
            SectionModel(model: "title", items: [1, 2, 3]),
            SectionModel(model: "title", items: [1, 2, 3])
        ])
        .bind(to: tableView.rx.items(dataSource: dataSource))
        .disposed(by: disposeBag)
        
        
    }
    
    func testRxAlamofire() {
        // Success Error => <Single> 네트워크 연결 성공 에러에 같이 쓰인다.
        let url = APIKey.searchURL + "apple"
        
        request(.get, url, headers: ["Authorization" : APIKey.authorization])
            .data()
            .decode(type: SearchPhoto.self, decoder: JSONDecoder())
            .subscribe(onNext: { value in
                print(value)
                print(value.results[0].likes)
            })
            .disposed(by: disposeBag)
        
    }


}
