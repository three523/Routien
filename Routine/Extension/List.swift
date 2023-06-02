//
//  List.swift
//  Routine
//
//  Created by 김도현 on 2023/06/01.
//

import RealmSwift

extension List {
    func toArray() -> [Element] {
        let array = Array(self)
        return array
    }
}
