import Foundation
import Combine

class LoginViewModel: BaseViewModelType {
    var steps: [BaseContent] = [
        BaseContent(mainTitle: "", subTitle: "", actionButtonTitle: "다음"),
        BaseContent(mainTitle: "", subTitle: "", actionButtonTitle: "다음"),
        BaseContent(mainTitle: "", subTitle: "", actionButtonTitle: "시작하기"),
        BaseContent(mainTitle: "", subTitle: "", actionButtonTitle: "애플로 로그인"),
    ]
    
    var currentStepIndexPublisher: Published<Int>.Publisher { $currentStepIndex }
    
    var cancellables: Set<AnyCancellable> = []
    
    @Published var currentStepIndex: Int = 0
    
    func goToNextStep() {}
    func goToLogin() {}
}
