//
//  ValidationViewController.swift
//  SeSACCompositionalLayoutExample
//
//  Created by 박관규 on 2022/10/27.
//

import UIKit
import RxCocoa
import RxSwift

class ValidationViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var validationLabel: UILabel!
    @IBOutlet weak var stepButton: UIButton!
    
    let viewModel = ValidationViewModel()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
        
    }
    
    func bind() {
        
        viewModel.validText
            .asDriver()
            .drive(validationLabel.rx.text)
            .disposed(by: disposeBag)
        
        // 반복되는 코드를 상수로 선언하여 사용할 수 있다.
        let validation = nameTextField.rx.text
            .orEmpty
            .map { $0.count >= 8 }
            .share() // Subject, Relay
//
//        // subscribe = 에러와 컴플리트를 모두 처리할 때 사용
//        // bind = 에러가 발생하지 않음에 확신할 때 사용
//
//        nameTextField.rx.text // String? 타입으로 시작
//            .orEmpty // String 타입으로 변환
//            .map { $0.count >= 8 } // bool 타입으로 변환
        validation
            .bind(to: stepButton.rx.isEnabled, validationLabel.rx.isHidden) // 위의 조건에 따라 버튼을 비활성화 시키고 레이블을 숨긴다
            .disposed(by: disposeBag)
//
//        nameTextField.rx.text
//            .orEmpty
//            .map { $0.count >= 8 }
        validation
            .withUnretained(self)
            .bind { (vc, value) in
                let color: UIColor = value ? .lightGray : .red
                vc.stepButton.backgroundColor = color
            }
            .disposed(by: disposeBag)
        
        
        
    }
    
    func obsercableVSSubject() {
        
        // Stream == Sequence
        let testA = stepButton.rx.tap
            .map { "안녕하세요" }
            .asDriver(onErrorJustReturn: "")
//            .share()

        testA
            .drive(validationLabel.rx.text)
            .disposed(by: disposeBag)

        testA
            .drive(nameTextField.rx.text)
            .disposed(by: disposeBag)

        testA
            .drive(stepButton.rx.title())
            .disposed(by: disposeBag)


//        stepButton.rx.tap
//            .subscribe { _ in
//                print("next")
//            } onDisposed: {
//                print("disposed")
//            }
//            //.dispose()
//            // 위의 dispose()와 동일하다
//            .disposed(by: disposeBag)
//            // dispose는 수동으로 리소스를 정리하는 것이다.
//            // deinit, notification이 호출되는 시점
        
        let sampleInt = Observable<Int>.create { observer in
            observer.onNext(Int.random(in: 1...100))
            return Disposables.create()
        }
        
        sampleInt.subscribe { value in
            print("sampleInt : \(value)")
        }
        .disposed(by: disposeBag)
        
        sampleInt.subscribe { value in
            print("sampleInt : \(value)")
        }
        .disposed(by: disposeBag)
        
        sampleInt.subscribe { value in
            print("sampleInt : \(value)")
        }
        .disposed(by: disposeBag)
        
        let subjectInt = BehaviorSubject(value: 0)
        subjectInt.onNext(Int.random(in: 1...100))
        
        subjectInt.subscribe { value in
            print("subjectInt: \(value)")
        }
        .disposed(by: disposeBag)
        
        subjectInt.subscribe { value in
            print("subjectInt: \(value)")
        }
        .disposed(by: disposeBag)
        
        subjectInt.subscribe { value in
            print("subjectInt: \(value)")
        }
        .disposed(by: disposeBag)
        
    }
}
