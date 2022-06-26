import UIKit

class ViewController: UIViewController {
    
    // MARK: - Elements
    
    private(set) var presenter: PresenterInput!
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.setTitle("Добавить", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(searchCharacters), for: .touchUpInside)
        return button
    }()

    private let textField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder =
        NSAttributedString(string: "Введите текст", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont(name: "Georgia", size: 15.0)!])
        textField.textAlignment = .left
        textField.textColor = .black
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.setupHierarchy()
        self.setupLayouts()
        self.setupTable()
        self.setupPresenter()
    }
    
    // MARK: - Private functions
    
    private func setupPresenter() {
        presenter = Presenter(view: self)
        presenter.loadPeoples()
    }
    
    private func setupView() {
        view.backgroundColor = .white
        navigationItem.title = "Persons"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupHierarchy() {
        view.addSubview(stackView)
        stackView.addArrangedSubview(textField)
        stackView.addArrangedSubview(button)
        view.addSubview(tableView)
    }
    
    private func setupTable() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TableCell.self, forCellReuseIdentifier: TableCell.identifier)
        tableView.backgroundColor = .white
    }
    
    private func setupLayouts() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: stackView.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 120),
            stackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            stackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 50),
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 120),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textField.leftAnchor.constraint(equalTo: stackView.leftAnchor),
            textField.rightAnchor.constraint(equalTo: button.leftAnchor),
            button.rightAnchor.constraint(equalTo: stackView.rightAnchor),
            button.leftAnchor.constraint(equalTo: textField.rightAnchor)
        ])
    }

    // MARK: - Action
    
    @objc private func searchCharacters(_ sender: UIButton) {
        print("Add: \(textField.text ?? "")")
        presenter.addObject(name: textField.text ?? "", birthday: nil, gender: nil)
        textField.text = ""
    }
}

// MARK: - Table Data Source

extension ViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfProducts
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let model = presenter.person(forRow: indexPath.row) else {
            return UITableViewCell()
        }

        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableCell.identifier, for: indexPath) as? TableCell else {
            return UITableViewCell()
        }

        cell.configure(with: model)

        return cell
    }
}

// MARK: - Table Delegate

extension ViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        navigationController?.pushViewController(InfoPersonController(forRow: indexPath.row, presenter: presenter), animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let contextItem = UIContextualAction(style: .destructive, title: "Удалить") {  (contextualAction, view, boolValue) in
            self.presenter.deleteObject(row: indexPath.row)
        }
        let swipeActions = UISwipeActionsConfiguration(actions: [contextItem])
        return swipeActions
    }
}

extension ViewController: PresenterOutput {
    func updatePeoples() {
        self.tableView.reloadData()
    }
}

