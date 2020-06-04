import UIKit
import Firebase
import GoogleSignIn

protocol AuthDelegate: class {
    func AuthComplete()
}

class LoginViewController: UIViewController {
    
    // MARK: -#Singleton-LoginViewModel
    internal var loginViewModel = LoginViewModel()
    // MARK: #Delegate for AuthDelegate
    weak var authDelegate: AuthDelegate?
    
    // MARK: _@Outlet-properties
    /**©------------------------------------------------------------------------------©*/
    // MARK: -#Icon image
    private let iconImg = UIImageView(image:#imageLiteral(resourceName: "firebase-logo"))
    
    // MARK: -#emailTextField Property
    private let emailTextField = CustomTextField(placeHolder: "Enter Email...")
    
    // MARK: -#passwordField Computed-Property
    private let passwordField: CustomTextField = {
        let tf = CustomTextField(placeHolder: "Enter Password...")
        tf.isSecureTextEntry = true
        
        return tf
    }()
    
    // MARK: -#loginButton Computed-Property
    internal let loginButton: AuthButton  = {
        let btn = AuthButton(type: .system)
        btn.title = "Login"
        btn.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        
        return btn
    }()
    
    private let forgotPWButton: UIButton = {
        let btn = UIButton(type: .system)
        
        // Setting up an attributed title
        let atts: [NSAttributedString.Key : Any] = [.foregroundColor: UIColor(white: 1, alpha: 0.87), .font: UIFont.boldSystemFont(ofSize: 15)]
        let attributedTitle = NSMutableAttributedString(string: "Forgot your password? ", attributes: atts)
        
        let boldAtts: [NSAttributedString.Key : Any] = [.foregroundColor: UIColor(white: 1, alpha: 0.87), .font: UIFont.boldSystemFont(ofSize: 15)]
        attributedTitle.append(NSAttributedString(string: "Get help signing in.", attributes: boldAtts))
        
        /*-------------------------------------------------------
         func setAttributedTitle(_ title: NSAttributedString?, for state: UIControl.State)
         -------------------------------------------------------
         Use this method to set the title of the button, including
         any relevant formatting information. If you set both a
         title and an attributed title for the button, the button
         prefers the use of the attributed title. At a minimum,
         you should set the value for the normal state. If a title
         is not specified for a state, the default behavior is to
         use the title associated with the normal state. If the
         value for normal is not set, then the property defaults
         to a system value.
         -------------------------------------------------------*/
        btn.setAttributedTitle(attributedTitle, for: .normal)
        
        btn.addTarget(self , action: #selector(showForgotPW), for: .touchUpInside)
        return btn
    }()
    
    private let dividerView = DividerView()
    
    private let googleLoginButton: UIButton = {
        let btn = UIButton()
        btn.setImage(#imageLiteral(resourceName: "btn_google_light_pressed_ios").withRenderingMode(.alwaysOriginal), for: .normal)
        btn.setTitle("  Log in with Google", for: .normal)
        
        btn.setTitleColor(.white, for: .normal)
        // Accessing the font, setting it to bold & giving the font a size
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        btn.addTarget(self, action: #selector(handleGoogleLogin), for: .touchUpInside)
        
        
        return btn
    }()
    
    private let dontHaveAccountButton: UIButton = {
        let btn = UIButton(type: .system)
        // Setting up an attributed title
        let atts: [NSAttributedString.Key : Any] = [.foregroundColor: UIColor(white: 1, alpha: 0.87), .font: UIFont.boldSystemFont(ofSize: 16)]
        let attributedTitle = NSMutableAttributedString(string: "Don't have account? ", attributes: atts)
        
        let boldAtts: [NSAttributedString.Key : Any] = [.foregroundColor: UIColor(white: 1, alpha: 0.87), .font: UIFont.boldSystemFont(ofSize: 15)]
        attributedTitle.append(NSAttributedString(string: "Sign Up", attributes: boldAtts))
        
        btn.setAttributedTitle(attributedTitle, for: .normal)
        btn.addTarget(self , action: #selector(showRegistrationViewController), for: .touchUpInside)
        return btn
    }()
    /**©------------------------------------------------------------------------------©*/
    
    // MARK: -#Life-Cycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        // DEFAULT BACKGROUND COLOR
        //        view.backgroundColor = .systemPurple
        updateUI()
        configNotificationObservers()
        configureGoogleSignIn()
    }
    
    // MARK: _@Selectors @obj
    /**©---------------------------------------------©*/
    
    @objc func handleLogin() {
        guard let email = emailTextField.text,
              let password = passwordField.text else { return }

        showLoader(true)
        
        // MARK: _@Handling the user login
        /**©---------------------------------------------©*/
        Service.logUserInWith(email: email, pwd: password) { (_, error) in
            // Once the process of login completes,
            // it will hide the loader no matter what
            self.showLoader(false)

            // - Handling error
            if let error = error {
                return self.showMsgAlert(withTitle: "Error", message: error.localizedDescription, titleAction: "OK")
            }

            // If there is no error it will
            // complete the authentication process
            self.authDelegate?.AuthComplete()
            printf("Login was successful...")
        }
        /**©---------------------------------------------©*/
    }/// END OF FUNC
    
    @objc func showForgotPW() {
        let resetPWDVC = ResetPasswordViewController()
        resetPWDVC.email = emailTextField.text
        resetPWDVC.resetPasswordViewControllerDelegate = self

        // Will segue to the ResetPasswordViewController when the button is pressed
        navigationController?.pushViewController(resetPWDVC, animated: true)
    }
    
    @objc func handleGoogleLogin() {
        GIDSignIn.sharedInstance()?.signIn()
        printf("DEBUG: Handling google login...")
    }
    
    @objc func showRegistrationViewController() {
        let registrationVC = RegistrationViewController()
        registrationVC.authDelegate = authDelegate
        navigationController?.pushViewController(registrationVC, animated: true)
    }
    
    @objc func txtDidChange(_ sender: UITextField) {
        
        // Differentiate from email and password
        if sender == emailTextField {
            loginViewModel.email = sender.text
        } else {
            loginViewModel.password = sender.text
        }
        
        printf("DEBUG: Form is valid \(loginViewModel.formIsValid)")
        updateForm()
    }
    /**©---------------------------------------------©*/
    
    // MARK: _@Helper-methods
    /**©------------------------------------------------------------------------------©*/
    // MARK: -#updateUI()->>Setup gradient layer
    func updateUI() {
        // Hiding our navigation bar
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
        configureGradientBackGround()// Extension
        
        addAllSubViews(obj1: iconImg, obj2: dontHaveAccountButton)
        imgConstraints(obj: iconImg, ht: 120, wt: 120, paddingTop: 32)
        
        // MARK: -#vStack-vStack2
        /**©---------------------------------------------©*/
        let vStack = UIStackView(arrangedSubviews: [ emailTextField, passwordField, loginButton ])
        createVStack(vStack: vStack, obj: iconImg, spacing: 20, paddingTop: 32, paddingLeft: 32, paddingRight: 32)
        
        let vStack2 = UIStackView(arrangedSubviews: [ forgotPWButton, dividerView, googleLoginButton ])
        createVStack(vStack: vStack2, obj: vStack, spacing: 28, paddingTop: 24, paddingLeft: 32, paddingRight: 32)
        /**©---------------------------------------------©*/
        
        /**©---------------------------------------------©*/
        dontHaveAccountButton.centerX(inView: view)
        // Anchoring the dontHaveAccountButton to the bottom of the view
        dontHaveAccountButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingBottom: 16)
    }
    
    // MARK: _@configNotificationObservers
    /**©-------------------------------------------©*/
    func configNotificationObservers() {
        emailTextField.addTarget(self, action: #selector(txtDidChange), for: .editingChanged)
        passwordField.addTarget(self, action: #selector(txtDidChange), for: .editingChanged)
    }
    
    // MARK: _@configureGoogleSignIn
    /**©-------------------------------------------©*/
    func configureGoogleSignIn() {
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.delegate = self
        
    }
    /**©------------------------------------------------------------------------------©*/
}// END OF CLASS
