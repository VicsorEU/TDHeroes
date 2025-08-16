//
//  SceneDelegate.swift
//  TDHeroes
//
//  Created by alexsandr on 16.08.2025.
//


import UIKit
import SpriteKit

/// SceneDelegate отвечает за создание окна на iOS 13+
/// Мы НЕ используем storyboard, поэтому создаём корневой контроллер программно.
final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }

        let window = UIWindow(windowScene: windowScene)
        // Наш корневой контроллер — GameViewController (SpriteKit)
        window.rootViewController = GameViewController()
        self.window = window
        window.makeKeyAndVisible()
    }

    // Остальные методы оставляем пустыми — не нужны для старта игры
    func sceneDidDisconnect(_ scene: UIScene) {}
    func sceneDidBecomeActive(_ scene: UIScene) {}
    func sceneWillResignActive(_ scene: UIScene) {}
    func sceneWillEnterForeground(_ scene: UIScene) {}
    func sceneDidEnterBackground(_ scene: UIScene) {}
}
