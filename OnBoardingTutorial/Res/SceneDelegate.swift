import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        
        /*-------------------------------------------------------
         var rootViewController: UIViewController? { get set }
         ------------------------------------------------------
         The root view controller provides the content view of
         the window. Assigning a view controller to this property
         (either programmatically or using Interface Builder)
         installs the view controller’s view as the content view
         of the window. The new content view is configured to
         track the window size, changing as the window size
         changes. If the window has an existing view hierarchy,
         the old views are removed before the new ones are installed.
         ------------------------------------------------------
         class UINavigationController : UIViewController
         ------------------------------------------------------
         A navigation controller is a container view controller
         that manages one or more child view controllers in a
         navigation interface. In this type of interface, only
         one child view controller is visible at a time. Selecting
         an item in the view controller pushes a new view controller
         onscreen using an animation, thereby hiding the previous
         view controller. Tapping the back button in the navigation
         bar at the top of the interface removes the top view
         controller, thereby revealing the view controller underneath.
         -------------------------------------------------------*/
//        window?.rootViewController = OnboardingViewController()
        window?.rootViewController = UINavigationController(rootViewController: HomeViewController())
        // func makeKeyAndVisible():--? Shows the window and makes it the key window.
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

