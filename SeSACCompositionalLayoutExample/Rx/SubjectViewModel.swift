//
//  SubjectViewModel.swift
//  SeSACCompositionalLayoutExample
//
//  Created by 박관규 on 2022/10/25.
//

import Foundation
import RxSwift

struct Contact {
    var name: String
    var age: Int
    var number: String
}

class SubjectViewModel {
    
    var contactData = [
        Contact(name: "Kidult1", age: 24, number: "01011111111"),
        Contact(name: "Kidult2", age: 25, number: "01022222222"),
        Contact(name: "Kidult3", age: 26, number: "01033333333")
    ]
    
    // 테이블뷰에 보여질 데이터이기 때문에 contact을 배열로 사용
    var list = PublishSubject<[Contact]>()
    
    func fetchData() {
        
        list.onNext(contactData)
        
    }
    
    // 초기화를 하기위해선 빈 배열을 넣어줄 수 있다.
    func resetData() {
        list.onNext([])
    }
    
    func newData() {
        
        let new = Contact(name: "어른이", age: Int.random(in: 20...30), number: "01045678901")
        
        contactData.append(new)
        
        list.onNext(contactData)
        
    }
    
    func filterData(query: String) {
        
        let result = query != "" ? contactData.filter { $0.name.contains(query) } : contactData
        list.onNext(result)
        
    }
    
}
