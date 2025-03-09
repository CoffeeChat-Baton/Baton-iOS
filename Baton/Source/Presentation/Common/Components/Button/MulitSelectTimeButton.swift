import UIKit

class MultiSelectTimeButton: UIControl {
    
    // MARK: - Subviews
    private let imageView = UIImageView()      // 이미지 뷰 (이미지 변경)
    private let priceLabel: UILabel = {       // 하단에 추가할 14900원 라벨
        let label = UILabel()
        label.text = "14900원"
        label.textAlignment = .center
        label.textColor = .gray5
        label.pretendardStyle = .caption2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let overlayTimeLabel: UILabel = { // 이미지뷰 중앙 오버레이 "20분" 라벨
        let label = UILabel()
        label.text = "20분"
        label.textAlignment = .center
        label.textColor = .gray5
        label.pretendardStyle = .body3
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - State
    var isSelectedState: Bool = false {
        didSet {
            updateAppearance()
        }
    }
    
    /// 선택 상태 변경 시 호출되는 클로저
    var onSelectionChanged: ((Bool) -> Void)?
    
    // MARK: - Init
    init(time: Int, price: Int) {
        super.init(frame: .zero)
        setupUI(time: time, price: price)
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal  // 천 단위 구분 기호 사용
        if let formattedPrice = formatter.string(from: NSNumber(value: price)) {
            priceLabel.text = "\(formattedPrice)원"
        }
        priceLabel.text = NumberFormatUtil.formatPrice(price) + "원"
        overlayTimeLabel.text = "\(time)분"
        
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        updateAppearance() // 초기 상태 반영
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupUI(time: Int, price: Int) {
        // 이미지뷰 설정 (초기 이미지는 선택 안 된 상태)
        imageView.image = UIImage(named: "time")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)
        
        // 이미지뷰 내부에 "20분" 라벨 오버레이 추가
        imageView.addSubview(overlayTimeLabel)
        
        // 가격 라벨 추가
        addSubview(priceLabel)
        
        // 버튼처럼 보이도록 스타일 적용
        layer.cornerRadius = 12
        layer.borderWidth = 1
        layer.borderColor = UIColor.gray3.cgColor
        
        setupConstraints()
    }
    
    // MARK: - Layout
    private func setupConstraints() {
        // 레이아웃 예시:
        // ┌────────────────────────────┐
        // │       titleLabel           │
        // │----------------------------│
        // │         imageView          │ <- 가운데 "20분" 오버레이 있음
        // │----------------------------│
        // │        priceLabel          │ ("14900원")
        // └────────────────────────────┘
        NSLayoutConstraint.activate([
        
            widthAnchor.constraint(equalToConstant: 106),
            heightAnchor.constraint(equalToConstant: 106),
            // imageView: titleLabel 아래, 가운데 배치, 고정 크기 (예: 60×60)
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 60),
            imageView.heightAnchor.constraint(equalToConstant: 60),
            
            // overlayTimeLabel: imageView의 중앙에 배치
            overlayTimeLabel.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            overlayTimeLabel.centerYAnchor.constraint(equalTo: imageView.centerYAnchor, constant: 5),
            
            // priceLabel: imageView 아래, 좌우 여백 8pt, 하단 여백 8pt
            priceLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            priceLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            priceLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            priceLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
    }
    
    // MARK: - Action
    @objc private func buttonTapped() {
        isSelectedState.toggle()
        onSelectionChanged?(isSelectedState)
    }
    
    // MARK: - Appearance
    private func updateAppearance() {
        // 선택 상태에 따라 이미지 변경:
        // 선택시 "time_fill", 선택 안됐을 시 "time"
        imageView.image = isSelectedState ? UIImage(named: "time_fill") : UIImage(named: "time")
        
        // 배경 및 테두리 색상 업데이트 (원래 코드와 동일)
        backgroundColor = isSelectedState ? UIColor.blue1 : UIColor.clear
        layer.borderColor = isSelectedState ? UIColor.main.cgColor : UIColor.gray3.cgColor
        overlayTimeLabel.textColor = isSelectedState ? UIColor.bblack : UIColor.gray5
        priceLabel.textColor = isSelectedState ? UIColor.bblack : UIColor.gray5
    }
}

import SwiftUI

/// UIKit의 MultiSelectImageButton을 SwiftUI에서 보여주기 위한 래퍼
struct MultiSelectTimeButtonRepresentable: UIViewRepresentable {
    /// 버튼에 표시할 텍스트 및 이미지 이름
    let time: Int
    let price: Int
    
    /// SwiftUI 상태와 연결할 isSelected (토글 상태)
    @Binding var isSelected: Bool
     
    /// 선택 상태 변경 시 실행할 추가 클로저(옵셔널)
    var onSelectionChanged: ((Bool) -> Void)?
    
    // MARK: - UIViewRepresentable
    
    func makeUIView(context: Context) -> MultiSelectTimeButton {
        // 1) UIKit의 MultiSelectImageButton 인스턴스 생성
        let uiButton = MultiSelectTimeButton(time: time, price: price)
        
        // 2) 초기 상태 동기화
        uiButton.isSelectedState = isSelected
        
        // 3) 버튼이 탭될 때, SwiftUI 상태도 함께 업데이트
        uiButton.onSelectionChanged = { newValue in
            isSelected = newValue
            // 필요한 경우, 추가 클로저도 호출
            onSelectionChanged?(newValue)
        }
        
        return uiButton
    }
    
    func updateUIView(_ uiView: MultiSelectTimeButton, context: Context) {
        // SwiftUI에서 isSelected 값이 바뀌면
        // UIKit 버튼 쪽도 업데이트
        uiView.isSelectedState = isSelected
    }
}

#if DEBUG
struct MultiSelectTimeButtonRepresentable_Previews: PreviewProvider {
    @State static var testSelected = false
    
    static var previews: some View {
        VStack {
            MultiSelectTimeButtonRepresentable(
                time: 20, price: 14900,
                isSelected: $testSelected
            )
            // 원하는 크기로 지정
            .frame(width: 106, height: 106)
            
        }
        .previewLayout(.sizeThatFits)
    }
}
#endif
