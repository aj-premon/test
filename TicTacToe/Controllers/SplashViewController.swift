import UIKit

class SplashViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "BgDark") ?? .black
        setupUI()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            let main = MainMenuViewController()
            main.modalTransitionStyle = .crossDissolve
            main.modalPresentationStyle = .fullScreen
            self.present(main, animated: true)
        }
    }
    
    private func setupUI() {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)
        
        let emoji = UILabel()
        emoji.text = "✕ ○"
        emoji.font = .systemFont(ofSize: 72, weight: .black)
        emoji.textColor = UIColor(named: "ColorAccent") ?? .yellow
        
        let title = UILabel()
        title.text = "TIC TAC TOE"
        title.font = .systemFont(ofSize: 32, weight: .black)
        title.textColor = .white
        title.letterSpacing(0.15)
        
        let sub = UILabel()
        sub.text = "Loading..."
        sub.font = .systemFont(ofSize: 14)
        sub.textColor = UIColor(named: "TextSecondary") ?? .gray
        
        [emoji, title, sub].forEach { stack.addArrangedSubview($0) }
        
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
