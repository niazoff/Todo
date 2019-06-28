//
//  HomeView.swift
//  Todo
//
//  Created by Natanel Niazoff on 6/25/19.
//  Copyright © 2019 Natanel Niazoff. All rights reserved.
//

import SwiftUI
import SFSafeSymbols

struct HomeView: View {
  let todosViewModel: TodosViewModel
  let addTodoView: AnyView
  
  private struct Constants {
    static let navigationBarTitle = "Todos"
    static let plusCircleFontSize: Length = 22
  }
  
  var body: some View {
    NavigationView {
      TodosView(viewModel: todosViewModel)
        .navigationBarTitle(Text(verbatim: Constants.navigationBarTitle))
        .navigationBarItems(trailing: PresentationButton(destination: addTodoView) {
          Image(systemSymbol: .plusCircle)
            .font(.system(size: Constants.plusCircleFontSize))
        })
    }
  }
}

#if DEBUG
struct HomeView_Previews: PreviewProvider {
  static let todosViewModel = TodosViewModel()
  static let addTodoViewModel = AddTodoViewModel()
  
  static var previews: some View {
    HomeView(todosViewModel: todosViewModel, addTodoView: AnyView(AddTodoView(viewModel: addTodoViewModel)))
  }
}
#endif
