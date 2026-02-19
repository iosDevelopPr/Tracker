
import UIKit

final class FilterManager {
    
    private var filterButton: UIButton = {
        let button = UIButton()
        button.setTitle(Localization.filters, for: .normal)
        button.backgroundColor = .trackerBlue
        button.setTitleColor(.trackerWhite, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        button.layer.cornerRadius = 16
        return button
    } ()
    
    var view: FiltersViewProtocol?
    
    init() {
        setupButton()
    }
    
    @objc private func filterButtonTapped() {
        AnalyticsService.shared.logEvent(
            event: .click,
            screen: .Main,
            item: .filter
        )

        let filter = view?.getFilter() ?? .all
        let filterVC = FiltersViewController(filter: filter)
        filterVC.delegate = view
        view?.present(filterVC, animated: true)
    }
    
    private func setupButton() {
        guard let window =
            UIApplication.shared.windows.first(where: { $0.isKeyWindow })
        else { return }
        
        filterButton.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
        filterButton.frame =
            CGRect(
                x: (window.frame.width - 114) / 2,
                y: (window.frame.height - 150),
                width: 114,
                height: 50
            )
    }
    
    func showFilterButton() {
        guard let view else { return }
        
        if !view.view.subviews.contains(filterButton) {
            view.view.addSubview(filterButton)
            view.view.bringSubviewToFront(filterButton)
        }
    }
    
    func hideFilterButton() {
        filterButton.removeFromSuperview()
    }
}
