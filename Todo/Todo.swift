//
//  Todo.swift
//  Todo
//
//  Created by Natanel Niazoff on 6/23/19.
//  Copyright © 2019 Natanel Niazoff. All rights reserved.
//

import Foundation

struct Todo: Codable {
  var id: Int?
  var description: String
  var isComplete: Bool
  
  private let _priority: Int
  private let _createdAt: Date.Datatype
  
  var priority: Priority { Priority(rawValue: _priority) ?? preconditionFailure() }
  var createdAt: Date { Date.fromDatatypeValue(_createdAt) }
  
  enum Priority: Int, CaseIterable {
    case low, medium, high
  }
  
  private enum CodingKeys: String, CodingKey {
    case id, description, isComplete
    case _priority = "priority"
    case _createdAt = "createdAt"
  }
  
  init(id: Int? = nil,
       description: String,
       priority: Priority = .low,
       isComplete: Bool = false,
       createdAt: Date = Date()) {
    self.id = id
    self.description = description
    self.isComplete = isComplete
    self._priority = priority.rawValue
    self._createdAt = createdAt.datatypeValue
  }
}

extension Todo: Equatable {
  static func == (lhs: Todo, rhs: Todo) -> Bool {
    guard let lhsID = lhs.id, let rhsID = rhs.id else { return false }
    return lhsID == rhsID
  }
}

extension Todo: Comparable {
  static func < (lhs: Todo, rhs: Todo) -> Bool {
    (lhs.isComplete == rhs.isComplete &&
      lhs.createdAt < rhs.createdAt) ||
      !lhs.isComplete && rhs.isComplete
  }
}

extension Todo.Priority: Equatable {}
extension Todo.Priority: Comparable {
  static func < (lhs: Todo.Priority, rhs: Todo.Priority) -> Bool {
    lhs.rawValue < rhs.rawValue
  }
}

extension Todo.Priority {
  var text: String {
    switch self {
    case .low: return "!"
    case .medium: return "!!"
    case .high: return "!!!"
    }
  }
}
