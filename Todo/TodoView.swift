//
//  TodoView.swift
//  Todo
//
//  Created by Natanel Niazoff on 6/25/19.
//  Copyright © 2019 Natanel Niazoff. All rights reserved.
//

import SwiftUI

struct TodoView: View {
  @ObjectBinding var viewModel: TodoViewModel
  
  private struct Constants {
    static let checkmarkCircleFontSize: Length = 22
    static let textFontSize: Length = 20
  }
  
  var body: some View {
    HStack {
      Button(action: { self.viewModel.isComplete.toggle() }) {
        Image(systemSymbol: viewModel.isComplete ? .checkmarkCircleFill : .checkmarkCircle)
          .font(.system(size: Constants.checkmarkCircleFontSize))
          .foregroundColor(viewModel.isComplete ? .green : .gray)
      }
      TextField($viewModel.text)
        .font(.system(size: Constants.textFontSize))
      Spacer()
      Text(verbatim: viewModel.priorityText)
        .font(.system(size: Constants.textFontSize))
        .bold()
        .color(.gray)
    }.padding([.top, .bottom])
  }
}

extension TodoViewModel: Identifiable {}
extension TodoViewModel: BindableObject {}

#if DEBUG
struct TodoView_Previews: PreviewProvider {
  static let viewModel = TodoViewModel(todo: Todo(description: "Hello World"))
  
  static var previews: some View {
    TodoView(viewModel: viewModel)
  }
}
#endif
