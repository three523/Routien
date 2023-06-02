//
//  Result.swift
//  Routine
//
//  Created by 김도현 on 2023/05/26.
//

import RealmSwift

extension Results {
    func toArray<T>(type: T.Type) -> [T] {
        return compactMap { $0 as? T }
    }
}
