import UIKit

class DividerView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // MARK: _@
        /**©---------------------------------------------©*/
        let lbl = UILabel()
        lbl.text = "OR"
        lbl.textColor = UIColor(white: 1, alpha: 0.87)
        lbl.font = UIFont.systemFont(ofSize: 14)
        
        addSubview(lbl)
        lbl.centerX(inView: self)
        lbl.centerY(inView: self)
        
        // Creating the line dividers
        let leftDiv = UIView()
        leftDiv.backgroundColor = UIColor(white: 1, alpha: 0.25)
        addSubview(leftDiv)
        
        leftDiv.centerY(inView: self)
        leftDiv.anchor(left: leftAnchor, right: lbl.leftAnchor, paddingLeft: 8, paddingRight: 8, height: 1)
        
        
        let rightDiv = UIView()
        rightDiv.backgroundColor = UIColor(white: 1, alpha: 0.25)
        addSubview(rightDiv)

        rightDiv.centerY(inView: self)
        rightDiv.anchor(left: lbl.rightAnchor, right: rightAnchor, paddingLeft: 8, paddingRight: 8, height: 1)
        
        
        /**©---------------------------------------------©*/
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
