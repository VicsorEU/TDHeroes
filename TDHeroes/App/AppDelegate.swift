import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    // Для iOS 13+ окно создаёт SceneDelegate, поэтому здесь ничего не делаем.
    // Для iOS 12- создадим окно вручную.
    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {

        if #available(iOS 13.0, *) {
            // Ничего — SceneDelegate возьмёт на себя создание окна.
        } else {
            let window = UIWindow(frame: UIScreen.main.bounds)
            window.rootViewController = GameViewController()
            window.makeKeyAndVisible()
            self.window = window
        }
        return true
    }

    // MARK: UISceneSession Lifecycle (iOS 13+)
    @available(iOS 13.0, *)
    func application(_ application: UIApplication,
                     configurationForConnecting connectingSceneSession: UISceneSession,
                     options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        let cfg = UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
        cfg.delegateClass = SceneDelegate.self // <— важно: наш SceneDelegate
        return cfg
    }
}
