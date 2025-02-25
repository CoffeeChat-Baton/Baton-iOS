import UIKit
import Combine

extension ShowBatonsViewController: BatonFilterButtonDelegate {
    func didTapFilterButton(_ button: BatonFilterButton) {
        showCustomModal(selection: viewModel.currfilter)
    }
}

extension ShowBatonsViewController: SelectionModalDelegate {
    typealias SelectionType = ShowBatonsViewModel.FilterType
    func didSelectOption(_ option: String, type: SelectionType) {
      // 현재 보여주는 바통들 데이터 업데이트 하기.
        if let newFilter = ShowBatonsViewModel.FilterType(rawValue: option) {
             viewModel.updateFilter(newFilter)
         } else {
             print("⚠️ 일치하는 필터 타입이 없습니다.")
         }
    }
}

class ShowBatonsViewController: UIViewController {
    
    private let titleContainerView = UIStackView()
    private let viewModel: ShowBatonsViewModel
    private var cancellables: Set<AnyCancellable> = []
    private let transitionDelegate = ModalTransitioningDelegate()
    
    // 🔹 필터 버튼 (화면 최상단 오른쪽)
    private let filterButton: BatonFilterButton = {
        let button = BatonFilterButton(title: "필터 선택")
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // 🔹 스크롤뷰와 내부 StackView
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private let contentStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        stack.alignment = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    // 🔹 태그(타임 타입) – BatonTag의 타입이 .time 인 경우
    private let tagView: BatonTag = {
        let tag = BatonTag(content: "20", type: .time)
        tag.translatesAutoresizingMaskIntoConstraints = false
        return tag
    }()
    
    // 🔹 텍스트 레이블 (설명)
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.text = "이곳은 상세 설명을 넣는 레이블입니다."
        label.pretendardStyle = .body4
        label.textColor = .bblack
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // 🔹 프로필 뷰 (BatonProfileView)
    private let profileView: BatonProfileView = {
        let profile = BatonProfileView(
            image: UIImage(resource: .profileDefault),
            name: "홍길동",
            company: "Example Inc.",
            category: "개발",
            description: "iOS Developer",
            buttonTitle: "메시지 보내기"
        )
        profile.translatesAutoresizingMaskIntoConstraints = false
        return profile
    }()
    
    init(viewModel: ShowBatonsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray1
        setupFilterButton()
        setupScrollView()
        setupContentStackView()
        setupActions()
        bindViewModel()
    }
    
    private func setupActions() {
        filterButton.delegate = self
    }
    
    private func bindViewModel() {
        viewModel.$currfilter
            .sink { [weak self] newFilter in
                print("드디어!!!!!!!!!", newFilter)
                self?.filterButton.updateSelectedOption(newFilter.rawValue)
            }
            .store(in: &cancellables)
    }
    
    private func showCustomModal(selection: ShowBatonsViewModel.FilterType){
        guard let parentVC = view.findViewController() else { return }
        let options = ["바통", "포트폴리오 리뷰", "이력서 첨삭", "모두 보기"]
        let modal = SelectionModal(headerTitle: "필터 선택",
                                   options: options,
                                   selectionType: selection,
                                   delegate: self,
                                   selectedOption: viewModel.currfilter.rawValue)
        modal.delegate = self
        modal.transitioningDelegate = transitionDelegate
        modal.modalPresentationStyle = .custom
        
        parentVC.present(modal, animated: true)
    }
    private func setupFilterButton() {
        view.addSubview(filterButton)
        NSLayoutConstraint.activate([
            filterButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            filterButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            filterButton.heightAnchor.constraint(equalToConstant: 40),
            filterButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 50)
        ])
    }
    
    private func setupScrollView() {
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: filterButton.bottomAnchor, constant: 5),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        scrollView.addSubview(contentStackView)
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 16),
            contentStackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 16),
            contentStackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -16),
            contentStackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -16),
            contentStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32)
        ])
    }
    
    private func setupContentStackView() {
        titleContainerView.axis = .horizontal
        titleContainerView.spacing = 8
        titleContainerView.alignment = .center
        titleContainerView.distribution = .fill
        titleContainerView.translatesAutoresizingMaskIntoConstraints = false
        titleContainerView.addArrangedSubview(tagView)
        titleContainerView.addArrangedSubview(infoLabel)
        titleContainerView.addArrangedSubview(UIView())

        contentStackView.addArrangedSubview(titleContainerView)
        contentStackView.addArrangedSubview(profileView)

        NSLayoutConstraint.activate([
            titleContainerView.leadingAnchor.constraint(equalTo: contentStackView.leadingAnchor),
            titleContainerView.trailingAnchor.constraint(equalTo: contentStackView.trailingAnchor),
            
            profileView.leadingAnchor.constraint(equalTo: contentStackView.leadingAnchor),
            profileView.trailingAnchor.constraint(equalTo: contentStackView.trailingAnchor),
            profileView.topAnchor.constraint(equalTo: titleContainerView.bottomAnchor, constant: 16),
            profileView.bottomAnchor.constraint(equalTo: contentStackView.bottomAnchor, constant: -16) // ✅ 프로필 뷰가 꽉 차도록 설정
        ])
    }
}

#if DEBUG
import SwiftUI

struct ShowBatonsViewControllerRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> ShowBatonsViewController {
        return ShowBatonsViewController(viewModel: ShowBatonsViewModel())
    }
    
    func updateUIViewController(_ uiViewController: ShowBatonsViewController, context: Context) {}
}

struct ShowBatonsViewController_Previews: PreviewProvider {
    static var previews: some View {
        ShowBatonsViewControllerRepresentable()
            .edgesIgnoringSafeArea(.all) // 전체 화면에 맞게 표시
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
#endif
