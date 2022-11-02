//
//  SubjectViewController.swift
//  SeSACCompositionalLayoutExample
//
//  Created by 박관규 on 2022/10/25.
//

import UIKit
import RxSwift
import RxCocoa

class SubjectViewController: UIViewController {

    @IBOutlet weak var newButton: UIBarButtonItem!
    @IBOutlet weak var addbutton: UIBarButtonItem!
    @IBOutlet weak var resetbutton: UIBarButtonItem!
    @IBOutlet weak var searchbar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    let publish = PublishSubject<Int>() // 초기값이 없는 빈 상태
    let behavior = BehaviorSubject(value: 100) // 초기값 필수
    let replay = ReplaySubject<Int>.create(bufferSize: 3)
    // bufferSize 작성된 이벤트 갯수만큼 메모리에서 이벤트를 가지고 있다가, subscribe 직후 한번에 이벤트를 전달한다.
    let async = AsyncSubject<Int>()
    
    
    let disposeBag = DisposeBag()
    
    let viewModel = SubjectViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ContactCell")
        // After
        let input = SubjectViewModel.Input(addtap: addbutton.rx.tap, resettap: resetbutton.rx.tap, newtap: newButton.rx.tap, searchText: searchbar.rx.text)
        
        let output = viewModel.transform(input: input)
        
        
        
        
        
        // Before
//        viewModel.list // VM -> VC (Output)
//            .asDriver(onErrorJustReturn: [])
        
        output.list
            .drive(tableView.rx.items(cellIdentifier: "ContactCell", cellType: UITableViewCell.self)) { (row, element, cell) in
                cell.textLabel?.text = "\(element.name): \(element.age)세 (\(element.number))"
            }
            .disposed(by: disposeBag)
        
//        addbutton.rx.tap
        output.addtap
            .withUnretained(self)
            .subscribe { (vc, _) in
                vc.viewModel.fetchData()
            }
            .disposed(by: disposeBag)
        
//        resetbutton.rx.tap
        output.resettap
            .withUnretained(self)
            .subscribe { (vc, _) in
                vc.viewModel.resetData()
            }
            .disposed(by: disposeBag)
        
//        newButton.rx.tap // VC -> VM (Input)
        output.newtap
            .withUnretained(self)
            .subscribe { (vc, _) in
                vc.viewModel.newData()
            }
            .disposed(by: disposeBag)
        
//        searchbar.rx.text.orEmpty // VC -> VM (Input)
//            .debounce(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance) // wait
//            .distinctUntilChanged() // 같은 값을 받지 않음
        output.searchText
            .withUnretained(self)
            .subscribe { (vc, value) in
                print("----\(value)----")
                vc.viewModel.filterData(query: value)
            }
            .disposed(by: disposeBag)
        
    }

}



extension SubjectViewController {
//    func asyncSubject() {
//        async.onNext(10)
//        async.onNext(20)
//        async.onNext(30)
//        async.onNext(40)
//        async.onNext(50)
//
//        async
//            .subscribe { value in
//                print("async - \(value)")
//            } onError: { error in
//                print("async - \(error)")
//            } onCompleted: {
//                print("async completed")
//            } onDisposed: {
//                print("async disposed")
//            }
//            .disposed(by: disposeBag)
//
//        async.onNext(3)
//        async.onNext(4)
//        async.on(.next(5))
//
//        async.onCompleted()
//
//        async.onNext(6)
//        async.onNext(7)
//    }
    
    func replaySubject() {
        // bufferSize만큼의 구독 전 이벤트를 실행한다
        
        // bufferSize는 메모리에 가지고있게된다.
        // array, image를 가지게 되면 메모리에 지장이 갈 수도 있다.
        
        replay.onNext(10)
        replay.onNext(20)
        replay.onNext(30)
        replay.onNext(40)
        replay.onNext(50)
        
        replay
            .subscribe { value in
                print("replay - \(value)")
            } onError: { error in
                print("replay - \(error)")
            } onCompleted: {
                print("replay completed")
            } onDisposed: {
                print("replay disposed")
            }
            .disposed(by: disposeBag)
        
        replay.onNext(3)
        replay.onNext(4)
        replay.on(.next(5))
        
        replay.onCompleted()
        
        replay.onNext(6)
        replay.onNext(7)
    }
    
    func behaviorSubject() {
        // 구독 전 가장 최근의 값을 emit 하기 때문에
        // 초기값이 꼭 필요하다.
        
        behavior.onNext(1)
        behavior.onNext(2)
        
        behavior
            .subscribe { value in
                print("behavior - \(value)")
            } onError: { error in
                print("behavior - \(error)")
            } onCompleted: {
                print("behavior completed")
            } onDisposed: {
                print("behavior disposed")
            }
            .disposed(by: disposeBag)
        
        behavior.onNext(3)
        behavior.onNext(4)
        behavior.on(.next(5))
        
        behavior.onCompleted()
        
        behavior.onNext(6)
        behavior.onNext(7)
    }
    
    func publishSubject() {
        // 초기값이 없는 빈 상태, subscribe 전 or Error or completed notification 이후 이벤트 무시
        // subsribe 후에 대한 이벤트는 다 처리된다.
        
        
        // 구독하기 전이기 때문에 출력되지 않는다.
        publish.onNext(1)
        publish.onNext(2)
        
        publish
            .subscribe { value in
                print("publish - \(value)")
            } onError: { error in
                print("publish - \(error)")
            } onCompleted: {
                print("publish completed")
            } onDisposed: {
                print("publish disposed")
            }
            .disposed(by: disposeBag)
        
        publish.onNext(3)
        publish.onNext(4)
        publish.on(.next(5))
        
        // 구독취소
        publish.onCompleted()
        
        publish.onNext(6)
        publish.onNext(7)
        
    }
}
