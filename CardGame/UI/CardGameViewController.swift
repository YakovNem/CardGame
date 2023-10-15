import UIKit

class CardGameViewController: UIViewController {
    
    //MARK: - Properties
    private let cardGameStore = CardGameStore()
    
    private var gamesWon = 0
    private var matchCount = 0
    private var playerPoints = 0
    private var gamePoints = 0
    private var playerWins = 0
    private var dealerWins = 0
    private var roundsPlayed = 0
    private let maxRounds = 5
    private var lastComputerChoice: String?
    private var playerName: String = "Player"
    
    //MARK: - UI Elements
    
    private let rockButton = UIButton()
    private let scissorsButton = UIButton()
    private let paperButton = UIButton()
    
    private let scoreLabel: UILabel = {
        let label = UILabel()
        label.text = "Player: 0, Dealer: 0"
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var emojiLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 50)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var computerEmojiLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 50)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let gameOverView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.layer.shadowOpacity = 0.25
        view.layer.shadowOffset = CGSize(width: 0, height: 10)
        view.layer.shadowRadius = 10
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let winnerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var replayButton: UIButton = {
        let button = UIButton()
        button.setTitle("Играть еще раз", for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapReplayButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var statsButton: UIButton = {
        let button = UIButton()
        button.setTitle("Таблица рекордов", for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapStatsButton), for: .touchUpInside)
        return button
    }()
    
    private var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupButtons()
        setupLayout()
        updateScore()
    }
    
    //MARK: - Setup Layout
    
    private func setupLayout() {
        view.backgroundColor = .white
        
        view.addSubview(emojiLabel)
        view.addSubview(computerEmojiLabel)
        view.addSubview(scoreLabel)
        
        view.addSubview(stackView)
        stackView.addArrangedSubview(rockButton)
        stackView.addArrangedSubview(scissorsButton)
        stackView.addArrangedSubview(paperButton)
        
        view.addSubview(gameOverView)
        gameOverView.addSubview(winnerLabel)
        gameOverView.addSubview(replayButton)
        gameOverView.addSubview(statsButton)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            stackView.heightAnchor.constraint(equalToConstant: 60),
            
            emojiLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            computerEmojiLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            computerEmojiLabel.bottomAnchor.constraint(equalTo: emojiLabel.topAnchor, constant: -20),
            
            scoreLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            scoreLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            scoreLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            gameOverView.topAnchor.constraint(equalTo: view.topAnchor),
            gameOverView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            gameOverView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            gameOverView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            winnerLabel.centerXAnchor.constraint(equalTo: gameOverView.centerXAnchor),
            winnerLabel.centerYAnchor.constraint(equalTo: gameOverView.centerYAnchor),
            
            replayButton.centerXAnchor.constraint(equalTo: gameOverView.centerXAnchor),
            replayButton.topAnchor.constraint(equalTo: winnerLabel.bottomAnchor, constant: 20),
            replayButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            replayButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            replayButton.heightAnchor.constraint(equalToConstant: 60),
            
            statsButton.centerXAnchor.constraint(equalTo: gameOverView.centerXAnchor),
            statsButton.topAnchor.constraint(equalTo: replayButton.bottomAnchor, constant: 20),
            statsButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            statsButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            statsButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func setupView() {
        cardGameStore.fetchLatestPlayer { player, error in
            if let player = player {
                self.playerName = player.name ?? "Player"
            } else {
                self.playerName = "Player"
            }
            self.updateScore()
        }
    }
    
    private func setupButtons() {
        [rockButton, scissorsButton, paperButton].forEach { button in
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = .black
            button.layer.cornerRadius = 16
            button.clipsToBounds = true
            button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        }
        
        rockButton.setTitle("👊", for: .normal)
        scissorsButton.setTitle("✌️", for: .normal)
        paperButton.setTitle("✋", for: .normal)
    }
    
    //MARK: - Actions & Game Logic
    
    @objc private func buttonTapped(_ sender: UIButton) {
        var userChoice: String
        switch sender {
        case rockButton:
            userChoice = "👊"
        case scissorsButton:
            userChoice = "✌️"
        case paperButton:
            userChoice = "✋"
        default:
            return
        }
        
        let computerChoice = generateComputerChoice()
        
        emojiLabel.text = userChoice
        computerEmojiLabel.text = computerChoice
        
        emojiLabel.transform = CGAffineTransform(translationX: 0, y: view.bounds.height)
        computerEmojiLabel.transform = CGAffineTransform(translationX: 0, y: -view.bounds.height)
        
        emojiLabel.alpha = 1
        computerEmojiLabel.alpha = 1
        
        UIView.animate(withDuration: 0.5) {
            self.emojiLabel.transform = .identity
            self.computerEmojiLabel.transform = .identity
        }
        
        view.backgroundColor = .white
        determineWinner(userChoice: userChoice, computerChoice: computerChoice)
        
        if userChoice == computerChoice {
            sender.isHidden = true
        }
    }
    
    @objc private func didTapReplayButton() {
        restartGame()
        gameOverView.isHidden = true
    }
    
    @objc private func didTapStatsButton() {
        let statisticsViewController = StatisticsViewController()
        statisticsViewController.modalPresentationStyle = .overCurrentContext
        statisticsViewController.delegate = self
        view.isUserInteractionEnabled = false
        present(statisticsViewController, animated: true)
    }
    
    //MARK: - Game Helper
    
    private func generateComputerChoice() -> String {
        var choices = ["👊", "✌️", "✋"]
        if let lastChoice = lastComputerChoice, matchCount < 2 {
            choices = choices.filter { $0 != lastChoice }
        }
        let choice = choices[Int(arc4random_uniform(UInt32(choices.count)))]
        lastComputerChoice = choice
        return choice
    }
    
    private func determineWinner(userChoice: String, computerChoice: String) {
        if userChoice == computerChoice {
            matchCount += 1
            if matchCount == 2 {
                showMatchedCardsAlert()
                return
            }
        } else {
            matchCount = 0
            if (userChoice == "👊" && computerChoice == "✌️") ||
                (userChoice == "✌️" && computerChoice == "✋") ||
                (userChoice == "✋" && computerChoice == "👊") {
                playerWins += 1
                view.backgroundColor = .green
            } else {
                dealerWins += 1
                view.backgroundColor = .red
            }
            
            [rockButton, scissorsButton, paperButton].forEach { $0.isHidden = false }
            
            roundsPlayed += 1
            updateScore()
            checkGameEnd()
        }
    }
    
    private func checkGameEnd() {
        if roundsPlayed == maxRounds {
            if playerWins > dealerWins {
                gamePoints += 10
                gamesWon += 1
                savePlayerScore()
                winnerLabel.text = "Вы победили!\n Вам начислено \(gamePoints) очков."
            } else {
                winnerLabel.text = "Увы, вы проиграли!"
            }
            gameOverView.isHidden = false
        }
    }
    
    private func savePlayerScore() {
        playerPoints += gamePoints
        cardGameStore.fetchPlayer(withName: playerName) { [weak self] existingPlayer, error in
            guard let self = self else { return }
            
            if let existingPlayer = existingPlayer {
                self.cardGameStore.updatePlayer(existingPlayer, withScore: self.playerPoints, wins: self.gamesWon) { error in
                    if let error = error {
                        print("Failed to update player: \(error)")
                    }
                }
            } else {
                self.cardGameStore.savePlayer(name: self.playerName, score: self.playerPoints, wins: self.gamesWon) { error in
                    if let error = error {
                        print("Failed to save player: \(error)")
                    }
                }
            }
        }
    }
    
    private func restartGame() {
        playerWins = 0
        dealerWins = 0
        roundsPlayed = 0
        gamePoints = 0
        updateScore()
        rockButton.isHidden = false
        scissorsButton.isHidden = false
        paperButton.isHidden = false
        lastComputerChoice = nil
        view.backgroundColor = .white
        emojiLabel.text = ""
        computerEmojiLabel.text = ""
    }
    
    private func restartCurrentRound() {
        matchCount = 0
        rockButton.isHidden = false
        scissorsButton.isHidden = false
        paperButton.isHidden = false
        lastComputerChoice = nil
        view.backgroundColor = .white
        emojiLabel.text = ""
        computerEmojiLabel.text = ""
    }
    
    private func updateScore() {
        scoreLabel.text = "\(playerName): \(playerWins)\nDealer: \(dealerWins)\nRounds: \(roundsPlayed)"
    }
    
    private func showMatchedCardsAlert() {
        let alertController = UIAlertController(title: "Ничья в раунде!", message: "Две карты подряд совпали. Раунд будет переигран.", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            self.restartCurrentRound()
        }
        
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}

//MARK: - Extensions

extension CardGameViewController: StatisticsViewControllerDelegate {
    func didCloseStatistics() {
        view.isUserInteractionEnabled = true
    }
}
