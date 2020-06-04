import UIKit

protocol ResetPasswordViewControllerDelegate: class {
    func didSendResetPWDLink()
}

class ResetPasswordViewController: UIViewController {

    // MARK: -#Singleton-
    internal var resetPWViewModel = ResetPWViewModel()
    // MARK: #resetPasswordViewControllerDelegate
    weak var resetPasswordViewControllerDelegate: ResetPasswordViewControllerDelegate?

    // MARK: @Properties
    /**©---------------------------------------------©*/
    // MARK: #email: String?
    var email: String?

    // MARK: -#Icon image
    private let iconImg = UIImageView(image:#imageLiteral(resourceName: "firebase-logo"))
    
    // MARK: -#emailTextField Property
    private let emailTextField = CustomTextField(placeHolder: "Enter Email...")
    
    // MARK: -#loginButton Computed-Property
    internal let resetPWButton: AuthButton  = {
        let btn = AuthButton(type: .system)
        btn.title = "Send Reset Link"
        btn.addTarget(self, action: #selector(handleResetPW), for: .touchUpInside)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        
        return btn
    }()
    
    private let backButton: UIButton  = {
        let btn = UIButton(type: .system)
        btn.tintColor = .white
        btn.addTarget(self, action: #selector(handleDismissal), for: .touchUpInside)
        btn.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        
        return btn
    }()
    /**©---------------------------------------------©*/
    
    // MARK: -#LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configNotificationObservers()
        loadEmail()
    }
    // MARK: _#Selector Helper-methods
    /**©------------------------------------------------------------------------------©*/
    @objc func handleResetPW() {
        guard let email = resetPWViewModel.email else { return }

        showLoader(true)

        Service.resetPWD(forEmail: email) { error in
            // Once the process of login completes,
            // it will hide the loader no matter what
            self.showLoader(false)

            if let error = error {
                return self.showMsgAlert(withTitle: "Error", message: error.localizedDescription, titleAction: "OK")
            }

            self.resetPasswordViewControllerDelegate?.didSendResetPWDLink()
        }
    }
    
    @objc func handleDismissal() {
        // Will pop back from the current view to the last view
        navigationController?.popViewController(animated: true)
    }

    @objc func txtDidChange(_ sender: UITextField) {
        // Differentiate from email and password
        if sender == emailTextField { resetPWViewModel.email = sender.text }
        updateForm()
    }
    /**©------------------------------------------------------------------------------©*/

    // MARK: -#configureUI-method
    func configureUI() {
        configureGradientBackGround()
        
        // MARK: -#Back Button added to view & constrained
        addAllSubViews(obj1: iconImg, obj2: backButton)

        // MARK: -#Adding our image to the constraints to our image
        /**©---------------------------------------------©*/
        imgConstraints(obj: iconImg, ht: 120, wt: 120, paddingTop: 32)
        // MARK: -#[vertical-stackviews] Adding our outlets to a [array]
        /**©---------------------------------------------©*/
        let vStack = UIStackView(arrangedSubviews: [ emailTextField, resetPWButton ])
        createVStack(vStack: vStack, obj: iconImg, spacing: 20, paddingTop: 32, paddingLeft: 32, paddingRight: 32)

        backButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, paddingTop: 16, paddingLeft: 16)
    }

    // MARK: _@Helper-methods
    /**©-------------------------------------------©*/
    // Will add the email to the reset view screen when a
    // email is entered in the text field
    func loadEmail() {
        guard let email = email else { return }
        // Validating our form
        resetPWViewModel.email = email
        emailTextField.text = email

        // Enables button when segueing to the reset password view screen
        updateForm()
    }

    func configNotificationObservers() {
        emailTextField.addTarget(self, action: #selector(txtDidChange), for: .editingChanged)
    }
    /**©-------------------------------------------©*/
}// END OF CLASS
