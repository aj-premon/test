import Foundation

class ScoreManager {
    
    static let shared = ScoreManager()
    private let defaults = UserDefaults.standard
    
    private enum Key: String {
        case wins, losses, draws, gamesPlayed
    }
    
    var wins: Int {
        get { defaults.integer(forKey: Key.wins.rawValue) }
        set { defaults.set(newValue, forKey: Key.wins.rawValue) }
    }
    var losses: Int {
        get { defaults.integer(forKey: Key.losses.rawValue) }
        set { defaults.set(newValue, forKey: Key.losses.rawValue) }
    }
    var draws: Int {
        get { defaults.integer(forKey: Key.draws.rawValue) }
        set { defaults.set(newValue, forKey: Key.draws.rawValue) }
    }
    var gamesPlayed: Int {
        get { defaults.integer(forKey: Key.gamesPlayed.rawValue) }
        set { defaults.set(newValue, forKey: Key.gamesPlayed.rawValue) }
    }
    
    var winRate: String {
        guard gamesPlayed > 0 else { return "0%" }
        let rate = Int((Double(wins) / Double(gamesPlayed)) * 100)
        return "\(rate)%"
    }
    
    func recordResult(_ result: GameResult, mode: GameMode) {
        gamesPlayed += 1
        if case .pvp = mode { return } // Only track vs AI stats
        switch result {
        case .win(let p): p == .x ? (wins += 1) : (losses += 1)
        case .draw: draws += 1
        }
    }
    
    func resetAll() {
        wins = 0; losses = 0; draws = 0; gamesPlayed = 0
    }
}
