import UIKit

extension ChooseBatonViewController: BatonNavigationConfigurable {
    
    @objc func baseBackButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}

class ChooseBatonViewController: UIViewController {
    
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "success_background")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // 1. 제목
    lazy var mainTitleLabel: UILabel  = {
        let label = UILabel()
        label.text = "어떤 바통을\n신청하시겠어요?"
        label.pretendardStyle = .head1
        label.textColor = UIColor(resource: .bblack)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    // 2. 부제목
    lazy var subTitleLabel: UILabel  = {
        let label = UILabel()
        label.text = "세 가지 중 하나를 필수로 선택해주세요."
        label.pretendardStyle = .body4
        label.textColor = UIColor(resource: .gray5)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // 4. 하단 고정 버튼
    lazy var actionButton: BasicButton = {
        let button = BasicButton(title: "다음", status: .disabled)
        button.isEnabled = false // 초기에는 비활성화
        button.isUserInteractionEnabled = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // 버튼 3개 생성
    var oneByoneButton = BatonApplyButton(title: "1:1 바통", subTitle: "멘토와의 화상채팅을 통해,\n궁금한 점을 해결해보세요!", imageName: "1by1baton")
    var portfolioButton = BatonApplyButton(title: "포트폴리오 리뷰", subTitle: "포트폴리오를 공유하고,\n전문가의 피드백을 받아보세요.", imageName: "portfolio")
    var resumeButton = BatonApplyButton(title: "이력서 첨삭", subTitle: "이력서의 구성부터 표현까지,\n꼼꼼한 피드백을 받아보세요.", imageName: "resume")
    
    private var selectedButton: BatonApplyButton? // 현재 선택된 버튼
    private var selectedButtonType: String? // 선택된 버튼 타입

    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraint()
        setupButtonActions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let tabBarController = self.tabBarController as? BatonTabBarController {
            tabBarController.hideTabBar()
        }
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        let backButton = BatonNavigationButton.backButton(target: self, action: #selector(baseBackButtonTapped))
        setupBaseNavigationBar(title: "신청하기", backButton: backButton)
    }
    
    private func setupView() {
        view.backgroundColor = .bwhite
        view.insertSubview(backgroundImageView, at: 0)
        view.addSubview(mainTitleLabel)
        view.addSubview(subTitleLabel)
        view.addSubview(actionButton)
        view.addSubview(buttonStackView)
        buttonStackView.addArrangedSubview(oneByoneButton)
        buttonStackView.addArrangedSubview(portfolioButton)

        view.addSubview(resumeButton)
        
        oneByoneButton.translatesAutoresizingMaskIntoConstraints = false
        portfolioButton.translatesAutoresizingMaskIntoConstraints = false
        resumeButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupConstraint() {
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            mainTitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            mainTitleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Spacing.large.value),
            mainTitleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Spacing.large.value),

            subTitleLabel.topAnchor.constraint(equalTo: mainTitleLabel.bottomAnchor, constant: 10),
            subTitleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Spacing.large.value),
            subTitleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Spacing.large.value),
            
            actionButton.heightAnchor.constraint(equalToConstant: ButtonSize.large.height),
            actionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            actionButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor , constant: Spacing.large.value),
            actionButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Spacing.large.value),
            
            buttonStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonStackView.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: 44),
            
            oneByoneButton.widthAnchor.constraint(equalToConstant: 160),
            oneByoneButton.heightAnchor.constraint(equalToConstant: 160),
       
            portfolioButton.widthAnchor.constraint(equalToConstant: 160),
            portfolioButton.heightAnchor.constraint(equalToConstant: 160),
       
            resumeButton.widthAnchor.constraint(equalToConstant: 160),
            resumeButton.heightAnchor.constraint(equalToConstant: 160),
            resumeButton.topAnchor.constraint(equalTo: oneByoneButton.bottomAnchor, constant: 16),
            resumeButton.leadingAnchor.constraint(equalTo:oneByoneButton.leadingAnchor),
        ])
    }
    
    // ✅ 버튼 선택 로직 설정
    private func setupButtonActions() {
        let buttons = [oneByoneButton, portfolioButton, resumeButton]
        
        for button in buttons {
            button.onSelectionChanged = { [weak self] isSelected in
                self?.handleButtonSelection(selectedButton: button, isSelected: isSelected)
            }
        }
    }

    // ✅ 선택된 버튼의 타입을 저장하도록 변경
    private func handleButtonSelection(selectedButton: BatonApplyButton, isSelected: Bool) {
        if let prevButton = self.selectedButton, prevButton != selectedButton {
            prevButton.isSelectedState = false
        }
        
        if isSelected {
            self.selectedButton = selectedButton
            
            // ✅ 선택된 버튼 타입 저장
            if selectedButton == oneByoneButton {
                selectedButtonType = "1:1 바통"
            } else if selectedButton == portfolioButton {
                selectedButtonType = "포트폴리오 리뷰"
            } else if selectedButton == resumeButton {
                selectedButtonType = "이력서 첨삭"
            }
            
            actionButton.isEnabled = true // ✅ 선택되면 "다음" 버튼 활성화
            actionButton.status = .enabled
        } else {
            self.selectedButton = nil
            selectedButtonType = nil
            actionButton.isEnabled = false // ✅ 선택 해제되면 "다음" 버튼 비활성화
            actionButton.status = .disabled
        }
    }

    // ✅ "다음" 버튼 클릭 시 선택된 버튼 타입에 따라 다른 화면으로 이동
    @objc private func actionButtonTapped() {
        guard let selectedType = selectedButtonType else { return }
        
        var nextViewController: UIViewController?
        
        switch selectedType {
        case "1:1 바통":
            nextViewController = ApplyBatonViewController()
        case "포트폴리오 리뷰":
            nextViewController = HomeViewController()
        case "이력서 첨삭":
            nextViewController = HomeViewController()
        default:
            return
        }
        
        if let nextVC = nextViewController {
            navigationController?.pushViewController(nextVC, animated: true)
        }
    }
}

#if DEBUG
import SwiftUI

struct ChooseBatonViewControllerRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> ChooseBatonViewController {
        return ChooseBatonViewController()
    }

    func updateUIViewController(_ uiViewController: ChooseBatonViewController, context: Context) {}
}

struct ChooseBatonViewController_Previews: PreviewProvider {
    static var previews: some View {
        ChooseBatonViewControllerRepresentable()
            .edgesIgnoringSafeArea(.all)
            .previewLayout(.sizeThatFits)
    }
}
#endif
