import UIKit

protocol SelectionModalDelegate: AnyObject {
    associatedtype SelectionType
    func didSelectOption(_ option: String, type: SelectionType)
}

class SelectionModal<T, D: SelectionModalDelegate>: UIViewController where D.SelectionType == T {
    // MARK: - Properties
    weak var delegate: D?
    private let selectionType: T
    private let modalView = UIView()
//    private let titleLabel = UILabel()
//    private let closeButton = UIButton(type: .system)
    private let optionsScrollView = UIScrollView()
    private let optionsStackView = UIStackView()
    private var modalHeightConstraint: NSLayoutConstraint?
    
    private let headerView: ModalHeaderView
    private let options: [String]
    
    // MARK: - Init
    init(headerTitle: String, options: [String], selectionType: T, delegate: D) {
        self.headerView = ModalHeaderView(title: headerTitle)
        self.options = options
        self.selectionType = selectionType
        self.delegate = delegate
        
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .coverVertical
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        addSubViews()
        setupConstraint()
        setupAction()
        updateData()
        animateModalAppearance()
    }
    
    // MARK: - UI Setup
    private func addSubViews() {
        view.addSubview(modalView)
        modalView.addSubview(headerView)
        modalView.addSubview(optionsScrollView)
        optionsScrollView.addSubview(optionsStackView)
        
        modalView.translatesAutoresizingMaskIntoConstraints = false
        headerView.translatesAutoresizingMaskIntoConstraints = false
        optionsScrollView.translatesAutoresizingMaskIntoConstraints = false
        optionsStackView.translatesAutoresizingMaskIntoConstraints = false

    }
    
    private func setupUI() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        modalView.backgroundColor = .white
        modalView.layer.cornerRadius = 16
        modalView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        optionsScrollView.alwaysBounceVertical = true
        
        optionsStackView.axis = .vertical
        optionsStackView.spacing = 8
    }
    
    private func setupConstraint() {
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
            
            optionsScrollView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            optionsScrollView.leadingAnchor.constraint(equalTo: modalView.leadingAnchor, constant: 20),
            optionsScrollView.trailingAnchor.constraint(equalTo: modalView.trailingAnchor, constant: -20),
            optionsScrollView.bottomAnchor.constraint(equalTo: modalView.bottomAnchor, constant: -15),

            optionsStackView.topAnchor.constraint(equalTo: optionsScrollView.topAnchor),
            optionsStackView.leadingAnchor.constraint(equalTo: optionsScrollView.leadingAnchor),
            optionsStackView.trailingAnchor.constraint(equalTo: optionsScrollView.trailingAnchor),
            optionsStackView.bottomAnchor.constraint(equalTo: optionsScrollView.bottomAnchor)
        ])
    }
    
    private func setupAction(){
        headerView.onCloseTapped = { [weak self] in
               self?.dismissModal()
           }
           
    }
    
    // MARK: - Load Options
    private func updateData() {
        optionsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        options.forEach { option in
            let button = UIButton(type: .system)
            button.setTitle(option, for: .normal)
            button.contentHorizontalAlignment = .left
            button.setTitleColor(.bblack, for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: 48).isActive = true
            button.addTarget(self, action: #selector(optionSelected(_:)), for: .touchUpInside)
            optionsStackView.addArrangedSubview(button)
        }
        
        let estimatedHeight = CGFloat(80 + (options.count * (48 + 8)))
        let maxHeight = view.frame.height * 0.9
        modalHeightConstraint?.constant = min(estimatedHeight, maxHeight)
    }
    
    
    // MARK: - Button Actions
    @objc private func optionSelected(_ sender: UIButton) {
        guard let selectedText = sender.titleLabel?.text else { return }
        delegate?.didSelectOption(selectedText, type: selectionType)
        dismissModal()
    }
    
    @objc private func dismissModal() {
        UIView.animate(withDuration: 0.3, animations: {
            self.modalView.transform = CGAffineTransform(translationX: 0, y: self.modalView.frame.height)
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0)
        }) { _ in
            self.dismiss(animated: false)
        }
    }
    
    // MARK: - Modal Animation
    private func animateModalAppearance() {
        modalView.transform = CGAffineTransform(translationX: 0, y: modalView.frame.height)
        UIView.animate(withDuration: 0.3) {
            self.modalView.transform = .identity
        }
    }
}

