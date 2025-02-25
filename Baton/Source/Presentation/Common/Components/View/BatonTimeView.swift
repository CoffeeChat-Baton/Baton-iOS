import UIKit
import SwiftUI

class BatonTimeView: UIView {
    private var currMinute: Int = 0 {
        didSet {
            updateLabel(currMinute)
        }
    }
    
    private let minuteLabel: UILabel = {
        let label = UILabel()
        label.pretendardStyle = .body4
        label.textColor = .blue3
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let clockImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(resource: .clock))
        imageView.image = imageView.image?.withTintColor(.blue3)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    init(time: Int) {
        super.init(frame: .zero)
        setupView()
        updateMinute(time)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateMinute(_ minute: Int) {
        currMinute = minute
    }
    
    private func updateLabel(_ minute: Int) {
        minuteLabel.text = "\(minute)분"
    }
    
    private func setupView() {
        backgroundColor = .blue1
        layer.cornerRadius = 15
        
        addSubview(clockImageView)
        addSubview(minuteLabel)
        
        // ✅ Auto Layout 설정 (Superview 크기에 맞게 자동 조정)
        NSLayoutConstraint.activate([
            // 이미지 크기 고정
            clockImageView.widthAnchor.constraint(equalToConstant: 16),
            clockImageView.heightAnchor.constraint(equalToConstant: 16),
            clockImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            clockImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            // 라벨 위치 (자동으로 크기 조절됨)
            minuteLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            minuteLabel.leadingAnchor.constraint(equalTo: clockImageView.trailingAnchor, constant: 4),
            minuteLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
            
            // 높이를 내부 요소에 맞게 설정
            self.heightAnchor.constraint(greaterThanOrEqualToConstant: 32)
        ])
        
        // ✅ Hugging & Compression Resistance 설정 (뷰가 내부 요소 크기에 맞춰지도록 함)
        minuteLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        minuteLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
    }
}
// MARK: - SwiftUI Preview

#if DEBUG
struct BatonTimeViewRepresentable: UIViewRepresentable {
    func makeUIView(context: Context) -> BatonTimeView {
        let view = BatonTimeView(time: 20)
        return view
    }
    
    func updateUIView(_ uiView: BatonTimeView, context: Context) {
        // 뷰 업데이트 코드가 필요하면 추가
    }
}

struct BatonTimeView_Previews: PreviewProvider {
    static var previews: some View {
        BatonTimeViewRepresentable()
            .frame(width: 71, height: 40) // SwiftUI에서 직접 크기 지정
            .fixedSize() // 내부 크기에 맞게 자동 조정
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
#endif
