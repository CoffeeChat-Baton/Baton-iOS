import UIKit

class BatonApplyViewController: UIViewController {
    
    private var viewModel = BatonApplyViewModel()
    
    private let scrollView = UIScrollView()
    
    // 제목
    let profileLabel = UILabel.makeLabel(text: "신청자 정보")
    let endDateLabel = UILabel.makeLabel(text: "희망하는 마감 기한")
    let preQuestonLabel = UILabel.makeLabel(text: "사전 질문")
    let attachedFileLabel = UILabel.makeLabel(text: "첨부 파일")
    let mentorFeedbackLabel = UILabel.makeLabel(text: "피드백 내용을 작성해주세요")

    // 내용
    private let profileView = BatonProfileView(image: UIImage(resource: .profileDefault), name: "", company: "", category: "", description: "", buttonTitle: nil, status: true)
    private let endDateView = BaseTextView(placeholder: "5월 5일 (일)", style: .outlined, isEditable: false)
    private let preQuestionView = BaseTextView(placeholder: "사전 질문 들어갈 곳", style: .filled, isEditable: false)
    private let attachedFileView = BaseTextView(placeholder: "이승현_포트폴리오", style: .filled, isEditable: false)
    private let mentorFeedbackTextView = BaseTextView(placeholder: "최소 50자 이상 작성해주세요", maxLength: 5000)
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavigationBar()
        setupUI()
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
//        let backButton = BatonNavigationButton.backButton(target: self, action: #selector(backButtonTapped))
        //setupBatonNavigationBar(title: "Apply for Baton", backButton: backButton)
    }
    
    private func setupUI() {
        // ✅ scrollView 설정
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)

        let stackView = UIStackView(arrangedSubviews: [
            profileLabel, profileView,
            makeSpacer(),
            endDateLabel, endDateView,
            makeSpacer(),
            preQuestonLabel, preQuestionView,
            attachedFileLabel, attachedFileView,
            makeSpacer(),
            mentorFeedbackLabel, mentorFeedbackTextView
        ])
        
        stackView.axis = .vertical
        stackView.spacing = 15
        stackView.alignment = .fill // ✅ 요소들 정렬 유지
        stackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stackView)

        NSLayoutConstraint.activate([
            // ✅ scrollView를 view의 safe area에 맞춤
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            // ✅ stackView를 scrollView의 contentLayoutGuide에 맞춤 (세로 스크롤만 가능)
            stackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: Spacing.large.value),
            stackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -Spacing.large.value),

            // ✅ 가로 스크롤 완전 방지
            stackView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -2 * Spacing.large.value)
        ])
    }
    
    @objc private func uploadFileTapped() {
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.data], asCopy: true)
        documentPicker.delegate = self
        present(documentPicker, animated: true)
    }
    
    @objc private func applyTapped() {
        print("Applying with: \(viewModel.preQuestion), \(viewModel.mentorReview)")
        // TODO: API 연결 및 실제 신청 로직 구현
    }

//    @objc func backButtonTapped() {
//        navigationController?.popViewController(animated: true)
//    }
    
    private func makeSpacer() -> UIView {
        let view = UIView()
        view.backgroundColor = .gray1
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 6).isActive = true
        return view
    }
}

// MARK: - UITextFieldDelegate
extension BatonApplyViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        viewModel.preQuestion = textField.text ?? ""
    }
}

// MARK: - UITextViewDelegate
extension BatonApplyViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        viewModel.mentorReview = textView.text
    }
}

// MARK: - UIDocumentPickerDelegate
extension BatonApplyViewController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        if let fileURL = urls.first, let data = try? Data(contentsOf: fileURL) {
            viewModel.attachedFile = data
            print("File uploaded: \(fileURL.lastPathComponent)")
        }
    }
}
