//
//  SequenceExtension.swift
//  MDFooBox
//
//  Created by  MarvinChan on 2019/11/8.
//  Copyright © 2019  MarvinChan. All rights reserved.
//

import Foundation

extension Sequence {
    func count(where predicate: (Element) throws -> Bool) rethrows -> Int {
        var count = 0
        for element in self {
            if try predicate(element) {
                count += 1
            }
        }
        return count
    }
}

