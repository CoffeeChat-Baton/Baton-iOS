import Foundation
import Combine

enum Status {
     case student
     case worker
     // 필요하다면 .none, .etc 추가
}

class ProfileSettingViewModel: BaseViewModelType {
    var currentStepIndexPublisher: Published<Int>.Publisher { $currentStepIndex }
    
    // ✅ 현재 스텝 인덱스 (UI 업데이트 자동 트리거)
    @Published var currentStepIndex: Int = 0
    var cancellables = Set<AnyCancellable>()
    
    // ✅ 선택된 값 (UI가 업데이트됨)
    @Published var selectedJob: String = ""
    @Published var selectedSubJob: String = ""
    @Published var selectedExperience: String = ""
    @Published var companyName: String = ""
    @Published var selectedFileName: String = ""
    
    @Published var status: Status = .student
    var selectedFileURL: URL? // 파일 URL 저장
    
    @Published var schedules: [String] = [
        "",
        "",
        ""
    ]
    
    @Published var shortIntro: String = ""
    @Published var email: String = ""
    
    
    // ✅ 각 버튼에 대한 선택 옵션 데이터
    let jobOptions = JobCategory.all
    let subJobOptions = ["프론트엔드", "백엔드", "풀스택"]
    let experienceOptions = ExperienceYears.all
    
    
    var onCompletion: (() -> Void)? // ✅ 마지막 스텝 완료 시 실행할 클로저
    
    // ✅ 버튼 활성화 상태
    @Published var isButtonEnabled: Bool = false
    let steps: [BaseContent] = [
        BaseContent(mainTitle: "사용할 닉네임을\n입력해주세요",
                    subTitle: "10글자 이내의 한글만 입력할 수 있어요",
                    actionButtonTitle: "다음"),
        BaseContent(mainTitle: "000님, 안녕하세요!\n현재 상태를 선택해주세요",
                    subTitle: "",
                    actionButtonTitle: "다음"),
        BaseContent(mainTitle: "나의 직무를 선택해주세요",
                    subTitle: "나중에 마이페이지에서 언제든지 수정할 수 있어요",
                    actionButtonTitle: "다음"),
        BaseContent(mainTitle: "이메일을 입력해주세요",
                    subTitle: "나중에 마이페이지에서 언제든지 등록할 수 있어요",
                    actionButtonTitle: "다음"),
        BaseContent(mainTitle: "프로필 사진을 설정해주세요",
                    subTitle: "나중에 마이페이지에서 언제든지 등록할 수 있어요",
                    actionButtonTitle: "완료"),
        BaseContent(mainTitle: "프로필 설정이 완료되었어요",
                    subTitle: "이제 바통을 건넬 준비가 되었어요!",
                    actionButtonTitle: "바통 시작하기")
    ]
    
    var totalSteps: Int {
        return steps.count
    }
    
    var currentStep: BaseContent {
        return steps[currentStepIndex]
    }
    
    init() {
        bindPublishers()
    }
    
    // ✅ 모든 값이 변경될 때 로그 찍기
    private func bindPublishers() {
        $selectedJob
            .sink { print("🔹 selectedJob 변경: \($0)") }
            .store(in: &cancellables)
        
        $selectedSubJob
            .sink { print("🔹 selectedSubJob 변경: \($0)") }
            .store(in: &cancellables)
        
        $selectedExperience
            .sink { print("🔹 selectedExperience 변경: \($0)") }
            .store(in: &cancellables)
        
        $companyName
            .sink { print("🔹 companyName 변경: \($0)") }
            .store(in: &cancellables)
        
        $selectedFileName
            .sink { print("🔹 selectedFileName 변경: \($0)") }
            .store(in: &cancellables)
        
        $schedules
            .sink { print("🔹 schedules 변경: \($0)") }
            .store(in: &cancellables)
        
        $shortIntro
            .sink { print("🔹 shortIntro 변경: \($0)") }
            .store(in: &cancellables)
        
        $email
            .sink { print("🔹 email 변경: \($0)") }
            .store(in: &cancellables)
        
        $currentStepIndex
            .sink { print("🔹 currentStepIndex 변경: \($0)") }
            .store(in: &cancellables)
        
        $isButtonEnabled
            .sink { print("🔹 isButtonEnabled 변경: \($0)") }
            .store(in: &cancellables)
    }
    // ✅ 다음 스텝으로 이동
    func goToNextStep() {
        if currentStepIndex < steps.count - 1 {
            currentStepIndex += 1
            if currentStepIndex == steps.count - 2 { // 파트너 등록 진짜 하는 시기
                // 멘토 등록하기
            }
        } else {
            print("🎉 파트너 등록 완료!")
            onCompletion?()
        }
    }
    
    // ✅ 이전 스텝으로 이동
    func goToPreviousStep() {
        if currentStepIndex > 0 {
            currentStepIndex -= 1
        }
    }
    
    // ✅ 버튼 상태 업데이트 (입력 검증 로직 추가 가능)
    func updateButtonState(isValid: Bool) {
        isButtonEnabled = isValid
    }
    
    func getSelection(for type: SelectionType) -> String {
        switch type {
        case .job:
            return selectedJob
        case .subJob:
            return selectedSubJob
        case .experience:
            return selectedExperience
        }
    }
    
    // ✅ 선택된 옵션 업데이트
    func updateSelection(for type: SelectionType, with value: String) {
        switch type {
        case .job:
            selectedJob = value
        case .subJob:
            selectedSubJob = value
        case .experience:
            selectedExperience = value
        }
    }
    
    func updateSchedule(index: Int, content: String) {
        schedules[index] = content
    }
    // ✅ 선택 타입 정의
    enum SelectionType {
        case job, subJob, experience
    }
    
    // ✅ 해당 타입의 옵션을 반환하는 함수 추가
    func getOptions(for type: SelectionType) -> [String] {
        switch type {
        case .job:
            return jobOptions
        case .subJob:
            return subJobOptions
        case .experience:
            return experienceOptions
        }
    }
    
    func getTitle(for type: SelectionType) -> String {
        switch type {
        case .job: return "직무 선택"
        case .subJob: return "세부 직무 선택"
        case .experience: return "총 경력 선택"
        }
    }
    
}
