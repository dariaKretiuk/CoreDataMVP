import Foundation
import UIKit
import CoreData

final class InfoPersonController: UIViewController {
    
    // MARK: - Elements
    private(set) var presenter: PresenterInput!
    private var isTappedUpdate = false
    private var person: NSManagedObject?
    private var row: Int
    private let gendersList: [String] = ["Others" , "Male", "Female"]
    
    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.long
        dateFormatter.timeStyle = DateFormatter.Style.none
        return dateFormatter
    }()
    
    private let buttonRight: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor.black, for: .normal)
        button.setTitle("Редактировать", for: .normal)
        button.tintColor = .black
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let imageContainer: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        view.backgroundColor = .clear
        view.contentMode = .center
        return view
    }()
    
    private let image: UIImageView = {
        let img = UIImageView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        img.contentMode = .center
        img.contentMode = .scaleAspectFill
        img.image = UIImage(named: "iconSecondWindow")
        img.layer.cornerRadius = 100
        img.translatesAutoresizingMaskIntoConstraints = false
        img.tintColor = .white
        img.clipsToBounds = true
        return img
    }()
    
    private let name: UITextField = {
        let textField = UITextField()
        let imageView = UIImageView(frame: CGRect(x: 0, y: 8, width: 24.0, height: 35))
        let image = UIImage(systemName: "person")
        imageView.image = image
        imageView.tintColor = .gray
        imageView.contentMode = .scaleAspectFit
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 65, height: 50))
        view.addSubview(imageView)
        textField.attributedPlaceholder =
        NSAttributedString(string: "Name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray, NSAttributedString.Key.font: UIFont(name: "Georgia", size: 15.0)!])
        textField.textAlignment = .left
        textField.textColor = .black
        textField.backgroundColor = .clear
        textField.leftView = view
        textField.leftViewMode = .always
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let dataPicker: UIDatePicker = {
        var picker : UIDatePicker = UIDatePicker()
        picker.datePickerMode = .date
        picker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        var pickerSize: CGSize = picker.sizeThatFits(CGSize.zero)
        picker.frame = CGRect(x: 0.0, y: 250, width: pickerSize.width, height: 460)
        return picker
    }()
    
    private let imageBirthday: UIImageView = {
        let img = UIImageView(frame: CGRect(x: 0, y: 8, width: 24.0, height: 35))
        img.image = UIImage(systemName: "calendar")
        img.tintColor = .gray
        img.contentMode = .scaleAspectFit
        return img
    }()
    
    private let stackViewBirthday: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        return stackView
    }()
    
    private let pickerGenders: UIPickerView = {
        let pickerView = UIPickerView()
        return pickerView
    }()
    
    private let genders: UITextField = {
        let textField = UITextField()
        let imageView = UIImageView(frame: CGRect(x: 0, y: 8, width: 24.0, height: 35))
        let image = UIImage(systemName: "figure.stand")
        imageView.image = image
        imageView.tintColor = .gray
        imageView.contentMode = .scaleAspectFit
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 65, height: 50))
        view.addSubview(imageView)
        textField.attributedPlaceholder =
        NSAttributedString(string: "Genders", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray, NSAttributedString.Key.font: UIFont(name: "Georgia", size: 15.0)!])
        textField.textAlignment = .left
        textField.textColor = .black
        textField.backgroundColor = .clear
        textField.leftView = view
        textField.leftViewMode = .always
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // MARK: - Lifecycle
    
    init(forRow row: Int, presenter: PresenterInput) {
        self.row = row
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.setupHierarchy()
        self.setupLayouts()
        self.createData()
        self.configurView()
    }
    
    // MARK: - Private functions
    
    private func createData() {
        guard let model = presenter.person(forRow: row) else {
            return
        }
        person = model
    }
    
    private func setupView() {
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: buttonRight)
        buttonRight.addTarget(self, action: #selector(updateData), for: .touchUpInside)
    }
    
    private func setupHierarchy() {
        pickerGenders.dataSource = self
        pickerGenders.delegate = self
        
        view.addSubview(stackView)
        stackView.addArrangedSubview(imageContainer)
        imageContainer.addSubview(image)
        stackView.addArrangedSubview(name)
        stackView.addArrangedSubview(stackViewBirthday)
        stackViewBirthday.addArrangedSubview(imageBirthday)
        stackViewBirthday.addArrangedSubview(dataPicker)
        stackView.addArrangedSubview(genders)
        genders.inputView = pickerGenders
        pickerGenders.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        name.isEnabled = false
        dataPicker.isEnabled = false
        genders.isEnabled = false
    }
    
    private func setupLayouts() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 120),
            stackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 100),
            stackView.widthAnchor.constraint(equalToConstant: 200),
            imageContainer.widthAnchor.constraint(equalToConstant: 200),
            imageContainer.heightAnchor.constraint(equalToConstant: 200),
            image.centerYAnchor.constraint(equalTo: imageContainer.centerYAnchor),
            image.centerXAnchor.constraint(equalTo: imageContainer.centerXAnchor),
            image.widthAnchor.constraint(equalToConstant: 200),
            image.heightAnchor.constraint(equalToConstant: 200),
            name.heightAnchor.constraint(equalToConstant: 40),
            genders.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    // MARK: - Action
    
    @objc private func updateData() {
        if isTappedUpdate {
            buttonRight.setTitle("Редактировать", for: .normal)
            presenter.updateInfoObject(row: self.row,
                                       name: name.text ?? "",
                                       birthday: self.convertDateToString(dataPicker.date),
                                       gender: genders.text ?? ""
            )
        } else {
            buttonRight.setTitle("Сохранить", for: .normal)
        }
        name.isEnabled.toggle()
        genders.isEnabled.toggle()
        dataPicker.isEnabled.toggle()
        isTappedUpdate.toggle()
    }
    
    func convertDateToString(_ date: Date) -> String {
        return dateFormatter.string(from: date)
    }
    
    func convertStringToDate(_ stringDate: String) -> Date {
        return dateFormatter.date(from: stringDate) ?? Date.now
    }
    
    @objc private func closeInfo() {
        dismiss(animated: true)
    }
    
    @objc private func dateChanged() {
    }
    
    // MARK: - Configuration
    
    private func configurView() {
        name.text = person?.value(forKey: "name") as? String
        genders.text = person?.value(forKey: "gender") as? String
        guard let date = person?.value(forKey: "birthday") else {
            return
        }
        dataPicker.date = self.convertStringToDate(date as! String)
    }
}

extension InfoPersonController: PresenterOutput {
    
    func updatePeoples() {
    }
}

// MARK: - Data Source Picker Genders

extension InfoPersonController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return gendersList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return gendersList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        genders.text = gendersList[row]
        genders.resignFirstResponder()
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        60
    }
}

// MARK: - Delegate picker

extension InfoPersonController: UIPickerViewDelegate {

}
