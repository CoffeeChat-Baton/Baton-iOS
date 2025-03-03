import UIKit
import Combine

extension HomeCategoryBatonsViewController: BatonFilterButtonDelegate {
    func didTapFilterButton(_ button: BatonFilterButton) {
        showCustomModal(selection: viewModel.currfilter)
    }
}

extension HomeCategoryBatonsViewController: SelectionModalDelegate {
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

extension HomeCategoryBatonsViewController: BatonProfileViewDelegate {
    func didTapProfileView(_ profileView: BatonProfileView) {
        let modal = MentoDatailViewController()
        navigationController?.pushViewController(modal, animated: true)
    }
}

class HomeCategoryBatonsViewController: UIViewController {
    
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
    
    private let mentoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 7
        stackView.alignment = .leading
        stackView.distribution = .equalSpacing // 🔹 크기 자동 조정
        return stackView
    }()
    
    private let mentoLabel = UILabel.makeLabel(text: "멘토", textColor: .bblack, fontStyle: .body1)
    private let mentoSumLabel = UILabel.makeLabel(text: "1", textColor: .gray3, fontStyle: .body1)
    

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
        viewModel.datas = [
            Baton(imageName: "profile1", name: "김개발", company: "네카라쿠배", description: "iOS Developer", canStart: nil, shortIntro: "어쩌구 저쩌구"),
            Baton(imageName: "profile1", name: "김개발", company: "네카라쿠배", description: "iOS Developer", canStart: true, shortIntro: "저쩌구 할라라라라"),
            Baton(imageName: "profile2", name: "박디자이너", company: "쿠팡", description: "UX/UI Designer", canStart: false, shortIntro: "포트폴리오 전략")
        ]
    }
    
    func updateData(datas: [Baton]) {
        viewModel.datas = datas
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let tabBarController = self.tabBarController as? BatonTabBarController {
            tabBarController.hideTabBar()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let tabBarController = self.tabBarController as? BatonTabBarController {
            tabBarController.showTabBar()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray1
        setupScrollView()
        setupContentStackView()
        setupFilterButton()
        setupActions()
        bindViewModel()
        view.bringSubviewToFront(filterButton)
    }
    
    private func setupActions() {
        filterButton.delegate = self
    }
    
    private func bindViewModel() {
        viewModel.$currfilter
            .sink { [weak self] newFilter in
                self?.filterButton.updateSelectedOption(newFilter.rawValue)
            }
            .store(in: &cancellables)
        
        viewModel.$datas
            .sink { [weak self] newData in
                self?.updateProfiles(with: newData)
            }
            .store(in: &cancellables)
    }
    
    private func showCustomModal(selection: ShowBatonsViewModel.FilterType){
        guard let parentVC = view.findViewController() else { return }
        let options = ["추천 순", "인기 순","최신 등록 순", "후기 많은 순"]
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
        mentoStackView.translatesAutoresizingMaskIntoConstraints = false
        mentoLabel.translatesAutoresizingMaskIntoConstraints = false
        mentoSumLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let spacer = UIView()
        view.addSubview(mentoStackView)
        mentoStackView.addArrangedSubview(mentoLabel)
        mentoStackView.addArrangedSubview(mentoSumLabel)
        mentoStackView.addArrangedSubview(spacer)

        view.addSubview(filterButton)
        NSLayoutConstraint.activate([
            filterButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            filterButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            filterButton.heightAnchor.constraint(equalToConstant: 40),
            filterButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 50),
            mentoStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            mentoStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            mentoStackView.heightAnchor.constraint(equalToConstant: 40),
            mentoStackView.widthAnchor.constraint(greaterThanOrEqualToConstant: 50),
        ])
    }
    
   
    
    private func setupScrollView() {
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo:view.safeAreaLayoutGuide.topAnchor, constant: 60),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        scrollView.addSubview(contentStackView)
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 0),
            contentStackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 16),
            contentStackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -16),
            contentStackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -16),
            contentStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32)
        ])
    }
    
    private func setupContentStackView() {
        contentStackView.addArrangedSubview(profileView)
        
        NSLayoutConstraint.activate([
            profileView.leadingAnchor.constraint(equalTo: contentStackView.leadingAnchor),
            profileView.trailingAnchor.constraint(equalTo: contentStackView.trailingAnchor),
            profileView.topAnchor.constraint(equalTo: contentStackView.topAnchor, constant: 16),
            profileView.bottomAnchor.constraint(equalTo: contentStackView.bottomAnchor, constant: -16)
        ])
    }
    
    private func updateProfiles(with batons: [Baton]) {
        contentStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for baton in batons {
            let newBatonView = createBatonView(for: baton)
            contentStackView.addArrangedSubview(newBatonView)
        }
    }
    
    private func createBatonView(for baton: Baton) -> UIStackView {
        let batonContainerView = UIStackView()
        batonContainerView.axis = .vertical
        batonContainerView.spacing = 8
        
        let titleContainerView = UIStackView()
        titleContainerView.axis = .horizontal
        titleContainerView.spacing = 8
        titleContainerView.alignment = .center
        titleContainerView.distribution = .fill
        titleContainerView.translatesAutoresizingMaskIntoConstraints = false
        

        let profileView = BatonProfileView(
            image: UIImage(named: baton.imageName) ?? UIImage(resource: .profileDefault),
            name: baton.name,
            company: baton.company,
            category: baton.description,
            description: baton.description,
            buttonTitle: "",
            buttonStatus: baton.canStart ?? true,
            shortIntro: baton.shortIntro
        )
        profileView.translatesAutoresizingMaskIntoConstraints = false
        profileView.delegate = self
        batonContainerView.addArrangedSubview(profileView)
        return batonContainerView
    }
}

#if DEBUG
import SwiftUI

struct HomeCategoryBatonsViewControllerRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> HomeCategoryBatonsViewController {
        return HomeCategoryBatonsViewController(viewModel: ShowBatonsViewModel())
    }
    
    func updateUIViewController(_ uiViewController: HomeCategoryBatonsViewController, context: Context) {}
}

struct HomeCategoryBatonsViewController_Previews: PreviewProvider {
    static var previews: some View {
        HomeCategoryBatonsViewControllerRepresentable()
            .edgesIgnoringSafeArea(.all) // 전체 화면에 맞게 표시
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
#endif
