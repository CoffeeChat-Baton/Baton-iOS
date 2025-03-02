import UIKit
import Combine

class SetProfileImageView: BaseViewController<ProfileSettingViewModel> {
    // MARK: - Properties
    private var cancellables = Set<AnyCancellable>()
    private let profileButton: RoundProfileButton = {
        // 프레임 예시: (x=100, y=200), 크기 120×120
        let button = RoundProfileButton()
        return button
    }()
    
    private let editIcon: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(resource: .roundCamera) // 원하는 아이콘
        iv.tintColor = .white
        iv.backgroundColor = .gray3
        iv.layer.cornerRadius = 22 // 44x44일 때 반지름 22
        iv.layer.masksToBounds = true
        iv.layer.borderWidth = 2 // 테두리 두께
        iv.layer.borderColor = UIColor.white.cgColor // 테두리 색상
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    // MARK: - Init
    init(viewModel: ProfileSettingViewModel) {
        super.init(viewModel: viewModel, contentView: UIView(), onNext: {viewModel.goToNextStep()})
        setupView()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI Setup
    private func setupView() {
        profileButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(profileButton)
        contentView.addSubview(editIcon)

    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            profileButton.widthAnchor.constraint(equalToConstant: 186),
            profileButton.heightAnchor.constraint(equalToConstant: 186),
            profileButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            // 작은 아이콘 (44×44), profileButton 우하단에 붙이기
            editIcon.widthAnchor.constraint(equalToConstant: 44),
            editIcon.heightAnchor.constraint(equalToConstant: 44),
            
            // 아이콘의 trailing/bottom을 profileButton에 맞춤
            editIcon.trailingAnchor.constraint(equalTo: profileButton.trailingAnchor),
            editIcon.bottomAnchor.constraint(equalTo: profileButton.bottomAnchor),
        ])
    }
    
    // MARK: - Load Options
    
}

