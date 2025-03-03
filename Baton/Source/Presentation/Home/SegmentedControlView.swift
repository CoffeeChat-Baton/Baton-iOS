import UIKit

protocol SegmentedControlViewDelegate: AnyObject {
    func segmentedControlView(_ view: SegmentedControlView, didSelectIndex index: Int)
}

class SegmentedControlView: UIView {
    
    // MARK: - Properties
    weak var delegate: SegmentedControlViewDelegate?
    
    private let indicatorView = UIView()
    private let grayLineView = UIView()
    private var buttons: [UIButton] = []
    private var indicatorLeadingConstraint: NSLayoutConstraint?
    
    var segmentTitles: [String] = [] {
        didSet { setupButtons() }
    }
    
    private var selectedIndex: Int = 0
    
    // MARK: - Initializer
    init(segmentTitles: [String]) {
        self.segmentTitles = segmentTitles
        super.init(frame: .zero)
        setupView()
        setupButtons()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupView() {
        backgroundColor = .white
    }
    
    private func setupButtons() {
        subviews.forEach { $0.removeFromSuperview() }
        buttons.removeAll()
        
        let buttonStackView = UIStackView()
        buttonStackView.axis = .horizontal
        buttonStackView.alignment = .fill
        buttonStackView.distribution = .fillEqually
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(buttonStackView)
        
        NSLayoutConstraint.activate([
            buttonStackView.topAnchor.constraint(equalTo: topAnchor),
            buttonStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            buttonStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            buttonStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        for (index, title) in segmentTitles.enumerated() {
            let button = UIButton(type: .system)
            button.setTitle(title, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
            button.setTitleColor(index == selectedIndex ? .bblack : .gray2, for: .normal)
            button.tag = index
            button.addTarget(self, action: #selector(segmentTapped(_:)), for: .touchUpInside)
            buttonStackView.addArrangedSubview(button)
            buttons.append(button)
        }
        
        // 🔹 회색 줄 추가 (전체 너비)
        grayLineView.translatesAutoresizingMaskIntoConstraints = false
        grayLineView.backgroundColor = .gray2
        addSubview(grayLineView)
        
        NSLayoutConstraint.activate([
            grayLineView.heightAnchor.constraint(equalToConstant: 2),
            grayLineView.leadingAnchor.constraint(equalTo: leadingAnchor),
            grayLineView.trailingAnchor.constraint(equalTo: trailingAnchor),
            grayLineView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        // 🔹 검정색 인디케이터 추가
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        indicatorView.backgroundColor = .bblack
        addSubview(indicatorView)
        
        indicatorLeadingConstraint = indicatorView.leadingAnchor.constraint(equalTo: leadingAnchor)
        
        NSLayoutConstraint.activate([
            indicatorView.heightAnchor.constraint(equalToConstant: 2),
            indicatorView.bottomAnchor.constraint(equalTo: bottomAnchor),
            indicatorLeadingConstraint!
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // 🔹 화면 크기 확정 후 인디케이터의 너비 설정
        let buttonWidth = frame.width / CGFloat(segmentTitles.count)
        indicatorView.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
    }
    
    // MARK: - Actions
    @objc private func segmentTapped(_ sender: UIButton) {
        let index = sender.tag
        delegate?.segmentedControlView(self, didSelectIndex: index)
        moveIndicator(to: index)
        updateButtonColors(selectedIndex: index)
    }
    
    func moveIndicator(to index: Int) {
        let buttonWidth = frame.width / CGFloat(segmentTitles.count)
        indicatorLeadingConstraint?.constant = CGFloat(index) * buttonWidth
        UIView.animate(withDuration: 0.3) { self.layoutIfNeeded() }
    }
    
    private func updateButtonColors(selectedIndex: Int) {
        for (index, button) in buttons.enumerated() {
            button.setTitleColor(index == selectedIndex ? .bblack : .gray2, for: .normal)
        }
    }
}
