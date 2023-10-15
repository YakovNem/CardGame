import UIKit

//MARK: - Protocols

protocol StatisticsViewControllerDelegate: AnyObject {
    func didCloseStatistics()
}

//MARK: - StatisticsViewController

class StatisticsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //MARK: - Properties
    
    private var players: [Player] = []
    private let tableView = UITableView()
    private let store = CardGameStore()
    
    weak var delegate: StatisticsViewControllerDelegate?
    
    //MARK: - UI Elements
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.setTitle("Назад", for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "Таблица лидеров пуста"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        loadData()
        setupLayout()
    }
    
    //MARK: - Setup Methods
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(StatisticsCell.self, forCellReuseIdentifier: StatisticsCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupLayout() {
        view.addSubview(tableView)
        view.addSubview(backButton)
        view.addSubview(emptyLabel)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            backButton.heightAnchor.constraint(equalToConstant: 60),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            backButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            backButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            
            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    //MARK: - Actions
    
    @objc private func didTapBackButton() {
        delegate?.didCloseStatistics()
        dismiss(animated: true, completion: nil)
    }
    
    private func loadData() {
        store.fetchPlayers { (players, error) in
            if let players = players {
                self.players = players.sorted(by: { $0.score > $1.score })
                self.emptyLabel.isHidden = !self.players.isEmpty
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } else if let error = error {
                print("Failed to fetch players: \(error)")
                self.emptyLabel.isHidden = false
            }
        }
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StatisticsCell.identifier, for: indexPath) as! StatisticsCell
        let player = players[indexPath.row]
        cell.configure(with: player, position: indexPath.row + 1)
        return cell
    }
}


