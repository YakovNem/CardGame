import UIKit

class StatisticsCell: UITableViewCell {
    
    //MARK: - Properties
    
    static let identifier = "StatisticsCell"
    
    private let nameLabel = UILabel()
    private let scoreLabel = UILabel()
    private let winsLabel = UILabel()
    
    private var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    //MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Setup Methods
    
    private func setupLayout() {
        //Add Views
        addSubview(stackView)
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(scoreLabel)
        stackView.addArrangedSubview(winsLabel)
        
        //Constraint
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
    
    //MARK: - Configuration
    
    func configure(with player: Player, position: Int) {
        nameLabel.text = player.name ?? ""
        scoreLabel.text = "Очки: \(player.score)"
        winsLabel.text = "Победы: \(player.wins)"
    }
}
