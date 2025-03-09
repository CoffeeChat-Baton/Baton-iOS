import UIKit

class CheckDateView: UIView {
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.pretendardStyle = .body2
        label.textColor = .bblack
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(resource: .calendar)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    init(date: String = "") {
        super.init(frame: .zero)
        setupUI()
        setupConstraint()
        updateDateLabel(date)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        layer.cornerRadius = 12
        layer.borderColor = UIColor.gray2.cgColor
        layer.borderWidth = 1
        
        addSubview(dateLabel)
        addSubview(imageView)
    }
    
    private func setupConstraint() {
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            
            dateLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            dateLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 8)
        ])
    }
    
    func updateDateLabel(_ date: String) {
        dateLabel.text = DateUtil.formatToKoreanDate(date) ?? "날짜를 선택해주세요"
        dateLabel.textColor = date.isEmpty ? .gray4 : .bblack
    }
}
