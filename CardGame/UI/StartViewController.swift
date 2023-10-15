import UIKit

class StartViewController: UIViewController {
    
    //MARK: - Properties
    
    private let cardGameStore = CardGameStore()
    
    private var mainTextLabel: UILabel = {
        let label = UILabel()
        label.text = "Добро пожаловать!"
        label.font = UIFont.boldSystemFont(ofSize: 32)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var textLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .justified
        label.numberOfLines = 0
        label.text = """
Вы попали в классическую игру "Камень. Ножницы. Бумага". Это простое, но увлекательное соревнование, где ваша задача - предсказать ход противника и выбрать выигрышный объект. Перед тем как начать, введите ваше имя. Это поможет нам сохранить ваши достижения и отразить ваш прогресс в таблице рекордов. После этого просто нажмите "Играть" и погрузитесь в игру!"
"""
        label.font = UIFont.systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Введите ваше имя"
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 16
        textField.backgroundColor = .white
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        return textField
    }()
    
    private lazy var statisticButton: UIButton = {
        let button = UIButton()
        button.setTitle("Таблица рекордов", for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapStatisticButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var startGameButton: UIButton = {
        let button = UIButton()
        button.setTitle("Играть", for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapStartGameButton), for: .touchUpInside)
        return button
    }()
    
    private var buttonStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 10
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        updateStartButtonState()
    }
    
    //MARK: - Setup Layout
    
    private func setupLayout() {
        view.backgroundColor = .white
        
        //Add Views
        view.addSubview(textField)
        view.addSubview(buttonStackView)
        view.addSubview(mainTextLabel)
        view.addSubview(textLabel)
        buttonStackView.addArrangedSubview(statisticButton)
        buttonStackView.addArrangedSubview(startGameButton)
        
        //Constraint
        NSLayoutConstraint.activate([
            mainTextLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            mainTextLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            mainTextLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            
            textLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            textLabel.topAnchor.constraint(equalTo: mainTextLabel.bottomAnchor, constant: 20),
            
            textField.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 20),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            textField.heightAnchor.constraint(equalToConstant: 60),
            
            buttonStackView.topAnchor.constraint(greaterThanOrEqualTo: textField.bottomAnchor, constant: 20),
            buttonStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buttonStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            buttonStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            
            statisticButton.heightAnchor.constraint(equalToConstant: 60),
            startGameButton.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
    
    //MARK: - Actions
    
    @objc func didTapStartGameButton() {
        if let name = textField.text, !name.isEmpty {
            handleStartGameForName(name)
        }
    }
    
    @objc func didTapStatisticButton() {
        let statisticsViewController = StatisticsViewController()
        present(statisticsViewController, animated: true)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        updateStartButtonState()
    }
    
    //MARK: - Helper Methods
    
    private func handleStartGameForName(_ name: String) {
        cardGameStore.fetchPlayer(withName: name) { (player, error) in
            if player != nil {
                self.showAlert(withTitle: "Ошибка", message: "Имя игрока уже существует. Пожалуйста, введите другое имя.")
            } else {
                self.savePlayerAndStartGame(withName: name)
            }
        }
    }
    
    private func savePlayerAndStartGame(withName name: String) {
        self.cardGameStore.savePlayer(name: name, score: 0, wins: 0) { (error) in
            if let error = error {
                print("Failed to save \(error)")
            } else {
                let cardGameViewController = CardGameViewController()
                cardGameViewController.modalPresentationStyle = .fullScreen
                self.present(cardGameViewController, animated: true)
            }
        }
    }
    
    private func updateStartButtonState() {
        if let text = textField.text, !text.isEmpty {
            startGameButton.isEnabled = true
            startGameButton.backgroundColor = .black
        } else {
            startGameButton.isEnabled = false
            startGameButton.backgroundColor = .gray
        }
    }
    
    private func showAlert(withTitle title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "ОК", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
}

//test
