import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }

        let sharedViewModel = CurrencyRatesViewModel()

        let allVC = CurrencyRatesViewController(viewModel: sharedViewModel)
        allVC.tabBarItem = UITabBarItem(title: "All", image: UIImage(systemName: "list.bullet"), tag: 0)

        let favVC = CurrencyRatesViewController(viewModel: sharedViewModel, isFavoritesOnly: true)
        favVC.tabBarItem = UITabBarItem(title: "Favorites", image: UIImage(systemName: "star.fill"), tag: 1)

        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [
            UINavigationController(rootViewController: allVC),
            UINavigationController(rootViewController: favVC)
        ]

        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = tabBarController
        self.window = window
        window.makeKeyAndVisible()
    }
}
