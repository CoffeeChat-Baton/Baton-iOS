import UIKit
import SwiftUI

class BatonTag: UIView {
    enum TagType {
        case time, category
        
        var cornerRadiusValue: CGFloat {
            switch self {
            case .time:
                return 16
            case .category:
                return 6
            }
        }
    }
    
    // 🔹 아이콘 이미지뷰 (선택적 표시)
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // 🔹 시간 표시 라벨
    private let minuteLabel: UILabel = {
        let label = UILabel()
        label.pretendardStyle = .body4
        label.textColor = .blue3
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // 아이콘 사용 여부
    private var showIcon: Bool = false
    private var currType: TagType = .category
    
    init(content: String, type: TagType) {
        super.init(frame: .zero)
        var icon: UIImage?
        
        switch type {
        case .time:
            icon = UIImage(resource: .clock)
        case .category:
            icon = nil
        }
        
        self.showIcon = (icon != nil) // 아이콘이 있으면 표시
        currType = type
        iconImageView.image = icon
        setupView()
        updateLabel(content)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateLabel(_ content: String) {
        switch currType {
        case .time:
            minuteLabel.text = "\(content)분"
        case .category:
            minuteLabel.text = "\(content)"
        }
    }
    
    private func setupView() {
        backgroundColor = .blue1
        layer.cornerRadius = currType.cornerRadiusValue
        clipsToBounds = true
        
        // 아이콘이 있는 경우에만 추가
        if showIcon {
            addSubview(iconImageView)
        }
        addSubview(minuteLabel)
        
        var constraints: [NSLayoutConstraint] = [
            minuteLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            minuteLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: showIcon ? 24 : 8),
            minuteLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
            self.heightAnchor.constraint(equalToConstant: 32)
        ]
        
        if showIcon {
            constraints.append(contentsOf: [
                iconImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                iconImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
                iconImageView.widthAnchor.constraint(equalToConstant: 16),
                iconImageView.heightAnchor.constraint(equalToConstant: 16),
                
                // 라벨을 아이콘 오른쪽으로 배치
                minuteLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 4)
            ])
        }
        
        NSLayoutConstraint.activate(constraints)
        
        // ✅ Hugging & Compression Resistance 설정
        minuteLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        minuteLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
    }
    
    // ✅ 내부 요소 크기에 맞춰 자동 조정되도록 설정
    override var intrinsicContentSize: CGSize {
        let iconWidth: CGFloat = showIcon ? 20 : 0 // 아이콘이 있을 경우 너비 추가
        let width = minuteLabel.intrinsicContentSize.width + iconWidth + 16 // 좌우 여백 포함
        let height: CGFloat = 32
        return CGSize(width: width, height: height)
    }
}


#if DEBUG
struct BatonTagRepresentable: UIViewRepresentable {
    let content: String
    let type: BatonTag.TagType

    func makeUIView(context: Context) -> BatonTag {
        return BatonTag(content: content, type: type)
    }

    func updateUIView(_ uiView: BatonTag, context: Context) {}
}

struct BatonTag_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            // ✅ 아이콘 있는 버전 (시간 태그)
            BatonTagRepresentable(content: "20", type: .time)
                .frame(minWidth: 50)
                .fixedSize()
                .previewLayout(.sizeThatFits)
                .padding()
            
            // ✅ 아이콘 없는 버전 (카테고리 태그)
            BatonTagRepresentable(content: "개발", type: .category)
                .frame(minWidth: 40)
                .fixedSize()
                .previewLayout(.sizeThatFits)
                .padding()
        }
    }
}
#endif
