import UIKit
import Firebase

class HomeViewController: UIViewController {
    // MARK: @Properties
    /**©------------------------------------------------------------------------------©*/
    /*-------------------------------------------------------
     This property is saying we want to do
     somethings, once this property gets set!
      -------------------------------------------------------*/
    internal var user: User? {
        didSet {
            presentOnboardingControllerIfNecessary()
            // Once our user is set we run showWelcomeLbl()
            showWelcomeLbl()
        }
    }

    internal var welcomeLbl: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.font = UIFont.systemFont(ofSize: 32)

        // Initially hides the full name of the user
        // then showWelcomeLbl() shows the full name
        lbl.text = "Welcome user..."
        lbl.alpha = 0
        return lbl
    }()
    /**©------------------------------------------------------------------------------©*/

    // MARK: -#Lifecycle-method
    override func viewDidLoad() {
        super.viewDidLoad()
        // You want to authenticate the user first
        authUser()
        // Then configure the UI
        configureUI()
    }

    // MARK: -#Selector
    @objc func handleLogOut() {
        /*-------------------------------------------------------
         preferredStyle: .actionSheet
         -------------------------------------------------------
         Use an action sheet to present the user with a set of
         alternatives for how to proceed with a given task.
         -------------------------------------------------------*/
        let alert = UIAlertController(title: nil, message: "Are you sure you want to log out?", preferredStyle: .actionSheet)
        // style: .destructive
        // Applies a style that indicates the action might change or delete data.
        alert.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { (_) in
            self.logOut()
        }))

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    // MARK: - Helper-methods
    func configureUI() {
        configureGradientBackGround()

        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.barStyle = .black
        navigationItem.title = "Firebase Login"

        // MARK: - Creating our log out button
        let img = UIImage(systemName: "arrow.left")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: img, style: .plain, target: self, action: #selector(handleLogOut))
        // Changes back button tint to white
        navigationItem.leftBarButtonItem?.tintColor = .white

        view.addSubview(welcomeLbl)
        welcomeLbl.centerX(inView: view)
        welcomeLbl.centerY(inView: view)
    }

    internal func showWelcomeLbl() {
        guard let user = user,
                user.hasSeenOnboarding else { return }

        welcomeLbl.text = "Welcome \(user.fullName)"
        UIView.animate(withDuration: 1) { () -> Void in
            self.welcomeLbl.alpha = 1
        }
    }

    internal func presentLogInController() {
        let loginVC = LoginViewController()
        // So when the delegate is called, it actually has a value
        loginVC.authDelegate = self

        let nav = UINavigationController(rootViewController: loginVC)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
    }

    internal func presentOnboardingControllerIfNecessary() {
        // Making sure the user exist.
        guard let user = user,
              // Making sure the user has not seen the onboarding
              !user.hasSeenOnboarding else { return }

        // If they have not seen the onboarding we will present it
        let onboardingVC = OnboardingViewController()
        onboardingVC.onboardingDelegate = self
        onboardingVC.modalPresentationStyle = .fullScreen
        present(onboardingVC, animated: true, completion: nil)
    }

    // MARK: -#API-->> Conducts a authentication check to see if the user is logged on or not.
    // If not loggged on the user will be redirected to the log on view.
    /**©------------------------------------------------------------------------------©*/
    func fetchUser() {
        Service.fetchUser { (user: User) in
            self.user = user
        }
    }

    func fetchUserWithFirestore() {
        Service.fetchUserWithFirestore { user in
            self.user = user
        }
    }
    /**©------------------------------------------------------------------------------©*/

    func authUser() {
        if Auth.auth().currentUser?.uid == nil {

            // MARK: - Has to be on main thread
            /**©---------------------------------------------©*/
            DispatchQueue.main.async {
                // Will present log in screen if user is not logged in
                self.presentLogInController()
            }
            /**©---------------------------------------------©*/

            printf("DEBUG: User not logged in...\nDEBUG: Redirected to Login View...")
        } else {
//            fetchUser()<<-- Firebase
        fetchUserWithFirestore()//<<-- FireStore
        }
    }

    func logOut() {
        do {
            try Auth.auth().signOut()//<<-- Signs out the current user.{Firebase}
            // The logout controller is in the do catch just in case there
            // is an error logging in. So it will not show if an error is present.
            self.presentLogInController()
            printf("DEBUG: User logged out...")
        } catch {
            printf("DEBUG: Error signing out..-->> \(error.localizedDescription)")
        }
    }
}// END OF CLASS
