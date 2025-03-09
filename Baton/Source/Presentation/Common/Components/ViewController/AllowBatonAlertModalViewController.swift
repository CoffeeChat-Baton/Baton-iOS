import UIKit
import SwiftUI

class AllowBatonAlertModalViewController: BaseAlertModalViewController {
    private let tagContainerView = UIView()
    private let timeTag: BatonTag
    private let scheduleLabel: UILabel
    
    init(title: String, subtitle: String, time: String, schedule: String, actionHandler: @escaping (String?) -> Void) {
        self.timeTag = BatonTag(content: time, type: .alertTime)
        self.scheduleLabel = UILabel.makeLabel(text: schedule, textColor: .main, fontStyle: .body1)
        scheduleLabel.textAlignment = .center
        super.init(title: title, subtitle: subtitle, closeTitle: "취소", actionTitle: "수락하기", actionHandler: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        actionButton.backgroundColor = .main
        
        timeTag.translatesAutoresizingMaskIntoConstraints = false
        scheduleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        tagContainerView.addSubview(timeTag)
        addContentView(tagContainerView)
        addContentView(scheduleLabel)
        
        NSLayoutConstraint.activate([
            tagContainerView.heightAnchor.constraint(equalToConstant: 32),
            timeTag.centerXAnchor.constraint(equalTo: tagContainerView.centerXAnchor),
            timeTag.centerYAnchor.constraint(equalTo: tagContainerView.centerYAnchor),
            
            timeTag.widthAnchor.constraint(equalToConstant: timeTag.intrinsicContentSize.width),
            timeTag.heightAnchor.constraint(equalToConstant: timeTag.intrinsicContentSize.height)
        ])
    }

    override func actionButtonTapped() {
        super.actionButtonTapped()
    }
}

// ✅ 텍스트 입력 가능한 알림 모달 미리보기
struct AllowInputAlertModalPreview: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> AllowBatonAlertModalViewController {
        let modal = AllowBatonAlertModalViewController(
            title: "신청을 수락하시겠어요?",
            subtitle: "날짜와 시간을 확인하셨나요?\n수락한 뒤에는 일정 변경이 불가해요.",
            time: "20",
            schedule: "05.05 (일) 13:30 - 13:50",
            actionHandler: {_ in
                print("✅ 입력된 값 확인")
            }
        )
        return modal
    }

    func updateUIViewController(_ uiViewController: AllowBatonAlertModalViewController, context: Context) {}
}

struct AllowAlertModal_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.all)
            
            AllowInputAlertModalPreview()
                .edgesIgnoringSafeArea(.all)
                .previewLayout(.sizeThatFits)
        }
    }
}

