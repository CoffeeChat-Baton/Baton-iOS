import UIKit

class PartnerRegistrationViewController: UIPageViewController {
    private var navigationBarTitle = "파트너 등록"
    private var pages: [UIViewController] = []
    private var currentIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPages()
        setupNavigationBar()
    }

    private func setupPages() {
        let step1 = Step1ViewController(mainTitle: "프로필 정보를 확인해주세요", subTitle: "파트너 프로필에 보여지는 정보입니다.\n아래 정보가 정확한지 다시 한 번 확인해주세요!", actionButtonTitle: "파트너 등록 신청하기", contentView: UIView())
        let step2 = Step2ViewController(mainTitle: "재직 사실을 인증해주세요", subTitle: "재직을 증명할 수 있는 서류(재직증명서, 사원증 등)를 업로드해주세요.", actionButtonTitle: "다음", contentView: UIView())
        
        pages = [step1, step2]

        if let firstPage = pages.first {
            setViewControllers([firstPage], direction: .forward, animated: true, completion: nil)
        }
    }

    private func setupNavigationBar() {
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem = backButton
        navigationItem.title = navigationBarTitle
    }

    @objc private func backButtonTapped() {
        if currentIndex > 0 {
            currentIndex -= 1
            setViewControllers([pages[currentIndex]], direction: .reverse, animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }

    func goToNextPage() {
        if currentIndex < pages.count - 1 {
            currentIndex += 1
            setViewControllers([pages[currentIndex]], direction: .forward, animated: true, completion: nil)
        } else {
            print("파트너 등록 완료!")
            navigationController?.popToRootViewController(animated: true)
        }
    }
}


class Step1ViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        actionButton.setTitle("다음", for: .normal)
        actionButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }

    @objc private func nextButtonTapped() {
        (parent as? PartnerRegistrationViewController)?.goToNextPage()
    }
}


class Step2ViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        actionButton.setTitle("완료", for: .normal)
        actionButton.addTarget(self, action: #selector(completeRegistration), for: .touchUpInside)
    }

    @objc private func completeRegistration() {
        (parent as? PartnerRegistrationViewController)?.goToNextPage()
    }
}
