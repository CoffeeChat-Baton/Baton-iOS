import UIKit

class CategoryButton: UIButton {

    init(image: UIImage?, size: CGFloat) {
        super.init(frame: .zero)
        
        self.frame = CGRect(x: 0, y: 0, width: size, height: size)
        self.setImage(image, for: .normal)
        
        self.backgroundColor = .white // 필요에 따라 변경
//        self.tintColor = .black // 이미지 색상 설정 (SF Symbol 사용 시)
        self.layer.cornerRadius = size / 2
        self.clipsToBounds = true
        self.imageView?.contentMode = .scaleAspectFit
        
        // 🔹 Auto Layout 적용
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(equalToConstant: size),
            self.heightAnchor.constraint(equalToConstant: size)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class RoundImageButtonWithLabelCell: UICollectionViewCell {
    static let identifier = "RoundImageButtonWithLabelCell"
    private let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 26 // 크기 설정에 따라 자동 조정
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let categoryButton: UIImageView = {
        let button = UIImageView()
        button.backgroundColor = .white
        button.tintColor = .black
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = false
        return button
    }()
    
    private let textLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.pretendardStyle = .caption2
        label.textColor = .bblack
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(containerView)
        containerView.addSubview(categoryButton)
        contentView.addSubview(textLabel)

        NSLayoutConstraint.activate([
            // 🔹 원형 버튼 설정
            containerView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 52),
            containerView.heightAnchor.constraint(equalTo: containerView.widthAnchor), // 정사각형
            
            categoryButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            categoryButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),

            // 🔹 라벨 설정
            textLabel.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 2),
            textLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            textLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            textLabel.heightAnchor.constraint(equalToConstant: 23)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with image: UIImage?, title: String) {
        categoryButton.image = image
        textLabel.text = title
    }
}


#if DEBUG
import SwiftUI

struct RoundImageButtonWithLabelCellRepresentable: UIViewRepresentable {
    func makeUIView(context: Context) -> RoundImageButtonWithLabelCell {
        let cell = RoundImageButtonWithLabelCell()
        let sampleImage = UIImage(resource: .categoryDev)
        cell.configure(with: sampleImage, title: "Sample")
        return cell
    }

    func updateUIView(_ uiView: RoundImageButtonWithLabelCell, context: Context) {}
}

struct RoundImageButtonWithLabelCell_Previews: PreviewProvider {
    static var previews: some View {
        RoundImageButtonWithLabelCellRepresentable()
            .frame(width: 60, height: 80)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
#endif
