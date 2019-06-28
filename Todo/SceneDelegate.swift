//
//  SceneDelegate.swift
//  Todo
//
//  Created by Natanel Niazoff on 6/23/19.
//  Copyright © 2019 Natanel Niazoff. All rights reserved.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  var window: UIWindow?
  
  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    if let windowScene = scene as? UIWindowScene {
      let window = UIWindow(windowScene: windowScene)
      let todosViewModel = TodosViewModel()
      let addTodoViewModel = AddTodoViewModel()
      window.rootViewController = UIHostingController(rootView: HomeView(todosViewModel: todosViewModel, addTodoView: AnyView(AddTodoView(viewModel: addTodoViewModel))))
      self.window = window
      window.makeKeyAndVisible()
    }
  }
}
