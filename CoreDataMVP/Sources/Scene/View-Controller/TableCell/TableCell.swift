import Foundation
import UIKit
import CoreData

class TableCell: UITableViewCell {
    
    // MARK: - Elements
    
    static let identifier = "TableCell"
    
    private let label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .black
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupHierarchy()
        setupLayouts()
        contentView.clipsToBounds = true
        accessoryType = .disclosureIndicator
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setupHierarchy() {
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(label)
    }
    
    private func setupLayouts() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.rightAnchor.constraint(equalTo: rightAnchor),
            stackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = ""
    }
    
    // MARK: - Private functions
    
    public func configure(with model: NSManagedObject) {
        label.text = model.value(forKey: "name") as? String
    }
}
