//
//  AddTodoView.swift
//  Todo
//
//  Created by Natanel Niazoff on 6/25/19.
//  Copyright © 2019 Natanel Niazoff. All rights reserved.
//

import SwiftUI
import Combine

struct AddTodoView: View {
  @ObjectBinding var viewModel: AddTodoViewModel
  
  @Environment(\.isPresented) var isPresented: Binding<Bool>?
  
  private struct Constants {
    static let navigationBarTitle = "Add Todo"
    static let descriptionTextFieldPlaceholder = "Add a description..."
    static let addTodoButtonText = "Done"
  }
  
  var body: some View {
    NavigationView {
      Form {
        TextField($viewModel.description, placeholder: Text(verbatim: Constants.descriptionTextFieldPlaceholder))
          .padding([.top, .bottom])
        SegmentedControl(selection: $viewModel.priorityIndex) {
          ForEach(viewModel.priorityIndices) { Text(verbatim: self.viewModel.priorityText(for: $0) ?? String()) }
        }
      }.navigationBarItems(trailing: Button(action: addTodoButtonAction) {
          Text(verbatim: Constants.addTodoButtonText).bold()
        }.disabled(!viewModel.canAddTodo))
        .navigationBarTitle(Text(verbatim: Constants.navigationBarTitle))
    }
  }
  
  private func addTodoButtonAction() {
    do {
      try viewModel.addTodo()
      isPresented?.value = false
    }
    catch { print(error.localizedDescription) }
  }
}

extension AddTodoViewModel: BindableObject {}

#if DEBUG
struct AddTodoView_Previews: PreviewProvider {
  static let viewModel = AddTodoViewModel()
  
  static var previews: some View {
    AddTodoView(viewModel: viewModel)
  }
}
#endif
