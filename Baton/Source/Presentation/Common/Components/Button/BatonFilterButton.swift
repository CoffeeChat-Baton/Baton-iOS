import UIKit

protocol BatonFilterButtonDelegate: AnyObject {
    func didTapFilterButton(_ button: BatonFilterButton)
}

class BatonFilterButton: UIView {
    
    weak var delegate: BatonFilterButtonDelegate?
    
    // 🔹 버튼 텍스트 Label
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "필터 선택"
        label.pretendardStyle = .body3
        label.textColor = .bblack
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // 🔹 아래 화살표 아이콘
    private let arrowImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "chevron.down"))
        imageView.tintColor = .bblack
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // 🔹 버튼 터치 이벤트용 UIButton (투명)
    private let button: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
        
    init(title: String) {
        super.init(frame: .zero)
        titleLabel.text = title
        setupView()
        setupGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        layer.cornerRadius = 10
        clipsToBounds = true
        
        addSubview(titleLabel)
        addSubview(arrowImageView)
        addSubview(button) // 버튼을 전체 영역으로 만들어 터치 가능하게 설정

        NSLayoutConstraint.activate([
            // 버튼 전체 영역 설정
            button.topAnchor.constraint(equalTo: topAnchor),
            button.leadingAnchor.constraint(equalTo: leadingAnchor),
            button.trailingAnchor.constraint(equalTo: trailingAnchor),
            button.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            // 텍스트 위치
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            
            // 화살표 위치
            arrowImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            arrowImageView.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 8),
            arrowImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            arrowImageView.widthAnchor.constraint(equalToConstant: 16),
            arrowImageView.heightAnchor.constraint(equalToConstant: 16)
        ])
    }
    
    private func setupGesture() {
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    @objc private func buttonTapped() {
        delegate?.didTapFilterButton(self) // Delegate를 통해 모달 띄우기
    }
    
    func updateSelectedOption(_ option: String) {
        titleLabel.text = option
    }
}


#if DEBUG
import SwiftUI

struct BatonFilterButtonRepresentable: UIViewRepresentable {
    
    class Coordinator: BatonFilterButtonDelegate {
        var parent: BatonFilterButtonRepresentable
        
        init(_ parent: BatonFilterButtonRepresentable) {
            self.parent = parent
        }
        
        func didTapFilterButton(_ button: BatonFilterButton) {
            print("Filter button tapped!") // 미리보기에서 탭 이벤트 확인
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    func makeUIView(context: Context) -> BatonFilterButton {
        let button = BatonFilterButton(title: "필터 선택")
        button.delegate = context.coordinator
        return button
    }
    
    func updateUIView(_ uiView: BatonFilterButton, context: Context) {}
}

struct BatonFilterButton_Previews: PreviewProvider {
    static var previews: some View {
        BatonFilterButtonRepresentable()
            .frame(width: 100, height: 40)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
#endif
