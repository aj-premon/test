import UIKit

class ScoreboardViewController: UIViewController {
    
    private var winsLabel = UILabel()
    private var lossesLabel = UILabel()
    private var drawsLabel = UILabel()
    private var totalLabel = UILabel()
    private var winRateLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "BgDark") ?? .black
        setupUI()
        loadScores()
    }
    
    private func setupUI() {
        let main = UIStackView()
        main.axis = .vertical
        main.spacing = 0
        main.alignment = .fill
        main.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(main)
        NSLayoutConstraint.activate([
            main.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            main.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
            main.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            main.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])
        
        let titleLabel = UILabel()
        titleLabel.text = "🏆 SCOREBOARD"
        titleLabel.font = .systemFont(ofSize: 26, weight: .black)
        titleLabel.textColor = UIColor(named: "ColorAccent") ?? .yellow
        titleLabel.textAlignment = .center
        main.addArrangedSubview(titleLabel)
        main.setCustomSpacing(32, after: titleLabel)
        
        // Top row: W / L
        let topRow = UIStackView()
        topRow.axis = .horizontal
        topRow.spacing = 14
        topRow.distribution = .fillEqually
        topRow.addArrangedSubview(statCard("WINS", color: UIColor(named: "ColorX") ?? .red,
                                            size: 48, label: winsLabel))
        topRow.addArrangedSubview(statCard("LOSSES", color: UIColor(named: "ColorO") ?? .green,
                                            size: 48, label: lossesLabel))
        main.addArrangedSubview(topRow)
        main.setCustomSpacing(14, after: topRow)
        
        // Bottom row: draws / win rate
        let bottomRow = UIStackView()
        bottomRow.axis = .horizontal
        bottomRow.spacing = 14
        bottomRow.distribution = .fillEqually
        bottomRow.addArrangedSubview(statCard("DRAWS", color: .white, size: 36, label: drawsLabel))
        bottomRow.addArrangedSubview(statCard("WIN RATE",
                                               color: UIColor(named: "ColorAccent") ?? .yellow,
                                               size: 36, label: winRateLabel))
        main.addArrangedSubview(bottomRow)
        main.setCustomSpacing(28, after: bottomRow)
        
        // Total
        let totalTitle = makeSmallLabel("Total Games Played")
        totalTitle.textAlignment = .center
        main.addArrangedSubview(totalTitle)
        
        totalLabel.font = .systemFont(ofSize: 24, weight: .black)
        totalLabel.textColor = .white
        totalLabel.textAlignment = .center
        main.addArrangedSubview(totalLabel)
        main.setCustomSpacing(36, after: totalLabel)
        
        // Spacer
        let spacer = UIView()
        spacer.setContentHuggingPriority(.defaultLow, for: .vertical)
        main.addArrangedSubview(spacer)
        
        // Reset button
        let resetBtn = makeButton("Reset Scores", bg: UIColor(named: "CardBg") ?? .darkGray,
                                   fg: UIColor(named: "ColorX") ?? .red)
        resetBtn.addTarget(self, action: #selector(didTapReset), for: .touchUpInside)
        main.addArrangedSubview(resetBtn)
        main.setCustomSpacing(12, after: resetBtn)
        
        // Back button
        let backBtn = makeButton("← Back",
                                  bg: UIColor(named: "ColorAccent") ?? .yellow,
                                  fg: UIColor(named: "BgDark") ?? .black)
        backBtn.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)
        main.addArrangedSubview(backBtn)
    }
    
    private func statCard(_ title: String, color: UIColor, size: CGFloat, label: UILabel) -> UIView {
        let card = UIView()
        card.backgroundColor = UIColor(named: "CardBg") ?? UIColor(white: 0.1, alpha: 1)
        card.layer.cornerRadius = 16
        card.heightAnchor.constraint(equalToConstant: 110).isActive = true
        
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: card.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: card.centerYAnchor)
        ])
        
        let t = makeSmallLabel(title)
        label.font = .systemFont(ofSize: size, weight: .black)
        label.textColor = color
        
        stack.addArrangedSubview(t)
        stack.addArrangedSubview(label)
        return card
    }
    
    private func makeSmallLabel(_ text: String) -> UILabel {
        let l = UILabel()
        l.text = text
        l.font = .systemFont(ofSize: 11, weight: .semibold)
        l.textColor = UIColor(named: "TextSecondary") ?? .gray
        return l
    }
    
    private func makeButton(_ title: String, bg: UIColor, fg: UIColor) -> UIButton {
        let btn = UIButton(type: .system)
        btn.setTitle(title, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        btn.setTitleColor(fg, for: .normal)
        btn.backgroundColor = bg
        btn.layer.cornerRadius = 16
        btn.heightAnchor.constraint(equalToConstant: 54).isActive = true
        return btn
    }
    
    private func loadScores() {
        let sm = ScoreManager.shared
        winsLabel.text = "\(sm.wins)"
        lossesLabel.text = "\(sm.losses)"
        drawsLabel.text = "\(sm.draws)"
        totalLabel.text = "\(sm.gamesPlayed)"
        winRateLabel.text = sm.winRate
    }
    
    @objc private func didTapReset() {
        let alert = UIAlertController(title: "Reset Scores",
                                       message: "Are you sure?",
                                       preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Reset", style: .destructive) { _ in
            ScoreManager.shared.resetAll()
            self.loadScores()
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
    @objc private func didTapBack() { dismiss(animated: true) }
}
