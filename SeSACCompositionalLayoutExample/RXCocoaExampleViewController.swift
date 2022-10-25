//
//  RXCocoaExampleViewController.swift
//  SeSACCompositionalLayoutExample
//
//  Created by 박관규 on 2022/10/24.
//

import UIKit
import RxCocoa
import RxSwift

class RXCocoaExampleViewController: UIViewController {

    @IBOutlet weak var simpleTableView: UITableView!
    @IBOutlet weak var simplePickerVIew: UIPickerView!
    @IBOutlet weak var simpleLabel: UILabel!
    @IBOutlet weak var simpleSwitch: UISwitch!
    
    @IBOutlet weak var signName: UITextField!
    @IBOutlet weak var signEmail: UITextField!
    @IBOutlet weak var signButton: UIButton!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setSwitch()
        setTable()
        setPicker()
        setSign()
        setOperator()
        
    }
    
    func setOperator() {
        
        let intervalObservable = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe { value in
                print("interval - \(value)")
            } onError: { error in
                print("interval - \(error)")
            } onCompleted: {
                print("interval completed")
            } onDisposed: {
                print("interval disposed")
            }
//            .disposed(by: disposeBag)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            intervalObservable.dispose()
        }
        
        let itemA = [2.2, 3.0, 4.0, 7.3, 5.4]
        let itemB = [8.4, 6.0, 4.1]
        
        Observable.just(itemA)
            .subscribe { value in
                print("just - \(value)")
            } onError: { error in
                print("just - \(error)")
            } onCompleted: {
                print("just completed")
            } onDisposed: {
                print("just disposed")
            }
        
        Observable.of(itemA, itemB)
            .subscribe { value in
                print("of - \(value)")
            } onError: { error in
                print("of - \(error)")
            } onCompleted: {
                print("of completed")
            } onDisposed: {
                print("of disposed")
            }
        
        Observable.from(itemA)
            .subscribe { value in
                print("from - \(value)")
            } onError: { error in
                print("from - \(error)")
            } onCompleted: {
                print("from completed")
            } onDisposed: {
                print("from disposed")
            }
        
    }

    func setSign() {
        
        // ex. 텍스트필드1(observable), 텍스트필드2(observable)의
        // 내용을 레이블(observer, bind)에 띄우기
        // 언랩핑 : orEmpty
        Observable.combineLatest(signName.rx.text.orEmpty, signEmail.rx.text.orEmpty) { value1, value2 in
            return "name : \(value1), email : \(value2)"
        }
        .bind(to: simpleLabel.rx.text)
        .disposed(by: disposeBag)
        
        signName // UItextfield
            .rx // Reactive
            .text // String?
            .orEmpty // String - 데이터의 흐름 Stream
            .map { $0.count < 4 } // Int
//            .map { $0 < 4 } // Bool
            .bind(to: signEmail.rx.isHidden, signButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        signEmail.rx.text.orEmpty
            .map { $0.count > 4 }
            .bind(to: signButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        signButton.rx.tap
            .subscribe { _ in
                self.showAlert()
            }
            .disposed(by: disposeBag)
        
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "title", message: "message", preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .cancel)
        let cancel = UIAlertAction(title: "취소", style: .default)
        alert.addAction(ok)
        alert.addAction(cancel)
        self.present(alert, animated: true)
    }
    
    func setSwitch() {
        Observable.just(false) // just? of?
            .bind(to: simpleSwitch.rx.isOn)
            .disposed(by: disposeBag)
    }
    
    func setTable() {
        
        simpleTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        let items = Observable.just([
            "First Item",
            "Second Item",
            "Third Item"
        ])

        items
        .bind(to: simpleTableView.rx.items) { (tableView, row, element) in
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
            cell.textLabel?.text = "\(element) @ row \(row)"
            return cell
        }
        .disposed(by: disposeBag)
        
        // 항상 뷰객체 뒤에는 rx 라는 키워드가 붙는다
        // uikit의 didselectedRowAt 과 같다
        simpleTableView.rx.modelSelected(String.self)
            .map({ data in
                "\(data)를 선택하셨습니다."
            })
            .bind(to: simpleLabel.rx.text)
            .disposed(by: disposeBag)

        
    }
    
    func setPicker() {
        let items = Observable.just([
                "영화",
                "TV 프로그램",
                "음악",
                "도서"
            ])
     
        items
            .bind(to: simplePickerVIew.rx.itemTitles) { (row, element) in
                return element
            }
            .disposed(by: disposeBag)
        
        simplePickerVIew.rx.modelSelected(String.self)
            .map{ $0.description }
            .bind(to: simpleLabel.rx.text)
        
//            .subscribe (onNext:{ value in
//                print(value)
//            })
            .disposed(by: disposeBag)
            

        
    }
    
}
