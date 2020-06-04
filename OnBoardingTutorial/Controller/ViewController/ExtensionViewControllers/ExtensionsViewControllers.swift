import UIKit
import GoogleSignIn
import paper_onboarding

// MARK: extension|LoginVC|:[ FormUpdateModel ]
extension LoginViewController: FormUpdateModel, GIDSignInDelegate, ResetPasswordViewControllerDelegate  {
    // MARK: _@updateForm
    /**©-------------------------------------------©*/
    func updateForm() {
        loginButton.isEnabled = loginViewModel.shouldEnableBtn
        // Changes the color of the button background color when enabled
        loginButton.backgroundColor = loginViewModel.btnBGColor
        loginButton.setTitleColor(loginViewModel.btnTitleColor, for: .normal)
    }
    /**©-------------------------------------------©*/
    
    // MARK: _@sign-->> How we sign in with google
    /**©---------------------------------------------©*/
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        Service.signInWithGoogle(didSignInUser: user) { (_, _) in//<<-- Handled in Service API Object
            self.authDelegate?.AuthComplete()
        }
        /**©---------------------------------------------©*/
    }

    // MARK: _@didSendResetPWDLink-->> Resets password delegate func
    /**©-------------------------------------------©*/
    func didSendResetPWDLink() {
        navigationController?.popViewController(animated: true)
        self.showMsgAlert(withTitle: "SUCCESS", message: MSG_RESET_PWD_LINK_SENT)
    }
    /**©-------------------------------------------©*/
}// END OF EXTENSION

// MARK: extension|RegistrationVC|:[ FormUpdateModel ]
extension RegistrationViewController: FormUpdateModel {
    
    // MARK: _@updateForm
    /**©-------------------------------------------©*/
    func updateForm() {
        signUpButton.isEnabled = registrationViewModel.shouldEnableBtn
        // Changes the color of the button background color when enabled
        signUpButton.backgroundColor = registrationViewModel.btnBGColor
        signUpButton.setTitleColor(registrationViewModel.btnTitleColor, for: .normal)
    }
    /**©-------------------------------------------©*/
}// END OF EXTENSION

// MARK: extension|ResetPasswordVC|:[ FormUpdateModel ]
extension ResetPasswordViewController: FormUpdateModel {
    
    // MARK: _@updateForm
    /**©-------------------------------------------©*/
    func updateForm() {
        resetPWButton.isEnabled = resetPWViewModel.shouldEnableBtn
        // Changes the color of the button background color when enabled
        resetPWButton.backgroundColor = resetPWViewModel.btnBGColor
        resetPWButton.setTitleColor(resetPWViewModel.btnTitleColor, for: .normal)
    }
    /**©-------------------------------------------©*/
}// END OF EXTENSION

// MARK: extension|OnboardingViewController|:[ PaperOnboardingDataSource ]
/*-------------------------------------------------------
 A table view that tells how many pages we ar going
 to have & also how to set them up...
 -------------------------------------------------------*/
extension OnboardingViewController: PaperOnboardingDataSource, PaperOnboardingDelegate {
    /**©---------------------------------------------©*/
    func onboardingItemsCount() -> Int {
        onboardingItems.count
    }
    
    func onboardingItem(at index: Int) -> OnboardingItemInfo {
        onboardingItems[index]
    }
    
    // TODO: -CORRECT THIS FUNCTION TO SHOW INDEX PARAMETER
    func onboardingWillTransitonToIndex(_ index: Int) {
        printf("DEBUG: Index = \(index)")
        /*-------------------------------------------------------
         onboardingItems.count - 1<<-- EXPLAINED
         Has you transition through your onboarding views
         (3 in this project) you will increment one index at
         a time. When you transition back you would want to
         subtract - 1 to the indexes so that you do not have
         to continue adjusting the count manually in the app
         Example of what i mean:
         -------------------------------------------------------
         [Going to the right]--> 📲
         DEBUG: Index = 1, DEBUG: Index = 2
         [Going to the left] 📱 <-- 
         DEBUG: Index = 1, DEBUG: Index = 0
         -------------------------------------------------------*/
        let obViewModel = OBViewModel(itemCount: onboardingItems.count)
        let shouldShow: Bool = obViewModel.shouldShowGetStartedBtnFor(index: index)
        animateGetStartedBtn(shouldShow)
    }
    /**©---------------------------------------------©*/
}// END OF EXTENSION

// MARK: extension|HomeViewController|:[ OnboardingViewControllerDelegate ]
/**©---------------------------------------------©*/
extension HomeViewController: OnboardingViewControllerDelegate {
    func controllerWantsToDismiss(_ controller: OnboardingViewController) {
        /*-------------------------------------------------------
           func dismiss(animated flag: Bool, completion: (() -> Void)? = nil)
           -------------------------------------------------------
           The presenting view controller is responsible for dismissing
           the view controller it presented. If you call this method on
           the presented view controller itself, UIKit asks the
           presenting view controller to handle the dismissal.
          -------------------------------------------------------*/
        controller.dismiss(animated: true, completion: nil)

        /*-------------------------------------------------------
          Will update `hasSeenOnboarding` to true in firebase
          when the get started button is pressed from the
          onboarding view screen...
          -------------------------------------------------------*/
//        Service.updateUserHasSeenOB { (_, _) in
//            self.user?.hasSeenOnboarding = true
//        }
    Service.updateUserHasSeenOBFirestore { _ in
        self.user?.hasSeenOnboarding = true
    }
    }
}// END OF EXTENSION

// MARK: extension|HomeViewController|:[ AuthDelegate ]
/**©-------------------------------------------©*/
extension HomeViewController: AuthDelegate {
    // - Funcs
    /**©-----------------------©*/
    func AuthComplete() {
        dismiss(animated: true, completion: nil)
        /*-------------------------------------------------------
          First it is going to fetch the user, then reset if it is a
          new user, to then render that new user in the welcome screen
          -------------------------------------------------------*/
//        fetchUser()<<-- FireStore
    fetchUserWithFirestore()
    }
    /**©-----------------------©*/

}
/**©-------------------------------------------©*/