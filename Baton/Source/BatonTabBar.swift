import UIKit

protocol BatonTabBarDelegate: AnyObject {
    func tabBarDidSelect(index: Int)
}

class BatonTabBar: UIView {
    weak var delegate: (BatonTabBarDelegate)?
    
    private var buttons: [UIButton] = []
    
    init(items: [(title: String, image: UIImage?)]) {
        super.init(frame: .zero)
        backgroundColor = .bwhite
        
        layer.cornerRadius = 12
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.04
        layer.shadowOffset = CGSize(width: 0, height: -5)
        layer.shadowRadius = 12
        
        setupButtons(items: items)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupButtons(items: [(title: String, image: UIImage?)]) {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        for (index, item) in items.enumerated() {
            let button = UIButton()
            
            // ✅ 버튼 설정
            var config = UIButton.Configuration.plain()
            config.image = item.image
            config.imagePlacement = .top
            config.imagePadding = 5
            config.baseBackgroundColor = .clear // ✅ 배경색 제거

            // ✅ 텍스트 스타일 설정 (폰트 적용)
            let font = UIFont.Pretendard.caption2.font
            let titleString = NSAttributedString(
                string: item.title,
                attributes: [
                    .font: font,
                    .foregroundColor: UIColor.gray3
                ]
            )
            config.attributedTitle = AttributedString(titleString)
            
            button.configuration = config
            button.tag = index
            button.addTarget(self, action: #selector(tabTapped(_:)), for: .touchUpInside)
            
            // ✅ 클릭 시 색상 변경 (이미지 & 텍스트)
            button.configurationUpdateHandler = { button in
                var updatedConfig = button.configuration
                let isSelected = button.isSelected
                let selectedColor: UIColor = isSelected ? .bblack : .gray3

                // ✅ 클릭 시 글씨 색상 변경
                updatedConfig?.baseForegroundColor = isSelected ? .bblack : .gray3
                // 클릭 시 이미지 색상 변경
                updatedConfig?.image = item.image?.withTintColor(selectedColor, renderingMode: .alwaysOriginal)

                // ✅ 클릭 시 폰트 색상 변경
                let updatedTitleString = NSAttributedString(
                    string: item.title,
                    attributes: [
                        .font: font,
                        .foregroundColor: isSelected ? UIColor.bblack : UIColor.gray3
                    ]
                )
                updatedConfig?.attributedTitle = AttributedString(updatedTitleString)
                
                button.configuration = updatedConfig
            }
            
            buttons.append(button)
            stackView.addArrangedSubview(button)
        }
        
        
        // 기본 선택된 탭 (홈)
        buttons.first?.isSelected = true
    }
    
    @objc private func tabTapped(_ sender: UIButton) {
        for button in buttons {
            button.isSelected = (button == sender)
        }
        
        delegate?.tabBarDidSelect(index: sender.tag)
    }
}
