import UIKit

class MainMenuViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "BgDark") ?? .black
        setupUI()
    }
    
    private func setupUI() {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scroll)
        NSLayoutConstraint.activate([
            scroll.topAnchor.constraint(equalTo: view.topAnchor),
            scroll.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scroll.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scroll.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        let container = UIStackView()
        container.axis = .vertical
        container.alignment = .fill
        container.spacing = 0
        container.translatesAutoresizingMaskIntoConstraints = false
        scroll.addSubview(container)
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: scroll.topAnchor, constant: 60),
            container.bottomAnchor.constraint(equalTo: scroll.bottomAnchor, constant: -40),
            container.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            container.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
        ])
        
        // Logo
        let logoEmoji = makeLabel("✕ ○", size: 56, weight: .black, color: UIColor(named: "ColorAccent") ?? .yellow)
        let titleLabel = makeLabel("TIC TAC TOE", size: 32, weight: .black, color: .white)
        let subtitleLabel = makeLabel("Choose Your Game Mode", size: 14, weight: .regular,
                                      color: UIColor(named: "TextSecondary") ?? .gray)
        container.addArrangedSubview(logoEmoji)
        container.setCustomSpacing(8, after: logoEmoji)
        container.addArrangedSubview(titleLabel)
        container.setCustomSpacing(6, after: titleLabel)
        container.addArrangedSubview(subtitleLabel)
        container.setCustomSpacing(48, after: subtitleLabel)
        
        // Multiplayer section
        container.addArrangedSubview(sectionLabel("MULTIPLAYER"))
        container.setCustomSpacing(12, after: container.arrangedSubviews.last!)
        
        let pvpBtn = makeMenuButton(title: "👥  Player vs Player", tintColor: .white)
        pvpBtn.addTarget(self, action: #selector(didTapPvP), for: .touchUpInside)
        container.addArrangedSubview(pvpBtn)
        container.setCustomSpacing(28, after: pvpBtn)
        
        // vs AI section
        container.addArrangedSubview(sectionLabel("VS COMPUTER"))
        container.setCustomSpacing(12, after: container.arrangedSubviews.last!)
        
        let easyBtn = makeMenuButton(title: "🤖  vs AI — Easy", tintColor: .white)
        easyBtn.addTarget(self, action: #selector(didTapEasyAI), for: .touchUpInside)
        container.addArrangedSubview(easyBtn)
        container.setCustomSpacing(12, after: easyBtn)
        
        let hardBtn = makeMenuButton(title: "💀  vs AI — Hard (Unbeatable)",
                                     tintColor: UIColor(named: "ColorX") ?? .red)
        hardBtn.addTarget(self, action: #selector(didTapHardAI), for: .touchUpInside)
        container.addArrangedSubview(hardBtn)
        container.setCustomSpacing(36, after: hardBtn)
        
        // Bottom buttons row
        let bottomRow = UIStackView()
        bottomRow.axis = .horizontal
        bottomRow.spacing = 12
        bottomRow.distribution = .fillEqually
        
        let scoreBtn = makeMenuButton(title: "🏆 Scores",
                                      tintColor: UIColor(named: "ColorAccent") ?? .yellow)
        scoreBtn.addTarget(self, action: #selector(didTapScoreboard), for: .touchUpInside)
        
        let settingsBtn = makeMenuButton(title: "⚙️ Settings",
                                         tintColor: UIColor(named: "TextSecondary") ?? .gray)
        settingsBtn.addTarget(self, action: #selector(didTapSettings), for: .touchUpInside)
        
        bottomRow.addArrangedSubview(scoreBtn)
        bottomRow.addArrangedSubview(settingsBtn)
        container.addArrangedSubview(bottomRow)
    }
    
    // MARK: - Factories
    private func makeLabel(_ text: String, size: CGFloat, weight: UIFont.Weight, color: UIColor) -> UILabel {
        let l = UILabel()
        l.text = text
        l.font = .systemFont(ofSize: size, weight: weight)
        l.textColor = color
        l.textAlignment = .center
        return l
    }
    
    private func sectionLabel(_ text: String) -> UILabel {
        let l = UILabel()
        l.text = text
        l.font = .systemFont(ofSize: 11, weight: .semibold)
        l.textColor = UIColor(named: "TextSecondary") ?? .gray
        return l
    }
    
    func makeMenuButton(title: String, tintColor: UIColor) -> UIButton {
        let btn = UIButton(type: .system)
        btn.setTitle(title, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        btn.setTitleColor(tintColor, for: .normal)
        btn.backgroundColor = UIColor(named: "CardBg") ?? UIColor(white: 0.12, alpha: 1)
        btn.layer.cornerRadius = 16
        btn.heightAnchor.constraint(equalToConstant: 60).isActive = true
        return btn
    }
    
    // MARK: - Actions
    @objc private func didTapPvP() { openGame(mode: .pvp) }
    @objc private func didTapEasyAI() { openGame(mode: .easyAI) }
    @objc private func didTapHardAI() { openGame(mode: .hardAI) }
    
    private func openGame(mode: GameMode) {
        let vc = GameViewController()
        vc.gameMode = mode
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true)
    }
    
    @objc private func didTapScoreboard() {
        let vc = ScoreboardViewController()
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true)
    }
    
    @objc private func didTapSettings() {
        let vc = SettingsViewController()
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true)
    }
}
