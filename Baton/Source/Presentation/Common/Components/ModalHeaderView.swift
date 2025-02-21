import UIKit

class ModalHeaderView: UIView {
    private let titleLabel = UILabel()
    private let closeButton = UIButton(type: .system)
    
    var onCloseTapped: (() -> Void)?

    init(title: String) {
        super.init(frame: .zero)
        setupUI(title: title)
        addSubviews()
        setupConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(title: String){
        titleLabel.text = title

        let configuration = UIImage.SymbolConfiguration(pointSize: 18, weight: .bold)
        let closeImage = UIImage(systemName: "xmark", withConfiguration: configuration)
        
        closeButton.setImage(closeImage, for: .normal)
        closeButton.tintColor = .black
        closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        titleLabel.textColor = .black
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func addSubviews() {
        addSubview(closeButton)
        addSubview(titleLabel)
    }
    
    private func setupConstraint() {
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            closeButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            closeButton.widthAnchor.constraint(equalToConstant: 24),
            closeButton.heightAnchor.constraint(equalToConstant: 24),
            
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])

    }
    
    @objc private func closeTapped() {
            onCloseTapped?()
    }
}
