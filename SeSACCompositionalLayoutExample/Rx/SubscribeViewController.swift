//
//  SubscribeViewController.swift
//  SeSACCompositionalLayoutExample
//
//  Created by 박관규 on 2022/10/26.
//

import UIKit
import RxCocoa
import RxSwift

class SubscribeViewController: UIViewController {

    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var label: UILabel!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 탭 -> 레이블: "안녕 반가워"
        // 1.
//        button.rx.tap
//            .subscribe { [weak self] _ in
//                self?.label.text = "안녕 반가워"
//            }
//            .disposed(by: disposeBag)
        
        // 2.
//        button.rx.tap
//            .withUnretained(self)
//            .subscribe { (vc, _) in
//                vc.label.text = "안녕 반가워"
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
        button.rx.tap
            .map { "안녕 반가웡" }
            .asDriver(onErrorJustReturn: "")
            .drive(label.rx.text)
            .disposed(by: disposeBag)
    }

}
