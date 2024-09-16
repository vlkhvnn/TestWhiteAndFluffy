import UIKit

final class MainTabBarViewController: UITabBarController {
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBars()
    }
    
    // MARK: - Private Methods
    
    private func setupTabBars() {
        let vc1 = HomeViewController()
        let homeInteractor = HomeInteractor()
        vc1.interactor = homeInteractor
        let vc2 = FavoritesViewController()
        
        let tabbar1 = UINavigationController(rootViewController: vc1)
        let tabbar2 = UINavigationController(rootViewController: vc2)
        tabbar1.tabBarItem.image = UIImage(systemName: "house")
        tabbar2.tabBarItem.image = UIImage(systemName: "heart")
        
        tabbar1.title = "Home"
        tabbar2.title = "Favorites"
        
        setViewControllers([tabbar1, tabbar2], animated: true)
    }
}
