import UIKit

protocol AuthViewModel {
    var formIsValid: Bool { get }
    var shouldEnableBtn: Bool { get }
    var btnTitleColor: UIColor { get }
    var btnBGColor: UIColor { get }
}

protocol FormUpdateModel {
    func updateForm()
}

/*-----------------------------------------------------------
This file will hold multiple small struct auth objects
-----------------------------------------------------------*/

// MARK: _@AuthViewModel
struct LoginViewModel: AuthViewModel {
    // MARK: _@Properties
    var email: String?
    var password: String?

    // MARK: -#Protocol-Computed-Properties
    /**©-------------------------------------------©*/
    var formIsValid: Bool {
        email?.isEmpty == false
                && password?.isEmpty == false
    }

    // if form is valid = true enable
    var shouldEnableBtn: Bool {
        formIsValid
    }

    // Changes the button color when in use
    var btnTitleColor: UIColor {
        /*-------------------------------------------------------
           Using a ternary operator:
           if formIsValid == true {
                return .white
           } else { UIColor(white: 1, alpha: 0.67) }
          -------------------------------------------------------*/
        formIsValid ? .white : UIColor(white: 1, alpha: 0.67)
    }

    var btnBGColor: UIColor {
        let enablePurple = #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)
        let disabledPurple = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1).withAlphaComponent(0.5)

        return formIsValid ? enablePurple : disabledPurple
    }
    /**©-------------------------------------------©*/
}// END OF STRUCT

// MARK: _@RegistrationViewModel
struct RegistrationViewModel: AuthViewModel {
    // MARK: _@Properties
    var email: String?
    var password: String?
    var fullName: String?

    // MARK: -#Protocol-Computed-Properties
    /**©-------------------------------------------©*/
    var formIsValid: Bool {
        email?.isEmpty == false
                && password?.isEmpty == false
                && fullName?.isEmpty == false
    }

    // if form is valid = true enable
    var shouldEnableBtn: Bool {
        formIsValid
    }

    // Changes the button color when in use
    var btnTitleColor: UIColor {
        /*-------------------------------------------------------
           Using a ternary operator:
           if formIsValid == true {
                return .white
           } else { UIColor(white: 1, alpha: 0.67) }
          -------------------------------------------------------*/
        formIsValid ? .white : UIColor(white: 1, alpha: 0.67)
    }

    var btnBGColor: UIColor {
        let enablePurple = #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)
        let disabledPurple = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1).withAlphaComponent(0.5)

        return formIsValid ? enablePurple : disabledPurple
    }
    /**©-------------------------------------------©*/
}// END OF STRUCT

// MARK: _@ResetPWViewModel
struct ResetPWViewModel: AuthViewModel {
    // MARK: _@Properties
    var email: String?

    // MARK: -#Protocol-Computed-Properties
    /**©-------------------------------------------©*/
    var formIsValid: Bool {
        email?.isEmpty == false
    }

    // if form is valid = true enable
    var shouldEnableBtn: Bool {
        formIsValid
    }

    // Changes the button color when in use
    var btnTitleColor: UIColor {
        /*-------------------------------------------------------
           Using a ternary operator:
           if formIsValid == true {
                return .white
           } else { UIColor(white: 1, alpha: 0.67) }
          -------------------------------------------------------*/
        formIsValid ? .white : UIColor(white: 1, alpha: 0.67)
    }

    var btnBGColor: UIColor {
        let enablePurple = #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)
        let disabledPurple = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1).withAlphaComponent(0.5)

        return formIsValid ? enablePurple : disabledPurple
    }
    /**©-------------------------------------------©*/
}// END OF STRUCT
