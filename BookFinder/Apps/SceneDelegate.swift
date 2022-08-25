//
//  SceneDelegate.swift
//  BookFinder
//
//  Created by Kang Byeonghak on 2022/08/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  var window: UIWindow?

  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let scene = (scene as? UIWindowScene) else { return }
    
    let content = BookFinderViewController()
    let navigation = UINavigationController(rootViewController: content)
    
    window = UIWindow(windowScene: scene)
    window?.rootViewController = navigation
    window?.makeKeyAndVisible()
  }
}

