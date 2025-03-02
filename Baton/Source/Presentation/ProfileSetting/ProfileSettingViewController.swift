import UIKit
import Combine

extension ProfileSettingViewController: BatonNavigationConfigurable {
    
    @objc func baseBackButtonTapped() {
        if viewModel.currentStepIndex > 0 {
            viewModel.goToPreviousStep()
            setViewControllers([pages[viewModel.currentStepIndex]], direction: .reverse, animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
}

class ProfileSettingViewController: UIPageViewController, UIPageViewControllerDelegate{
    private var navigationBarTitle = "프로필 설정"
    private var pages: [UIViewController] = []
    private let viewModel: ProfileSettingViewModel
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: ProfileSettingViewModel) {
        self.viewModel = viewModel
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        self.delegate = self
        
        viewModel.onCompletion = { [weak self] in
            DispatchQueue.main.async {
                if let navigationController = self?.navigationController {
                    navigationController.popToRootViewController(animated: true)
                } else {
                    self?.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPages()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let tabBarController = self.tabBarController as? BatonTabBarController {
            tabBarController.hideTabBar()
        }
        setupNavigationBar()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let tabBarController = self.tabBarController as? BatonTabBarController {
            tabBarController.showTabBar()
        }
    }
    
    private func setupNavigationBar() {
        let backButton = BatonNavigationButton.backButton(target: self, action: #selector(baseBackButtonTapped))
        setupBaseNavigationBar(title: "파트너 등록", backButton: backButton)
    }

    
    private func setupPages() {
        let step1 = SetNicknameView(viewModel: viewModel)
        let step2 = SetStatusView(viewModel: viewModel)
        let step3 = SetProfileView(viewModel: viewModel)
        let step4 = SetEmailView(viewModel: viewModel)
        let step5 = SetProfileImageView(viewModel: viewModel)
        
        let successPage = viewModel.steps[viewModel.steps.count - 1]
        let success = SuccessViewController(
            title: successPage.mainTitle,
            subtitle: successPage.subTitle,
            primaryButtonText: "",
            secondaryButtonText: successPage.actionButtonTitle,
            primaryAction: {
                print("멘토 정보 확인하기 버튼 클릭") //TODO: 추후 수정하기
            },
            secondaryAction: {
                self.viewModel.goToNextStep()
            }
        )
        
        pages = [step1, step2, step3, step4, step5, success]
        
        // 첫 번째 페이지를 초기화하여 UIPageViewController에 설정
        if let firstPage = pages.first {
            setViewControllers([firstPage], direction: .forward, animated: false, completion: nil)
        }
    }
    
    private func bindViewModel() {
        viewModel.$currentStepIndex
            .dropFirst() // 첫 번째 값 무시 (초기 상태 방지)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] index in
                guard let self = self, index < self.pages.count else { return }
                self.setViewControllers([self.pages[index]], direction: .forward, animated: true, completion: nil)
            }
            .store(in: &cancellables)
    }
}
