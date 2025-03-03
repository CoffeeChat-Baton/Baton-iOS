import Foundation
import Combine

class LoginViewModel: BaseViewModelType {
    var steps: [BaseContent] = [
        BaseContent(mainTitle: "혼자 해결하기\n막막한 고민이 있나요?", subTitle: "", actionButtonTitle: "다음"),
        BaseContent(mainTitle: "현업 전문가에게\n직접 질문하고,\n필요한 피드백을 받아보세요", subTitle: "", actionButtonTitle: "다음"),
        BaseContent(mainTitle: "바통을 건네는 순간,\n새로운 기회가 시작됩니다", subTitle: "", actionButtonTitle: "시작하기"),
        BaseContent(mainTitle: "바통과 함께\n경험을 나누고,\n연결을 이어가다", subTitle: "", actionButtonTitle: "Apple로 로그인"),
    ]
    
    var currentStepIndexPublisher: Published<Int>.Publisher { $currentStepIndex }
    
    var cancellables: Set<AnyCancellable> = []
    
    @Published var currentStepIndex: Int = 0
    
    func goToNextStep() {
        if currentStepIndex < steps.count - 1 {
            currentStepIndex += 1
            if currentStepIndex == steps.count - 2 { // 파트너 등록 진짜 하는 시기
                // 멘토 등록하기
            }
        } else {
            
        }
    }
    
    func goToLogin() {
        currentStepIndex = steps.count - 1
    }
}
