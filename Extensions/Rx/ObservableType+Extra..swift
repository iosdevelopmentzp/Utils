//
//  ObservableType+Extra..swift
//  Extensions
//
//  Created by 6 on 27.07.2020.
//  Copyright © 2020 dvcomp. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

extension ObservableType {
    func execute(_ selector: @escaping (Element) -> Void) -> Observable<Element> {
        return flatMap { result in
             return Observable
                .just(selector(result))
                .map { _ in result }
                .take(1)
        }
    }
    
    func unwrap<T>() -> Observable<T> where Element == T? {
        return compactMap { $0 }
    }
    
    func asOptional<T>() -> Observable<T?> where Element == T {
        return map { element -> T? in return element }
    }
    
    func merge(with other: Observable<Element>) -> Observable<Element> {
        return Observable.merge(self.asObservable(), other)
    }
    
    func ignoreAll() -> Observable<Void> {
        return map { _ in }
    }
}

extension Single {
    
    func asOptional() -> Observable<Element?> {
        return asObservable().asOptional()
    }
}
