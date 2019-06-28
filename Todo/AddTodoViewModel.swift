//
//  AddTodoViewModel.swift
//  Todo
//
//  Created by Natanel Niazoff on 6/25/19.
//  Copyright © 2019 Natanel Niazoff. All rights reserved.
//

import Foundation
import Combine

final class AddTodoViewModel {
  private let connection: TodoDatabaseConnection
  private let addTodoSubscriber: AnySubscriber<Todo, Error>?
  
  var description = String() {
    didSet { canAddTodo = !description.isEmpty }
  }
  
  private var priority = Todo.Priority.low
  var priorityIndices: [Int] { Todo.Priority.allCases.map { $0.rawValue } }
  var priorityIndex: Int {
    get { priority.rawValue }
    set {
      guard let priority = Todo.Priority(rawValue: newValue) else { return }
      self.priority = priority
    }
  }
  
  private(set) var canAddTodo = false { didSet { didChange.send(self) } }
  
  let didChange = PassthroughSubject<AddTodoViewModel, Never>()
  
  private class var defaultConnection: TodoDatabaseConnection {
    do { return try TodoDatabaseConnection() }
    catch { preconditionFailure(error.localizedDescription) }
  }
  
  init(connection: TodoDatabaseConnection = AddTodoViewModel.defaultConnection,
       addTodoSubscriber: AnySubscriber<Todo, Error>? = nil) {
    self.connection = connection
    self.addTodoSubscriber = addTodoSubscriber
  }
  
  private func makeTodo() -> Todo { Todo(description: description, priority: priority) }
  
  func addTodo() throws {
    guard canAddTodo else { throw AddTodoViewModelError.cantAddTodo }
    connection.create(makeTodo())
      .receive(on: DispatchQueue.main)
      .receive(subscriber: addTodoSubscriber ?? AnySubscriber(self))
  }
  
  func priorityText(for index: Int) -> String? {
    guard let priority = Todo.Priority(rawValue: index)
      else { return nil }
    return priority.text
  }
}

extension AddTodoViewModel: Subscriber {
  typealias Input = Todo
  typealias Failure = Error
  
  func receive(subscription: Subscription) {}
  func receive(_ input: Todo) -> Subscribers.Demand { .unlimited }
  func receive(completion: Subscribers.Completion<Error>) {}
}

enum AddTodoViewModelError: Error {
  case cantAddTodo
}
