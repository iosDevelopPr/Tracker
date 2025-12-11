
import UIKit

final class NameFieldManager: NSObject {
    private let nameField: UITextField
    private var delegate: NameFieldManagerDelegate?
    private var presenter: NewTrackerPresenterProtocol?
    
    private let placeholderText = "Введите название трекера"
    private let maxLength: Int = 38
    
    init(nameField: UITextField, presenter: NewTrackerPresenterProtocol) {
        self.nameField = nameField
        self.presenter = presenter
        super.init()

        setupNameField()
    }
    
    func addDelegate(delegate: NameFieldManagerDelegate) {
        self.delegate = delegate
    }
    
    private func setupNameField() {
        nameField.backgroundColor = .trackerLightGray
        nameField.textColor = .trackerBackgroundBlack
        nameField.font = UIFont.systemFont(ofSize: 19, weight: .regular)
        nameField.clearButtonMode = .whileEditing
        nameField.translatesAutoresizingMaskIntoConstraints = false
        
        nameField.layer.cornerRadius = 16
        nameField.layer.masksToBounds = true
        
        nameField.attributedPlaceholder = NSAttributedString(
            string: placeholderText,
            attributes: [.foregroundColor: UIColor(resource: .trackerForLightGray),
                         .backgroundColor: UIColor(resource: .trackerLightGray)])

        let paddingView = UIView(
            frame: CGRect(x: 0, y: 0, width: 16,
                height: nameField.frame.height
            )
        )
        nameField.leftView = paddingView
        nameField.leftViewMode = .always
        
        nameField.delegate = self
    }
}

extension NameFieldManager: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let name = textField.text else { return }
        presenter?.updateName(name: name)
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        delegate?.hideWarningLabel()
        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
            replacementString string: String) -> Bool {
        guard let currentText = textField.text,
              let stringRange = Range(range, in: currentText) else { return false }

        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        handleCharacterLimit(for: updatedText)
        return updatedText.count <= maxLength
    }

    private func handleCharacterLimit(for updatedText: String) {
        guard let delegate else { return }
        if updatedText.count > 38 {
            delegate.showWarningLabel()
        } else {
            delegate.hideWarningLabel()
        }
    }
}
