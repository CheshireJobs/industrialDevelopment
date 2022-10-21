import UIKit

extension UIColor {
    static var appBackgroundColor: UIColor = {
        if #available(iOS 13, *) {
            return UIColor  { (traitCollection: UITraitCollection) -> UIColor in
                if traitCollection.userInterfaceStyle == .dark {
                    return .black
                } else {
                    return .white
                }
            }
        } else {
            return .white
        }
    }()
    
    static var appLabelColor: UIColor = {
        if #available(iOS 13, *) {
            return UIColor  { (traitCollection: UITraitCollection) -> UIColor in
                if traitCollection.userInterfaceStyle == .dark {
                    return .white
                } else {
                    return .black
                }
            }
        } else {
            return .black
        }
    }()
}
