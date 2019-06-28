//
//  TodoDatabaseConnection.swift
//  Todo
//
//  Created by Natanel Niazoff on 6/23/19.
//  Copyright © 2019 Natanel Niazoff. All rights reserved.
//

import Foundation
import Combine
import SQLite

final class TodoDatabaseConnection {
  private let notificationCenter = NotificationCenter.default
  private let connection: Connection
  private let todos = Table(Constants.todosTableName)
  
  private class var defaultFilePath: String {
    FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?
      .appendingPathComponent(Constants.defaultFileName).path ?? preconditionFailure()
  }
  
  private struct TodosExpressions {
    static let id = Expression<Int>("id")
    static let description = Expression<String>("description")
    static let priority = Expression<Int>("priority")
    static let isComplete = Expression<Bool>("isComplete")
    static let createdAt = Expression<Date>("createdAt")
  }
  
  private struct Constants {
    static let defaultFileName = "Todo.db"
    static let todosTableName = "Todos"
  }
  
  init(filePath: String = TodoDatabaseConnection.defaultFilePath) throws {
    try connection = Connection(filePath)
    try connection.run(todos.create(ifNotExists: true) {
      $0.column(TodosExpressions.id, primaryKey: true)
      $0.column(TodosExpressions.description)
      $0.column(TodosExpressions.priority)
      $0.column(TodosExpressions.isComplete)
      $0.column(TodosExpressions.createdAt)
    })
  }
  
  func todosPublisher() -> AnyPublisher<[Todo], Error> {
    Publishers.Future { promise in
      do { try promise(.success(self.connection.prepare(self.todos).map { try $0.decode() })) }
      catch { promise(.failure(error)) }
    }.eraseToAnyPublisher()
  }
  
  func create(_ todo: Todo) -> AnyPublisher<Todo, Error> {
    Publishers.Future { promise in
      do {
        var todo = todo
        let id = try self.connection.run(self.todos.insert(todo))
        todo.id = Int(id)
        self.notificationCenter.post(name: .didCreateTodo, object: todo)
        promise(.success(todo))
      } catch { promise(.failure(error)) }
    }.eraseToAnyPublisher()
  }
  
  func update(_ todo: Todo) -> AnyPublisher<Void, Error> {
    Publishers.Future { promise in
      do {
        guard let id = todo.id
          else { promise(.failure(TodoDatabaseConnectionError.needSetID)); return }
        let existingTodo = self.todos.filter(TodosExpressions.id == id)
        guard try self.connection.run(existingTodo.update(todo)) > 0
          else { throw TodoDatabaseConnectionError.idNotFound }
        promise(.success(()))
      } catch { promise(.failure(error)) }
    }.eraseToAnyPublisher()
  }
  
  func delete(_ todo: Todo) -> AnyPublisher<Void, Error> {
    Publishers.Future { promise in
      do {
        guard let id = todo.id
          else { promise(.failure(TodoDatabaseConnectionError.needSetID)); return }
        let existingTodo = self.todos.filter(TodosExpressions.id == id)
        guard try self.connection.run(existingTodo.delete()) > 0
          else { throw TodoDatabaseConnectionError.idNotFound }
        promise(.success(()))
      } catch { promise(.failure(error)) }
    }.eraseToAnyPublisher()
  }
}

enum TodoDatabaseConnectionError: Error {
  case needSetID
  case idNotFound
}

extension Notification.Name {
  static let didCreateTodo = Notification.Name(rawValue: "didCreateTodo")
}
