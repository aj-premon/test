import UIKit

class GameViewController: UIViewController {
    
    var gameMode: GameMode = .pvp
    private let game = GameModel()
    private var cellButtons: [UIButton] = []
    
    // Session scores
    private var scoreX = 0, scoreO = 0, scoreDraw = 0
    
    // Labels
    private var turnLabel = UILabel()
    private var modeLabel = UILabel()
    private var scoreXLabel = UILabel()
    private var scoreOLabel = UILabel()
    private var scoreDrawLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "BgDark") ?? .black
        game.mode = gameMode
        setupUI()
        updateTurnLabel()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        let main = UIStackView()
        main.axis = .vertical
        main.spacing = 0
        main.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(main)
        NSLayoutConstraint.activate([
            main.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            main.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            main.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            main.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
        // Header row
        let header = UIStackView()
        header.axis = .horizontal
        header.alignment = .center
        
        let backBtn = makeIconButton("←")
        backBtn.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)
        
        modeLabel.textColor = UIColor(named: "TextSecondary") ?? .gray
        modeLabel.font = .systemFont(ofSize: 13, weight: .medium)
        modeLabel.textAlignment = .center
        modeLabel.text = gameMode == .pvp ? "👥 Player vs Player" :
                         gameMode == .easyAI ? "🤖 vs AI (Easy)" : "💀 vs AI (Hard)"
        
        let restartBtn = makeIconButton("↺")
        restartBtn.setTitleColor(UIColor(named: "ColorAccent") ?? .yellow, for: .normal)
        restartBtn.addTarget(self, action: #selector(didTapRestart), for: .touchUpInside)
        
        header.addArrangedSubview(backBtn)
        header.addArrangedSubview(modeLabel)
        header.addArrangedSubview(restartBtn)
        modeLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        main.addArrangedSubview(header)
        main.setCustomSpacing(16, after: header)
        
        // Turn label
        turnLabel.textAlignment = .center
        turnLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        turnLabel.textColor = .white
        main.addArrangedSubview(turnLabel)
        main.setCustomSpacing(20, after: turnLabel)
        
        // Score row
        main.addArrangedSubview(makeScoreRow())
        main.setCustomSpacing(24, after: main.arrangedSubviews.last!)
        
        // Board
        main.addArrangedSubview(makeBoard())
        
        // Spacer
        let spacer = UIView()
        spacer.setContentHuggingPriority(.defaultLow, for: .vertical)
        main.addArrangedSubview(spacer)
    }
    
    private func makeIconButton(_ title: String) -> UIButton {
        let btn = UIButton(type: .system)
        btn.setTitle(title, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = UIColor(named: "CardBg") ?? UIColor(white: 0.1, alpha: 1)
        btn.layer.cornerRadius = 12
        btn.widthAnchor.constraint(equalToConstant: 44).isActive = true
        btn.heightAnchor.constraint(equalToConstant: 44).isActive = true
        return btn
    }
    
    private func makeScoreRow() -> UIStackView {
        let row = UIStackView()
        row.axis = .horizontal
        row.spacing = 12
        row.distribution = .fillEqually
        
        scoreXLabel = UILabel()
        scoreOLabel = UILabel()
        scoreDrawLabel = UILabel()
        
        row.addArrangedSubview(scoreCard(symbol: "X",
                                          color: UIColor(named: "ColorX") ?? .red,
                                          valueLabel: scoreXLabel))
        row.addArrangedSubview(scoreCard(symbol: "DRAW",
                                          color: UIColor(named: "TextSecondary") ?? .gray,
                                          valueLabel: scoreDrawLabel))
        row.addArrangedSubview(scoreCard(symbol: "O",
                                          color: UIColor(named: "ColorO") ?? .green,
                                          valueLabel: scoreOLabel))
        
        updateScoreLabels()
        return row
    }
    
    private func scoreCard(symbol: String, color: UIColor, valueLabel: UILabel) -> UIView {
        let card = UIView()
        card.backgroundColor = UIColor(named: "CardBg") ?? UIColor(white: 0.1, alpha: 1)
        card.layer.cornerRadius = 16
        card.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: card.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: card.centerYAnchor)
        ])
        
        let sym = UILabel()
        sym.text = symbol
        sym.font = .systemFont(ofSize: symbol.count > 1 ? 11 : 20, weight: .black)
        sym.textColor = color
        
        valueLabel.text = "0"
        valueLabel.font = .systemFont(ofSize: 28, weight: .black)
        valueLabel.textColor = .white
        
        stack.addArrangedSubview(sym)
        stack.addArrangedSubview(valueLabel)
        return card
    }
    
    private func makeBoard() -> UIView {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        
        let grid = UIStackView()
        grid.axis = .vertical
        grid.spacing = 10
        grid.distribution = .fillEqually
        grid.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(grid)
        
        NSLayoutConstraint.activate([
            grid.topAnchor.constraint(equalTo: container.topAnchor),
            grid.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            grid.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            grid.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            container.heightAnchor.constraint(equalTo: container.widthAnchor)
        ])
        
        var index = 0
        for _ in 0..<3 {
            let row = UIStackView()
            row.axis = .horizontal
            row.spacing = 10
            row.distribution = .fillEqually
            
            for _ in 0..<3 {
                let btn = UIButton(type: .system)
                btn.tag = index
                btn.titleLabel?.font = .systemFont(ofSize: 44, weight: .black)
                btn.backgroundColor = UIColor(named: "CellBg") ?? UIColor(white: 0.08, alpha: 1)
                btn.layer.cornerRadius = 16
                btn.addTarget(self, action: #selector(cellTapped(_:)), for: .touchUpInside)
                btn.layer.shadowColor = UIColor.black.cgColor
                btn.layer.shadowOpacity = 0.3
                btn.layer.shadowOffset = CGSize(width: 0, height: 2)
                btn.layer.shadowRadius = 4
                cellButtons.append(btn)
                row.addArrangedSubview(btn)
                index += 1
            }
            grid.addArrangedSubview(row)
        }
        return container
    }
    
    // MARK: - Game Logic
    @objc private func cellTapped(_ sender: UIButton) {
        let idx = sender.tag
        guard game.board[idx] == nil, game.result == nil else { return }
        if gameMode != .pvp && game.currentPlayer == .o { return }
        
        performMove(at: idx)
        
        if game.result == nil && gameMode != .pvp {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.performAIMove()
            }
        }
    }
    
    private func performMove(at idx: Int) {
        game.makeMove(at: idx)
        
        let btn = cellButtons[idx]
        let symbol = game.board[idx] == .x ? "X" : "O"
        btn.setTitle(symbol, for: .normal)
        btn.setTitleColor(
            game.board[idx] == .x
                ? (UIColor(named: "ColorX") ?? .red)
                : (UIColor(named: "ColorO") ?? .green),
            for: .normal
        )
        
        animateCell(btn)
        
        if SettingsManager.shared.vibrationEnabled {
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
        }
        
        if let result = game.result {
            handleResult(result)
        } else {
            updateTurnLabel()
        }
    }
    
    private func performAIMove() {
        guard game.result == nil else { return }
        let move: Int?
        switch gameMode {
        case .easyAI: move = game.easyAIMove()
        case .hardAI: move = game.hardAIMove()
        default: return
        }
        if let m = move { performMove(at: m) }
    }
    
    private func handleResult(_ result: GameResult) {
        // Highlight winners
        if let combo = game.winningCombo {
            for i in combo {
                UIView.animate(withDuration: 0.3) {
                    self.cellButtons[i].backgroundColor =
                        UIColor(named: "ColorAccent")?.withAlphaComponent(0.25) ??
                        UIColor.yellow.withAlphaComponent(0.25)
                    self.cellButtons[i].layer.borderWidth = 2
                    self.cellButtons[i].layer.borderColor =
                        (UIColor(named: "ColorAccent") ?? .yellow).cgColor
                }
            }
        }
        
        // Update session scores
        switch result {
        case .win(let p):
            p == .x ? (scoreX += 1) : (scoreO += 1)
        case .draw:
            scoreDraw += 1
        }
        updateScoreLabels()
        ScoreManager.shared.recordResult(result, mode: gameMode)
        
        // Show dialog
        let title: String
        let message: String
        switch result {
        case .win(let p):
            if gameMode == .pvp {
                title = p == .x ? "Player 1 Wins! 🎉" : "Player 2 Wins! 🎉"
            } else {
                title = p == .x ? "You Win! 🎉" : "AI Wins! 🤖"
            }
            message = ""
        case .draw:
            title = "It's a Draw! 🤝"
            message = ""
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Play Again", style: .default) { _ in
                self.resetBoard()
            })
            alert.addAction(UIAlertAction(title: "Main Menu", style: .cancel) { _ in
                self.dismiss(animated: true)
            })
            self.present(alert, animated: true)
        }
    }
    
    private func resetBoard() {
        game.reset()
        for btn in cellButtons {
            btn.setTitle("", for: .normal)
            btn.backgroundColor = UIColor(named: "CellBg") ?? UIColor(white: 0.08, alpha: 1)
            btn.layer.borderWidth = 0
        }
        updateTurnLabel()
    }
    
    private func updateTurnLabel() {
        if gameMode == .pvp {
            turnLabel.text = game.currentPlayer == .x ? "Player 1's Turn (X)" : "Player 2's Turn (O)"
        } else {
            turnLabel.text = game.currentPlayer == .x ? "Your Turn (X)" : "AI is thinking..."
        }
        turnLabel.textColor = game.currentPlayer == .x
            ? (UIColor(named: "ColorX") ?? .red)
            : (UIColor(named: "ColorO") ?? .green)
    }
    
    private func updateScoreLabels() {
        scoreXLabel.text = "\(scoreX)"
        scoreOLabel.text = "\(scoreO)"
        scoreDrawLabel.text = "\(scoreDraw)"
    }
    
    private func animateCell(_ btn: UIButton) {
        guard SettingsManager.shared.animationsEnabled else { return }
        btn.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        UIView.animate(withDuration: 0.3, delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 5) {
            btn.transform = .identity
        }
    }
    
    @objc private func didTapBack() { dismiss(animated: true) }
    @objc private func didTapRestart() { resetBoard() }
}
