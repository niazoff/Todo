//
//  ArrayExtensions.swift
//  Todo
//
//  Created by Natanel Niazoff on 6/27/19.
//  Copyright © 2019 Natanel Niazoff. All rights reserved.
//

import Foundation

extension Array {
  mutating func remove(at indices: IndexSet) {
    indices.sorted(by: >).forEach { self.remove(at: $0) }
  }
}
