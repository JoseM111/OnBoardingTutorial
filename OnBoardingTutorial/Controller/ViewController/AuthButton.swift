import UIKit

class AuthButton: UIButton {
    
    // MARK: @Properties
    var title: String? {
        didSet {
            setTitle(title, for: .normal)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // MARK: -#Setup button
        /**©---------------------------------------------©*/
        layer.cornerRadius = 5

        // Creates a color object that has the same color
        // space and component values as the receiver, but
        // has the specified alpha component.
        backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1).withAlphaComponent(0.5)
        
        setTitleColor(UIColor(white: 1, alpha: 0.67), for: .normal)
        setHeight(height: 50)
        // Toggles if the button is working or not
        isEnabled = false
        /**©---------------------------------------------©*/
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
