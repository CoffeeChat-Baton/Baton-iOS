import UIKit
import Combine

class PartnerRegistrationViewController: UIPageViewController, UIPageViewControllerDelegate{
    private var navigationBarTitle = "멘토 등록"
    private var pages: [UIViewController] = []
    private let viewModel: PartnerRegistrationViewModel
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: PartnerRegistrationViewModel) {
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
        setupNavigationBar()
        bindViewModel()
    }
    private func setupPages() {
        let step1 = CheckProfileView(viewModel: viewModel)
        let step2 = EmployeeStatusView(viewModel: viewModel)
        let step3 = JobInfoView(viewModel: viewModel)
        let step4 = ChatScheduleView(viewModel: viewModel)
        let step5 = SelfIntroductionView(viewModel: viewModel)
        let success = SuccessViewController(
            title: "멘토 등록이 완료되었어요",
            subtitle: "마이페이지에서 나의 멘토 정보를\n확인하고 수정할 수 있어요",
            primaryButtonText: "멘토 정보 확인하기",
            secondaryButtonText: "확인",
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
    
    private func setupNavigationBar() {
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem = backButton
        navigationItem.title = "파트너 등록"
        navigationItem.titleView?.tintColor = .black
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
    
    @objc private func backButtonTapped() {
        if viewModel.currentStepIndex > 0 {
            viewModel.goToPreviousStep()
            setViewControllers([pages[viewModel.currentStepIndex]], direction: .reverse, animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
}
