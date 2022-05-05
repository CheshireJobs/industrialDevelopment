import Foundation
import UIKit

class CustomButton: UIButton {
    var onTap: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(title: String, titleColor: UIColor) {
        super.init(frame: .zero)
         
        self.setTitle(title, for: .normal)
        self.setTitleColor(titleColor, for: .normal)
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    private func buttonTapped() {
        onTap?()
    }
}
