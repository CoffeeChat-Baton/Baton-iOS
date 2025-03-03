import UIKit

class BatonReviewView: UIView {
    
    private let containerView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let nameContainerView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 12
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let secondContainerView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 6
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.pretendardStyle = .body1
        label.text = "박**"
        label.textColor = .bblack
        label.translatesAutoresizingMaskIntoConstraints = false
        
        // ✅ Hugging Priority를 높여서 크기 유지
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        return label
    }()
    private let dotDateLabel: UILabel = {
        let label = UILabel()
        label.pretendardStyle = .caption2
        label.text = "·"
        label.textColor = .gray5
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.pretendardStyle = .caption2
        label.text = "2025.05.12"
        label.textColor = .gray5
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let nameTag = BatonTag(content: "바통 20분", type: .nameTag)
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.pretendardStyle = .caption2
        label.text = "네이버 재직 중인 3년차 iOS 개발자입니다. 에이전시, 중견, 대기업을 거치며 쌓아온 여러 경험을 함께 나눌 수 있으면 좋겠습니다!"
        label.textColor = .bblack
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let tagView = TagCollectionView(tags: ["논리적으로 팩트를 전달해줘요", "솔직하게 답해줘요", "새로운 시각을 제시해줘요"])

    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    private func setupView() {
        tagView.translatesAutoresizingMaskIntoConstraints = false

        backgroundColor = UIColor.white
        layer.cornerRadius  = 12

        addSubview(containerView)
        containerView.addArrangedSubview(nameContainerView)
        containerView.addArrangedSubview(secondContainerView)
        containerView.addArrangedSubview(tagView)
        containerView.addArrangedSubview(contentLabel)

        nameContainerView.addArrangedSubview(nameLabel)
        nameContainerView.addArrangedSubview(nameTag)
        let spacer = UIView()
        spacer.translatesAutoresizingMaskIntoConstraints = false
        nameContainerView.addArrangedSubview(spacer)
        
        
        for _ in 0..<5 {
            secondContainerView.addArrangedSubview(UIImageView(image: UIImage(resource: .star)))
        }
        secondContainerView.addArrangedSubview(dotDateLabel)
        secondContainerView.addArrangedSubview(dateLabel)
        secondContainerView.addArrangedSubview(UIView())
    }
    
    private func setupConstraint() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            nameContainerView.heightAnchor.constraint(equalToConstant: 24),
        ])
    }
}


#if DEBUG
import SwiftUI

struct CardReviewViewRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        let view = BatonReviewView()
        let viewController = UIViewController()
        viewController.view.addSubview(view)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.centerXAnchor.constraint(equalTo: viewController.view.centerXAnchor),
            view.centerYAnchor.constraint(equalTo: viewController.view.centerYAnchor),
            view.widthAnchor.constraint(equalToConstant: 331),
            view.heightAnchor.constraint(equalToConstant: 215)
        ])
        
        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}

struct CardReviewView_Previews: PreviewProvider {
    static var previews: some View {
        CardReviewViewRepresentable()
            .edgesIgnoringSafeArea(.all)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
#endif

import UIKit

class TagCollectionView: UIView {
    
    // MARK: - Properties
    private var tags: [String] = [] {
        didSet {
            collectionView.reloadData()
            collectionView.layoutIfNeeded()
            invalidateIntrinsicContentSize()
        }
    }
    
    // MARK: - UI Components
    private lazy var collectionView: UICollectionView = {
        let layout = LeftAlignedCollectionViewFlowLayout()
        layout.estimatedItemSize = CGSize(width: 1, height: 1)
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize // 자동 크기 조정
        layout.minimumLineSpacing = 4
        layout.minimumInteritemSpacing = 6
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = false // 스크롤 비활성화 (자동 줄바꿈)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(TagCell.self, forCellWithReuseIdentifier: TagCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    // MARK: - Initializer
    init(tags: [String]) {
        super.init(frame: .zero)
        self.tags = tags
        setupView()
        setupConstraints()
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            self.collectionView.layoutIfNeeded()
            self.invalidateIntrinsicContentSize()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // ✅ `intrinsicContentSize` 활용하여 높이 자동 조정
     override var intrinsicContentSize: CGSize {
         collectionView.layoutIfNeeded()
         return collectionView.contentSize
     }
    
    // MARK: - Setup Methods
    private func setupView() {
        addSubview(collectionView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    // MARK: - Public Methods
    func updateTags(_ newTags: [String]) {
        self.tags = newTags
    }
}

// MARK: - UICollectionView DataSource
extension TagCollectionView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TagCell.identifier, for: indexPath) as? TagCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: tags[indexPath.item])
        return cell
    }
    
    // ✅ 셀 크기를 텍스트 길이에 맞춤
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let text = tags[indexPath.item]
        let label = UILabel()
        label.text = text
        label.pretendardStyle = .caption2
        label.sizeToFit()
        
        let width = label.frame.width + 24 // 좌우 padding 포함
        let height: CGFloat = 32
        
        return CGSize(width: width, height: height)
    }
}

// MARK: - TagCell (UICollectionViewCell)
class TagCell: UICollectionViewCell {
    static let identifier = "TagCell"
    
    private let tagLabel: UILabel = {
        let label = UILabel()
        label.pretendardStyle = .caption2
        label.textColor = .bblack
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let backgroundTagView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray1
        view.layer.cornerRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(backgroundTagView)
        backgroundTagView.addSubview(tagLabel)
        NSLayoutConstraint.activate([
            
            backgroundTagView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            backgroundTagView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
            backgroundTagView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            backgroundTagView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            
            tagLabel.centerXAnchor.constraint(equalTo: backgroundTagView.centerXAnchor),
            tagLabel.centerYAnchor.constraint(equalTo: backgroundTagView.centerYAnchor),
            backgroundTagView.heightAnchor.constraint(equalToConstant: 32)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with text: String) {
        tagLabel.text = text
    }
}

// MARK: - LeftAlignedCollectionViewFlowLayout (줄 바꿈 지원)
class LeftAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let attributes = super.layoutAttributesForElements(in: rect) else { return nil }
        
        var leftMargin: CGFloat = sectionInset.left
        var maxY: CGFloat = -1.0
        
        attributes.forEach { layoutAttribute in
            if layoutAttribute.frame.origin.y >= maxY {
                leftMargin = sectionInset.left
            }
            
            layoutAttribute.frame.origin.x = leftMargin
            leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing
            maxY = max(layoutAttribute.frame.maxY, maxY)
        }
        
        return attributes
    }
}
