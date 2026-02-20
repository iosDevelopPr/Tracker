
import UIKit

final class EditCategoryViewController: UIViewController {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    } ()
    
    private let fieldContainer = UIView()
    private let nameField = UITextField()
    private let warningLabel: UILabel = {
        let label = UILabel()
        label.text = Localization.nameFieldMaxLengthLabel
        label.backgroundColor = .trackerWhite
        label.textColor = .trackerBorderRed
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    } ()
    
    private let createButton: UIButton = {
        let button = UIButton()
        button.setTitle(Localization.readyButton, for: .normal)
        button.setTitleColor(.trackerWhite, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        return button
    } ()

    private var textFieldContainerHeightConstraint: NSLayoutConstraint?
    private var isWarningHidden = true
    private let placeholderCategory = Localization.categoryPlaceholder
    private let maxSymbolsCountTextField = 38
    
    private var nameFieldManager: NameFieldManager?
    private let editNameCategory: String?
    
    init(nameCategory: String?) {
        self.editNameCategory = nameCategory
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .trackerWhite
        setupUI()
    }
    
    private func setupUI() {
        setupTitle()
        setupNameFieldContainer()
        setupNameField()
        setupCreateButton()
        
        setupGestureRecognizer()
        
        setButtonDisable()
        
        if let editNameCategory {
            self.nameField.text = editNameCategory
            
            let symbolsCount = nameField.text?.count ?? 0
            if symbolsCount > 0 && symbolsCount <= maxSymbolsCountTextField {
                setButtonEnable()
            }
        }
    }
    
    private func setupTitle() {
        if editNameCategory != nil {
            titleLabel.text = Localization.editCategoryTitle
        } else {
            titleLabel.text = Localization.newCategoryTitle
        }
        
        view.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 17),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 49)
        ])
    }
    
    private func setupNameFieldContainer() {
        fieldContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(fieldContainer)

        textFieldContainerHeightConstraint = fieldContainer.heightAnchor.constraint(equalToConstant: 75)
        textFieldContainerHeightConstraint?.isActive = true
        
        NSLayoutConstraint.activate([
            fieldContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            fieldContainer.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            fieldContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            fieldContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }

    private func setupNameField() {
        fieldContainer.addSubview(nameField)
   
        NSLayoutConstraint.activate([
            nameField.heightAnchor.constraint(equalToConstant: 75),
            nameField.topAnchor.constraint(equalTo: fieldContainer.topAnchor),
            nameField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
        nameFieldManager = NameFieldManager(
            nameField: nameField,
            presenter: nil,
            placeholder: placeholderCategory)
        
        nameField.delegate = self
        nameFieldManager?.addDelegate(delegate: self)
    }

    private func setupWarningLabel() {
        fieldContainer.addSubview(warningLabel)

        NSLayoutConstraint.activate([
            warningLabel.heightAnchor.constraint(equalToConstant: 22),
            warningLabel.topAnchor.constraint(equalTo: nameField.bottomAnchor, constant: 8),
            warningLabel.leadingAnchor.constraint(equalTo: fieldContainer.leadingAnchor),
            warningLabel.trailingAnchor.constraint(equalTo: fieldContainer.trailingAnchor)
        ])
    }
    
    private func setupCreateButton() {
        view.addSubview(createButton)
        createButton.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            createButton.heightAnchor.constraint(equalToConstant: 60),
            createButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            createButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            createButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }

    private func setupGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }

    @objc private func hideKeyboard() {
        view.endEditing(true)
    }

    func setButtonEnable() {
        createButton.backgroundColor = .trackerBackgroundBlack
        createButton.isEnabled = true
    }

    func setButtonDisable() {
        createButton.backgroundColor = .trackerForLightGray
        createButton.isEnabled = false
    }

    @objc private func createButtonTapped() {
        guard let nameCategory = nameField.text, !nameCategory.isEmpty else { return }
        let categoryDataProvider = CategoryDataProvider()
        
        if let editNameCategory {
            try? categoryDataProvider.updateCategory(name: nameCategory, nameOld: editNameCategory)
        } else {
            try? categoryDataProvider.addCategory(name: nameCategory)
        }
        
        dismiss(animated: true)
    }
}

extension EditCategoryViewController: NameFieldManagerDelegate {
    func showWarningLabel() {
        if isWarningHidden {
            textFieldContainerHeightConstraint?.constant = 113
            setupWarningLabel()
            isWarningHidden = false
        }
    }
    
    func hideWarningLabel() {
        if !isWarningHidden {
            textFieldContainerHeightConstraint?.constant = 75
            warningLabel.removeFromSuperview()
            isWarningHidden = true
        }
    }
}

extension EditCategoryViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        hideWarningLabel()
        setButtonDisable()
        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
            replacementString string: String) -> Bool {
        guard let currentText = textField.text,
              let stringRange = Range(range, in: currentText) else { return false }
        
        let symbolsCount = currentText.replacingCharacters(in: stringRange, with: string).count
        if symbolsCount == 0 {
            hideWarningLabel()
            setButtonDisable()
        } else if symbolsCount > 0 && symbolsCount <= maxSymbolsCountTextField {
            hideWarningLabel()
            setButtonEnable()
        } else if symbolsCount > maxSymbolsCountTextField {
            showWarningLabel()
            setButtonDisable()
            return false
        }
        return true
    }
}
