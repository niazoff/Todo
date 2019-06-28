//
//  TodoViewModel.swift
//  Todo
//
//  Created by Natanel Niazoff on 6/25/19.
//  Copyright © 2019 Natanel Niazoff. All rights reserved.
//

import Foundation
import Combine

final class TodoViewModel {
  private let connection: TodoDatabaseConnection
  private var todo: Todo { didSet { _ = connection.update(todo) }}
  
  var id: Int { todo.id ?? preconditionFailure() }
  var text: String { todo.description }
  var priorityText: String { todo.priority.text }
  
  var isComplete: Bool {
    get { todo.isComplete }
    set {
      todo.isComplete = newValue
      didCompleteTodo?(todo)
      didChange.send(self)
    }
  }
  
  var didCompleteTodo: ((Todo) -> Void)?
  let didChange = PassthroughSubject<TodoViewModel, Never>()
  
  private class var defaultConnection: TodoDatabaseConnection {
    do { return try TodoDatabaseConnection() }
    catch { preconditionFailure(error.localizedDescription) }
  }
  
  init(connection: TodoDatabaseConnection = TodoViewModel.defaultConnection, todo: Todo) {
    self.connection = connection
    self.todo = todo
  }
  
  func delete() -> AnyPublisher<Void, Error> { connection.delete(todo) }
}

extension TodoViewModel: Equatable {
  static func == (lhs: TodoViewModel, rhs: TodoViewModel) -> Bool { lhs.todo == rhs.todo }
}

extension TodoViewModel: Comparable {
  static func < (lhs: TodoViewModel, rhs: TodoViewModel) -> Bool { lhs.todo < rhs.todo }
}
