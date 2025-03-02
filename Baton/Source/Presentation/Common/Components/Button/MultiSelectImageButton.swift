import UIKit

class MultiSelectImageButton: UIControl {
    
    // MARK: - Subviews
    private let label = UILabel()
    private let imageView = UIImageView()
    
    // MARK: - State
    var isSelectedState: Bool = false {
        didSet {
            updateAppearance()
        }
    }
    
    /// 선택 상태 변경 시 호출되는 클로저
    var onSelectionChanged: ((Bool) -> Void)?
    
    // MARK: - Init
    init(title: String, imageName: String) {
        super.init(frame: .zero)
        setupUI(title: title, imageName: imageName)
        // UIControl 이벤트: 터치 종료 시(button tap)
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        updateAppearance() // 초기 상태 반영
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupUI(title: String, imageName: String) {
        // 라벨
        label.text = title
        label.textAlignment = .center
        addSubview(label)
        
        // 이미지
        if let image = UIImage(named: imageName) {
            imageView.image = image
        }
        imageView.contentMode = .scaleAspectFit
        addSubview(imageView)
        
        // 버튼처럼 보이도록 디자인 적용
        layer.cornerRadius = 12
        layer.borderWidth = 1
        backgroundColor = .gray1  // 초기 색
    }
    
    // MARK: - Layout
    /// "텍스트 위, 이미지 아래" + "이미지는 버튼의 하단에 딱 맞춤"
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let w = bounds.width
        let h = bounds.height
        
        let spacing: CGFloat = 8
        
        // 라벨 사이즈
        let labelSize = label.sizeThatFits(CGSize(width: w, height: .greatestFiniteMagnitude))
        // 이미지 사이즈
        let imageSize = imageView.intrinsicContentSize
        
        // 1) 이미지뷰를 버튼의 하단에 flush하게 배치
        imageView.frame = CGRect(
            x: (w - imageSize.width) / 2,
            y: h - imageSize.height, // 아랫변이 버튼 바닥에 닿음
            width: imageSize.width,
            height: imageSize.height
        )
        
        // 2) 라벨은 "이미지 상단 - spacing" 지점에 배치
        let labelBottom = imageView.frame.minY - spacing
        let labelX = (w - labelSize.width) / 2
        let labelY = max(0, labelBottom - labelSize.height)
        // (혹시 라벨이 버튼 범위를 넘치지 않도록 max(0, ...) 사용)
        
        label.frame = CGRect(
            x: labelX,
            y: labelY,
            width: labelSize.width,
            height: labelSize.height
        )
    }
    
    // MARK: - Action
    @objc private func buttonTapped() {
        isSelectedState.toggle()
        onSelectionChanged?(isSelectedState)
    }
    
    // MARK: - Appearance
    /// 선택/미선택 상태에 따라 폰트, 색, 테두리 등 변경
    private func updateAppearance() {
        // pretendardStyle (임의 커스텀 확장)
        label.pretendardStyle = isSelectedState ? .body1 : .body2
        
        label.textColor = isSelectedState ? UIColor.bblack : UIColor.gray5
        backgroundColor = isSelectedState ? UIColor.blue1 : UIColor.gray1
        layer.borderColor = isSelectedState ? UIColor.main.cgColor : UIColor.clear.cgColor
    }
}

import SwiftUI

/// UIKit의 MultiSelectImageButton을 SwiftUI에서 보여주기 위한 래퍼
struct MultiSelectImageButtonRepresentable: UIViewRepresentable {
    /// 버튼에 표시할 텍스트 및 이미지 이름
    let title: String
    let imageName: String
    
    /// SwiftUI 상태와 연결할 isSelected (토글 상태)
    @Binding var isSelected: Bool
     
    /// 선택 상태 변경 시 실행할 추가 클로저(옵셔널)
    var onSelectionChanged: ((Bool) -> Void)?
    
    // MARK: - UIViewRepresentable
    
    func makeUIView(context: Context) -> MultiSelectImageButton {
        // 1) UIKit의 MultiSelectImageButton 인스턴스 생성
        let uiButton = MultiSelectImageButton(title: title, imageName: imageName)
        
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
    
    func updateUIView(_ uiView: MultiSelectImageButton, context: Context) {
        // SwiftUI에서 isSelected 값이 바뀌면
        // UIKit 버튼 쪽도 업데이트
        uiView.isSelectedState = isSelected
    }
}

#if DEBUG
struct MultiSelectImageButtonRepresentable_Previews: PreviewProvider {
    @State static var testSelected = false
    
    static var previews: some View {
        VStack {
            MultiSelectImageButtonRepresentable(
                title: "Tap Me!",
                imageName: "worker",  // 실제 프로젝트 내 이미지 이름
                isSelected: $testSelected
            )
            // 원하는 크기로 지정
            .frame(width: 200, height: 160)
            
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
#endif
