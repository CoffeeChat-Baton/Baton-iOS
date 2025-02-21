import UIKit

protocol ScheduleSelectionModalDelegate: AnyObject {
    func didSelectSchedule(days: [String], startTime: String, endTime: String)
}

class ScheduleSelectionModal: UIViewController {
    weak var delegate: ScheduleSelectionModalDelegate?
    
    private let modalView = UIView()
    private let headerView: ModalHeaderView
    
    private var modalHeightConstraint: NSLayoutConstraint?

    private var actionButton: BasicButton = {
        let button = BasicButton(title: "확인", status: .enabled)
        button.isEnabled = true
        button.isUserInteractionEnabled = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    init(headerTitle: String){
        self.headerView = ModalHeaderView(title: headerTitle)
        super.init(nibName: nil, bundle: nil)
        setupUI()
        addSubViews()
        setupConstraint()
        setupAction()
        
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .coverVertical
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        modalView.backgroundColor = .white
        modalView.layer.cornerRadius = 16
        modalView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    private func addSubViews() {
        view.addSubview(modalView)
        modalView.addSubview(headerView)
        modalView.translatesAutoresizingMaskIntoConstraints = false
        headerView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupConstraint(){
        modalHeightConstraint = modalView.heightAnchor.constraint(greaterThanOrEqualToConstant: 200)
        modalHeightConstraint?.isActive = true

        NSLayoutConstraint.activate([
            modalView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            modalView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            modalView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            headerView.leadingAnchor.constraint(equalTo: modalView.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: modalView.trailingAnchor),
            headerView.topAnchor.constraint(equalTo: modalView.topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 52),
        ])

    }
    
    private func setupAction() {
        headerView.onCloseTapped = { [weak self] in
            self?.dismissModal()
        }
        actionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - Button Actions

    @objc private func actionButtonTapped(){
        
    }
    
    @objc private func dismissModal() {
        UIView.animate(withDuration: 0.3, animations: {
            self.modalView.transform = CGAffineTransform(translationX: 0, y: self.modalView.frame.height)
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0)
        }) { _ in
            self.dismiss(animated: false)
        }
    }
    
}
