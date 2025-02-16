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
    private let titleLabel = UILabel()
    private let closeButton = UIButton(type: .system)
    private let optionsStackView = UIStackView()
    private var modalHeightConstraint: NSLayoutConstraint?
    
    private let headerTitle: String
    private let options: [String]
    
    // MARK: - Init
    init(headerTitle: String, options: [String], selectionType: T, delegate: D) {
        self.headerTitle = headerTitle
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
        updateData()
        animateModalAppearance()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        modalView.backgroundColor = .white
        modalView.layer.cornerRadius = 16
        modalView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        modalView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(modalView)
        
        let configuration = UIImage.SymbolConfiguration(pointSize: 18, weight: .bold)
        let closeImage = UIImage(systemName: "xmark", withConfiguration: configuration)
        closeButton.setImage(closeImage, for: .normal)
        closeButton.tintColor = .black
        closeButton.addTarget(self, action: #selector(dismissModal), for: .touchUpInside)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        titleLabel.textColor = .black
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        optionsStackView.axis = .vertical
        optionsStackView.spacing = 8
        optionsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        modalView.addSubview(closeButton)
        modalView.addSubview(titleLabel)
        modalView.addSubview(optionsStackView)
        
        modalHeightConstraint = modalView.heightAnchor.constraint(equalToConstant: 200)
        modalHeightConstraint?.isActive = true
        
        NSLayoutConstraint.activate([
            modalView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            modalView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            modalView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            closeButton.topAnchor.constraint(equalTo: modalView.topAnchor, constant: 16),
            closeButton.leadingAnchor.constraint(equalTo: modalView.leadingAnchor, constant: 16),
            closeButton.widthAnchor.constraint(equalToConstant: 24),
            closeButton.heightAnchor.constraint(equalToConstant: 24),
            
            titleLabel.centerXAnchor.constraint(equalTo: modalView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: closeButton.centerYAnchor),
            
            optionsStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15),
            optionsStackView.leadingAnchor.constraint(equalTo: modalView.leadingAnchor, constant: 20),
            optionsStackView.trailingAnchor.constraint(equalTo: modalView.trailingAnchor, constant: -20),
            optionsStackView.bottomAnchor.constraint(equalTo: modalView.bottomAnchor, constant: -15)
        ])
    }
    
    // MARK: - Load Options
    private func updateData() {
        titleLabel.text = headerTitle
        
        optionsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        options.forEach { option in
            let button = UIButton(type: .system)
            button.setTitle(option, for: .normal)
            button.setTitleColor(.black, for: .normal)
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

