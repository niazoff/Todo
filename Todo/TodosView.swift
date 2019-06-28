//
//  TodosView.swift
//  Todo
//
//  Created by Natanel Niazoff on 6/23/19.
//  Copyright © 2019 Natanel Niazoff. All rights reserved.
//

import SwiftUI

struct TodosView: View {
  @ObjectBinding var viewModel: TodosViewModel
  
  var body: some View {
    List {
      ForEach(viewModel.todoViewModels) { TodoView(viewModel: $0) }
        .onDelete(perform: viewModel.deleteTodoViewModels)
    }
  }
}

extension TodosViewModel: BindableObject {}

#if DEBUG
struct TodosView_Previews: PreviewProvider {
  static let viewModel = TodosViewModel()
  
  static var previews: some View {
    TodosView(viewModel: viewModel)
  }
}
#endif
