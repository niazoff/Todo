//
//  TodosViewModel.swift
//  Todo
//
//  Created by Natanel Niazoff on 6/25/19.
//  Copyright © 2019 Natanel Niazoff. All rights reserved.
//

import Foundation
import Combine

final class TodosViewModel {
  private let notificationCenter = NotificationCenter.default
  private let connection: TodoDatabaseConnection
  
  var todoViewModels = [TodoViewModel]() { didSet { didChange.send(self) } }
  
  private var todosCancellable: AnyCancellable?
  private var didCreateTodoCancellable: AnyCancellable?
  
  let didChange = PassthroughSubject<TodosViewModel, Never>()
  
  private class var defaultConnection: TodoDatabaseConnection {
    do { return try TodoDatabaseConnection() }
    catch { preconditionFailure(error.localizedDescription) }
  }
  
  init(connection: TodoDatabaseConnection = TodosViewModel.defaultConnection) {
    self.connection = connection
    
    todosCancellable = connection.todosPublisher()
      .receive(on: DispatchQueue.main)
      .replaceError(with: [])
      .map { $0.map(self.makeTodoViewModel).sorted() }
      .assign(to: \.todoViewModels, on: self)
    
    didCreateTodoCancellable = AnyCancellable(notificationCenter.publisher(for: .didCreateTodo)
      .receive(on: DispatchQueue.main)
      .map { $0.object as? Todo }
      .sink(receiveValue: receive))
  }
  
  private func makeTodoViewModel(todo: Todo) -> TodoViewModel {
    let viewModel = TodoViewModel(connection: connection, todo: todo)
    viewModel.didCompleteTodo = { [weak self] _ in self?.todoViewModels.sort() }
    return viewModel
  }
  
  private func receive(_ newTodo: Todo?) {
    guard let todo = newTodo else { return }
    todoViewModels.insert(makeTodoViewModel(todo: todo), at: 0)
    todoViewModels.sort()
  }
  
  func deleteTodoViewModels(at indices: IndexSet) {
    let deletes = indices.map { self.todoViewModels[$0].delete() }
    _ = Publishers.MergeMany(deletes)
      .sink { self.todoViewModels.remove(at: indices) }
  }
}
