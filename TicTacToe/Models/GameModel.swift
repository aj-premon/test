import Foundation

// MARK: - Player
enum Player: String {
    case x = "X"
    case o = "O"
    
    var opponent: Player { self == .x ? .o : .x }
    var color: String { self == .x ? "ColorX" : "ColorO" }
}

// MARK: - Game Mode
enum GameMode {
    case pvp
    case easyAI
    case hardAI
    
    var title: String {
        switch self {
        case .pvp:     return "Player vs Player"
        case .easyAI:  return "vs AI — Easy"
        case .hardAI:  return "vs AI — Hard"
        }
    }
}

// MARK: - Game Result
enum GameResult {
    case win(Player)
    case draw
}

// MARK: - GameModel
class GameModel {
    
    static let winCombos: [[Int]] = [
        [0,1,2],[3,4,5],[6,7,8],
        [0,3,6],[1,4,7],[2,5,8],
        [0,4,8],[2,4,6]
    ]
    
    var board: [Player?] = Array(repeating: nil, count: 9)
    var currentPlayer: Player = .x
    var mode: GameMode = .pvp
    var result: GameResult? = nil
    var winningCombo: [Int]? = nil
    
    // MARK: - Move
    @discardableResult
    func makeMove(at index: Int) -> Bool {
        guard board[index] == nil, result == nil else { return false }
        board[index] = currentPlayer
        if let combo = checkWinner(board: board, player: currentPlayer) {
            result = .win(currentPlayer)
            winningCombo = combo
        } else if board.allSatisfy({ $0 != nil }) {
            result = .draw
        } else {
            currentPlayer = currentPlayer.opponent
        }
        return true
    }
    
    func reset() {
        board = Array(repeating: nil, count: 9)
        currentPlayer = .x
        result = nil
        winningCombo = nil
    }
    
    // MARK: - Win Check
    func checkWinner(board: [Player?], player: Player) -> [Int]? {
        for combo in GameModel.winCombos {
            if combo.allSatisfy({ board[$0] == player }) {
                return combo
            }
        }
        return nil
    }
    
    // MARK: - Easy AI (random)
    func easyAIMove() -> Int? {
        let empty = board.indices.filter { board[$0] == nil }
        return empty.randomElement()
    }
    
    // MARK: - Hard AI (Minimax + Alpha-Beta)
    func hardAIMove() -> Int? {
        var bestScore = Int.min
        var bestMove = -1
        for i in 0..<9 {
            if board[i] == nil {
                board[i] = .o
                let score = minimax(board: board, depth: 0, isMaximizing: false,
                                    alpha: Int.min, beta: Int.max)
                board[i] = nil
                if score > bestScore {
                    bestScore = score
                    bestMove = i
                }
            }
        }
        return bestMove == -1 ? nil : bestMove
    }
    
    private func minimax(board: [Player?], depth: Int,
                         isMaximizing: Bool, alpha: Int, beta: Int) -> Int {
        var b = board
        if checkWinner(board: b, player: .o) != nil { return 10 - depth }
        if checkWinner(board: b, player: .x) != nil { return depth - 10 }
        if b.allSatisfy({ $0 != nil }) { return 0 }
        
        var alpha = alpha, beta = beta
        
        if isMaximizing {
            var best = Int.min
            for i in 0..<9 {
                if b[i] == nil {
                    b[i] = .o
                    best = max(best, minimax(board: b, depth: depth+1,
                                            isMaximizing: false, alpha: alpha, beta: beta))
                    b[i] = nil
                    alpha = max(alpha, best)
                    if beta <= alpha { break }
                }
            }
            return best
        } else {
            var best = Int.max
            for i in 0..<9 {
                if b[i] == nil {
                    b[i] = .x
                    best = min(best, minimax(board: b, depth: depth+1,
                                            isMaximizing: true, alpha: alpha, beta: beta))
                    b[i] = nil
                    beta = min(beta, best)
                    if beta <= alpha { break }
                }
            }
            return best
        }
    }
}
