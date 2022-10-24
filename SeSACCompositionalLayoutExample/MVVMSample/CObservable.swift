//
//  CObservable.swift
//  SeSACCompositionalLayoutExample
//
//  Created by 박관규 on 2022/10/20.
//

import Foundation

/*
 Observable
 */

class CObservable<T> {
    private var listener: ((T) -> Void)?
    
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    func bind(_ closure: @escaping (T) -> Void) {
        closure(value)
        listener = closure
    }
    
}
