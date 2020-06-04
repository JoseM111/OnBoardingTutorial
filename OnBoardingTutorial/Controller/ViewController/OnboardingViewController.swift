import Foundation
import paper_onboarding//<<-- Already imports UIKit

protocol OnboardingViewControllerDelegate: class {
    func controllerWantsToDismiss(_ controller: OnboardingViewController)
}

class OnboardingViewController: UIViewController {
    // MARK: @Properties
    /**©------------------------------------------------------------------------------©*/
    weak var onboardingDelegate: OnboardingViewControllerDelegate?
    internal var onboardingItems: [OnboardingItemInfo] = []
    
    /*-------------------------------------------------------
     PaperOnboarding():--? An instance of PaperOnboarding
     which display collection of information.
     -------------------------------------------------------*/
    internal var onboardingView = PaperOnboarding()
    
    
    internal let getStartedBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Get Started", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        btn.addTarget(self, action: #selector(dismissOB), for: .touchUpInside)
        
        return btn
    }()
    /**©------------------------------------------------------------------------------©*/
    
    // MARK: -#LifeCycle-method
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureOnboardingDataSRC()
    }
    
    // This only works if your view is not embedded inside a nav bar
    // Makes your time, wifi & battery life look a certain color
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    // MARK: -#Selector
    /**©---------------------------------------------©*/
    @objc func dismissOB() {
        /*-------------------------------------------------------
         Forwards the user from the onboarding screens To the
         login screen. Either the is logged in screen or the
         login/create user screen if the user is not login or
         does not have an account.
         -------------------------------------------------------*/
        onboardingDelegate?.controllerWantsToDismiss(self)
        printf("DEBUG: SUCCESSFULLY LOGGED IN!\nForwarded to user home screen...")
    }
    /**©---------------------------------------------©*/
    
    // MARK: -#Helper-method
    /**©------------------------------------------------------------------------------©*/
    
    // MARK: _@configureUI()-->> Helper:animateGetStartedBtn(_ shouldShow: Bool)
    /**©---------------------------------------------©*/
    func configureUI() {
        addAllSubViews(obj1: onboardingView, obj2: getStartedBtn)
        onboardingView.fillSuperview()
        
        // Constraining our button on the onboarding view
        getStartedBtn.alpha = 0
        getStartedBtn.centerX(inView: view)
        getStartedBtn.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingBottom: 128)

        /*-------------------------------------------------------
          The object that acts as the delegate of the PaperOnboarding.
          PaperOnboardingDelegate protocol
          @IBOutlet weak open var delegate: AnyObject?
          -------------------------------------------------------*/
        onboardingView.delegate = self
    }
    
    // Helper to animate our get started button
    func animateGetStartedBtn(_ shouldShow: Bool) {
        // if alpha = 1 it should show button
        // if alpha = 0 it should not show button
        let alpha: CGFloat = shouldShow ? 1 : 0
        UIView.animate(withDuration: 0.5) {
            self.getStartedBtn.alpha = alpha
        }
    }
    /**©---------------------------------------------©*/
    
    // MARK: _@configureOnboardingDataSRC()-->> Helper:obScreen()
    /**©---------------------------------------------©*/
    func configureOnboardingDataSRC() {
        // Creating our items
        // MARK: -#Metrics-Onboarding screen
        let _ = obScreen(infoImg: #imageLiteral(resourceName: "baseline_insert_chart_white_48pt").withRenderingMode(.alwaysOriginal), title: MSG_METRIC,
                 desc: MSG_ONBOARDING_METRICS, color: .systemPurple,
                 titleColor: .white, descColor: .white,
                 titleFont: UIFont.boldSystemFont(ofSize: 24), descFont: UIFont.systemFont(ofSize: 16))
        
        // MARK: -#Notifications-Onboarding screen
        let _ = obScreen(infoImg: #imageLiteral(resourceName: "baseline_notifications_active_white_48pt").withRenderingMode(.alwaysOriginal), title: MSG_NOTIFICATIONS,
                 desc: MSG_ONBOARDING_NOTIFICATIONS, color: .systemBlue,
                 titleColor: .white, descColor: .white,
                 titleFont: UIFont.boldSystemFont(ofSize: 24), descFont: UIFont.systemFont(ofSize: 16))
        
        // MARK: -#Dash-Onboarding screen
        let _ = obScreen(infoImg: #imageLiteral(resourceName: "baseline_dashboard_white_48pt").withRenderingMode(.alwaysOriginal), title: MSG_DASHBOARD,
                 desc: MSG_ONBOARDING_DASHBOARD, color: .systemTeal,
                 titleColor: .white, descColor: .white,
                 titleFont: UIFont.boldSystemFont(ofSize: 24), descFont: UIFont.systemFont(ofSize: 16))
        
        onboardingView.dataSource = self
        onboardingView.reloadInputViews()
    }
    
    // Helper-method to configureOnboardingDataSRC()
    // Adds the onboarding view with image and styling
    func obScreen(infoImg: UIImage, title: String, desc: String, color: UIColor, titleColor: UIColor, descColor: UIColor, titleFont: UIFont, descFont: UIFont) -> OnboardingItemInfo {
        
        let result = OnboardingItemInfo(informationImage: infoImg,  title: title, description: desc, pageIcon: UIImage(), color: color, titleColor: titleColor, descriptionColor: .white, titleFont: titleFont, descriptionFont: descFont)
        
        onboardingItems.append(result)
        return result
    }
    /**©---------------------------------------------©*/

    /**©------------------------------------------------------------------------------©*/
}// END OF CLASS
