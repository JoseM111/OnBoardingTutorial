import UIKit
import Firebase

class RegistrationViewController: UIViewController {

    // MARK: -#Singleton-registrationViewModel
    internal var registrationViewModel = RegistrationViewModel()
    // MARK: #Delegate for AuthDelegate
    weak var authDelegate: AuthDelegate?

    // MARK: _@Outlet-properties
    /**©------------------------------------------------------------------------------©*/
    // MARK: -#Icon image
    private let iconImg = UIImageView(image:#imageLiteral(resourceName: "firebase-logo"))

    // MARK: -#emailTextField Property
    private let emailTextField = CustomTextField(placeHolder: "Enter Email...")
    private let fullNameTextField = CustomTextField(placeHolder: "Enter Full Name...")

    // MARK: -#passwordField Computed-Property
    private let passwordField: CustomTextField = {
        let tf = CustomTextField(placeHolder: "Enter Password...")
        tf.isSecureTextEntry = true

        return tf
    }()

    // MARK: -#loginButton Computed-Property
    internal let signUpButton: AuthButton  = {
        let btn = AuthButton(type: .system)
        btn.title = "Sign Up"
        btn.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)

        return btn
    }()

    private let alreadyHaveAccountButton: UIButton = {
        let btn = UIButton(type: .system)
        // Setting up an attributed title
        let atts: [NSAttributedString.Key : Any] = [.foregroundColor: UIColor(white: 1, alpha: 0.87), .font: UIFont.boldSystemFont(ofSize: 16)]
        let attributedTitle = NSMutableAttributedString(string: "Already have  an account? ", attributes: atts)

        let boldAtts: [NSAttributedString.Key : Any] = [.foregroundColor: UIColor(white: 1, alpha: 0.87), .font: UIFont.boldSystemFont(ofSize: 15)]
        attributedTitle.append(NSAttributedString(string: "Log In", attributes: boldAtts))

        btn.setAttributedTitle(attributedTitle, for: .normal)
        btn.addTarget(self , action: #selector(showLoginController), for: .touchUpInside)
        return btn
    }()

    // MARK: -#Selector methods
    /**©------------------------------------------------------------------------------©*/
    @objc func handleSignUp() {
        guard let email = emailTextField.text,
              let password = passwordField.text,
              let fullName = fullNameTextField.text else { return }

        // You want to implement the showLoader function here,
        // because you want to make sure you have values first
        showLoader(true)

        // MARK: #Service.registerUserWithFirebase
//        Service.registerUserWithFirebase(email: email, pwd: password, fullName: fullName) { (error, _) in
//            // Once the process of login completes,
//            // it will hide the loader no matter what
//            self.showLoader(false)
//
//            if let error = error {
//                return self.showMsgAlert(withTitle: "Error", message: error.localizedDescription, titleAction: "OK")
//            }
//
//            self.authDelegate?.AuthComplete()
//
//            printf("""
//                   DEBUG-->handleSignUp() for Firebase:
//                      SUCCESSFUL: New User Created:
//                      ⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇
//                   -------------------------------
//                   Email: \(email)
//                   Password: \(password)
//                   Full Name: \(fullName)
//                   """)
//        }

        // MARK: #Service.registerUserWithFirebase
        Service.registerUserWithFireStore(email: email, pwd: password, fullName: fullName) { error in
            // Once the process of login completes,
            // it will hide the loader no matter what
            self.showLoader(false)

            if let error = error {
                return self.showMsgAlert(withTitle: "Error", message: error.localizedDescription, titleAction: "OK")
            }

            self.authDelegate?.AuthComplete()

            printf("""
                   DEBUG-->handleSignUp() for FireStore:
                      SUCCESSFUL: New User Created:
                      ⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇
                   -------------------------------
                   Email: \(email)
                   Password: \(password)
                   Full Name: \(fullName)
                   """)
        }
    }/// END OF FUNC

    @objc func showLoginController() {
        // Segues back and forth from one view controller to another
        navigationController?.popViewController(animated: true)
    }

    @objc func txtDidChange(_ sender: UITextField) {
        // Differentiate from email and password
        if sender == emailTextField {
            registrationViewModel.email = sender.text
        } else if sender == passwordField {
            registrationViewModel.password = sender.text
        } else {
            registrationViewModel.fullName = sender.text
        }

        updateForm()
    }
    /**©------------------------------------------------------------------------------©*/

    // MARK: -#Lifecycle method
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configNotificationObservers()
    }

    // MARK: -#Configure-UI
    func configureUI() {
        configureGradientBackGround()
        addAllSubViews(obj1: iconImg, obj2: alreadyHaveAccountButton)
        imgConstraints(obj: iconImg, ht: 120, wt: 120, paddingTop: 32)
        /**©---------------------------------------------©*/

        let vStack = UIStackView(arrangedSubviews: [
            emailTextField, passwordField, fullNameTextField, signUpButton
        ])
        createVStack(vStack: vStack, obj: iconImg, spacing: 20, paddingTop: 32, paddingLeft: 32, paddingRight: 32)

        alreadyHaveAccountButton.centerX(inView: view)
        // Anchoring the dontHaveAccountButton to the bottom of the view
        alreadyHaveAccountButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingBottom: 16)
    }

    // MARK: _@configNotificationObservers
    /**©-------------------------------------------©*/
    func configNotificationObservers() {
        emailTextField.addTarget(self, action: #selector(txtDidChange), for: .editingChanged)
        passwordField.addTarget(self, action: #selector(txtDidChange), for: .editingChanged)
        fullNameTextField.addTarget(self, action: #selector(txtDidChange), for: .editingChanged)
    }
    /**©-------------------------------------------©*/
}// END OF CLASS
