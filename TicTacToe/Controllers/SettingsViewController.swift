import UIKit

class SettingsViewController: UIViewController {
    
    private let settings = SettingsManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "BgDark") ?? .black
        setupUI()
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
        titleLabel.text = "⚙️ SETTINGS"
        titleLabel.font = .systemFont(ofSize: 26, weight: .black)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        main.addArrangedSubview(titleLabel)
        main.setCustomSpacing(40, after: titleLabel)
        
        // Toggles
        let soundRow = makeToggleRow("🔊  Sound Effects", isOn: settings.soundEnabled) { val in
            self.settings.soundEnabled = val
        }
        main.addArrangedSubview(soundRow)
        main.setCustomSpacing(12, after: soundRow)
        
        let vibRow = makeToggleRow("📳  Vibration", isOn: settings.vibrationEnabled) { val in
            self.settings.vibrationEnabled = val
        }
        main.addArrangedSubview(vibRow)
        main.setCustomSpacing(12, after: vibRow)
        
        let animRow = makeToggleRow("✨  Animations", isOn: settings.animationsEnabled) { val in
            self.settings.animationsEnabled = val
        }
        main.addArrangedSubview(animRow)
        main.setCustomSpacing(40, after: animRow)
        
        // Spacer
        let spacer = UIView()
        spacer.setContentHuggingPriority(.defaultLow, for: .vertical)
        main.addArrangedSubview(spacer)
        
        // Back
        let backBtn = UIButton(type: .system)
        backBtn.setTitle("← Back", for: .normal)
        backBtn.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        backBtn.setTitleColor(UIColor(named: "BgDark") ?? .black, for: .normal)
        backBtn.backgroundColor = UIColor(named: "ColorAccent") ?? .yellow
        backBtn.layer.cornerRadius = 16
        backBtn.heightAnchor.constraint(equalToConstant: 54).isActive = true
        backBtn.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)
        main.addArrangedSubview(backBtn)
    }
    
    private func makeToggleRow(_ title: String, isOn: Bool,
                                onChange: @escaping (Bool) -> Void) -> UIView {
        let container = UIView()
        container.backgroundColor = UIColor(named: "CardBg") ?? UIColor(white: 0.1, alpha: 1)
        container.layer.cornerRadius = 16
        container.heightAnchor.constraint(equalToConstant: 64).isActive = true
        
        let label = UILabel()
        label.text = title
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let toggle = UISwitch()
        toggle.isOn = isOn
        toggle.onTintColor = UIColor(named: "ColorAccent") ?? .yellow
        toggle.translatesAutoresizingMaskIntoConstraints = false
        toggle.addAction(UIAction { _ in onChange(toggle.isOn) }, for: .valueChanged)
        
        container.addSubview(label)
        container.addSubview(toggle)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            label.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            toggle.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
            toggle.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])
        return container
    }
    
    @objc private func didTapBack() { dismiss(animated: true) }
}
