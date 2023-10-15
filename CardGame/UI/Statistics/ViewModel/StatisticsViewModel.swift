import Foundation

class StatisticsViewModel {
    
    private var players: [Player] = []
    private let store = CardGameStore()
    
    var dataUpdated: (() -> Void)?
    var showError: ((String) -> Void)?
    
    var numberOfPlayers: Int {
        return players.count
    }
    
    func playerInfo(at index: Int) -> (name: String, score: String, wins: String) {
        let player = players[index]
        return (player.name ?? "", "Очки: \(player.score)", "Победы: \(player.wins)")
    }
    
    func fetchPlayers() {
        store.fetchPlayers { [weak self] (players, error) in
            if let players = players {
                self?.players = players.sorted(by: { $0.score > $1.score })
                self?.dataUpdated?()
            } else if let error = error {
                self?.showError?("Ошибка при получении игроков: \(error.localizedDescription)")
            }
        }
    }
    
    func getPlayer(at index: Int) -> Player {
        return players[index]
    }
}
