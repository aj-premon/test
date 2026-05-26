import UIKit

extension UILabel {
    func letterSpacing(_ spacing: CGFloat) {
        guard let text = self.text else { return }
        let attributed = NSAttributedString(string: text, attributes: [
            .kern: spacing * self.font.pointSize
        ])
        self.attributedText = attributed
    }
}
