import UIKit
import JGProgressHUD

// MARK: _@extension UIView
/**©------------------------------------------------------------------------------©*/
extension UIView {
    func anchor(top: NSLayoutYAxisAnchor? = nil,
                left: NSLayoutXAxisAnchor? = nil,
                bottom: NSLayoutYAxisAnchor? = nil,
                right: NSLayoutXAxisAnchor? = nil,
                paddingTop: CGFloat = 0,
                paddingLeft: CGFloat = 0,
                paddingBottom: CGFloat = 0,
                paddingRight: CGFloat = 0,
                width: CGFloat? = nil,
                height: CGFloat? = nil) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top: NSLayoutYAxisAnchor = top {
            topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let left: NSLayoutXAxisAnchor = left {
            leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        
        if let bottom: NSLayoutYAxisAnchor = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        
        if let right: NSLayoutXAxisAnchor = right {
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        
        if let width: CGFloat = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if let height: CGFloat = height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
    func centerX(inView view: UIView, topAnchor: NSLayoutYAxisAnchor? = nil, paddingTop: CGFloat? = nil) {
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        if let topAnchor: NSLayoutYAxisAnchor = topAnchor,
           let padding: CGFloat = paddingTop {
            self.topAnchor.constraint(equalTo: topAnchor, constant: padding).isActive = true
        }
    }
    
    func centerY(inView view: UIView, leftAnchor: NSLayoutXAxisAnchor? = nil,
                 paddingLeft: CGFloat = 0, constant: CGFloat = 0) {
        
        translatesAutoresizingMaskIntoConstraints = false
        centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: constant).isActive = true
        
        if let left: NSLayoutXAxisAnchor = leftAnchor {
            anchor(left: left, paddingLeft: paddingLeft)
        }
    }
    
    func setDimensions(height: CGFloat, width: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: height).isActive = true
        widthAnchor.constraint(equalToConstant: width).isActive = true
    }
    
    func setHeight(height: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    
    func setWidth(width: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: width).isActive = true
    }
    
    // Sets the constraints so that it fills the whole screen
    func fillSuperview() {
        translatesAutoresizingMaskIntoConstraints = false
        guard let superviewTopAnchor: NSLayoutYAxisAnchor = superview?.topAnchor,
              let superviewBottomAnchor: NSLayoutYAxisAnchor = superview?.bottomAnchor, 
              let superviewLeadingAnchor: NSLayoutXAxisAnchor = superview?.leftAnchor, 
              let superviewTrailingAnchor: NSLayoutXAxisAnchor = superview?.rightAnchor else { return }
        
        anchor(top: superviewTopAnchor, left: superviewLeadingAnchor,
               bottom: superviewBottomAnchor, right: superviewTrailingAnchor)
    }
}// END OF EXTENSION
/**©------------------------------------------------------------------------------©*/

// MARK: _@extension UIViewController
/**©------------------------------------------------------------------------------©*/
extension UIViewController {
    static let sharedHud: JGProgressHUD = JGProgressHUD(style: .dark)
    
    func configureGradientBackground() {
        let gradient: CAGradientLayer? = CAGradientLayer()
        gradient?.colors = [UIColor.systemPurple.cgColor, UIColor.systemBlue.cgColor]
        gradient?.locations = [0, 1]
        view.layer.addSublayer(gradient ?? CAGradientLayer())
        gradient?.frame = view.frame
    }

    func showMsgAlert(withTitle titleController: String, message: String, titleAction: String = "") {
        let alert = UIAlertController(title: titleController, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: titleAction, style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    // MARK: #showLoader-->> Used throughout the application
    func showLoader(_ show: Bool) {
        /*-------------------------------------------------------
          Causes the view (or one of its embedded text fields)
          to resign the first responder status.
          -------------------------------------------------------*/
        view.endEditing(true)

        guard show else { return UIViewController.sharedHud.dismiss() }
        // if show ⬇️
        UIViewController.sharedHud.show(in: view)
    }
}// END OF EXTENSION
/**©------------------------------------------------------------------------------©*/

// MARK: _@My Extensions of UIViewController
/**©------------------------------------------------------------------------------©*/
extension UIViewController {
    
    func configureGradientBackGround() {
        let gradient: CAGradientLayer? = CAGradientLayer()
        gradient?.colors = [ UIColor.systemPurple.cgColor, UIColor.systemBlue.cgColor]
        
        /*-------------------------------------------------------
         var locations: [NSNumber]? { get set }
         -------------------------------------------------------
         An optional array of NSNumber objects defining
         the location of each gradient stop. Animatable.
         -------------------------------------------------------*/
        gradient?.locations = [0,1]
        view.layer.addSublayer(gradient ?? CAGradientLayer())
        
        /*-------------------------------------------------------
         var frame: CGRect { get set }
         -------------------------------------------------------
         The frame rectangle is position and size of the layer
         specified in the superlayer’s coordinate space. For
         layers, the frame rectangle is a computed property that
         is derived from the values in the bounds, anchorPoint and
         position properties. When you assign a new value to this
         property, the layer changes its position and bounds
         properties to match the rectangle you specified. The
         values of each coordinate in the rectangle are measured
         in points.
         -------------------------------------------------------*/
        gradient?.frame = view.frame
    }
    
    func addAllSubViews(obj1: UIView , obj2: UIView = UIView(), obj3: UIView = UIView()) {
        // MARK: -#[subview-additions]
        view.addSubview(obj1)
        view.addSubview(obj2)
        view.addSubview(obj3)
    }

    func createVStack(vStack: UIStackView, obj: UIView, spacing: CGFloat, paddingTop: CGFloat, paddingLeft : CGFloat, paddingRight: CGFloat) {
        vStack.axis = .vertical
        vStack.spacing = spacing

        view.addSubview(vStack)
        vStack.anchor(top: obj.bottomAnchor, left: view.leftAnchor,
                right: view.rightAnchor, paddingTop: paddingTop,
                paddingLeft: paddingLeft, paddingRight: paddingRight)
    }

    func imgConstraints(obj: UIView,  ht: CGFloat, wt: CGFloat, paddingTop: CGFloat) { // Centering it on the x-axis
        obj.centerX(inView: view)
        // Setting the dimensions
        obj.setDimensions(height: ht, width: ht)

        // Anchoring it to the top & giving it a padding of 32
        obj.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: paddingTop)
    }
}// END OF EXTENSION
/**©------------------------------------------------------------------------------©*/
