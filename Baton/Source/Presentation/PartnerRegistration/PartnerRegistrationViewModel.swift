import Foundation
import Combine

class PartnerRegistrationViewModel {

    // ✅ 현재 스텝 인덱스 (UI 업데이트 자동 트리거)
    @Published private(set) var currentStepIndex: Int = 0
    var cancellables = Set<AnyCancellable>()
    var onCompletion: (() -> Void)? // ✅ 마지막 스텝 완료 시 실행할 클로저

    // ✅ 버튼 활성화 상태
    @Published var isButtonEnabled: Bool = false
    let steps: [BaseContent] = [
            BaseContent(mainTitle: "프로필 정보를 확인해주세요",
                        subTitle: "파트너 프로필에 보여지는 정보입니다.\n아래 정보가 정확한지 다시 한 번 확인해주세요!",
                        actionButtonTitle: "다음"),

            BaseContent(mainTitle: "재직 사실을 인증해주세요",
                        subTitle: "재직을 증명할 수 있는 서류(재직증명서, 사원증 등)를 업로드해주세요.",
                        actionButtonTitle: "다음"),

            BaseContent(mainTitle: "커피챗 가능한 시간 등록",
                        subTitle: "희망하는 커피챗 시간을 선택해주세요.",
                        actionButtonTitle: "다음"),

            BaseContent(mainTitle: "자신을 소개하는 글을 작성해주세요",
                        subTitle: "파트너 프로필에 보여질 소개 글을 입력해주세요.",
                        actionButtonTitle: "완료")
        ]
    var totalSteps: Int {
        return steps.count
    }

    var currentStep: BaseContent {
        return steps[currentStepIndex]
    }

    // ✅ 다음 스텝으로 이동
    func goToNextStep() {
        if currentStepIndex < steps.count - 1 {
            currentStepIndex += 1
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
}
