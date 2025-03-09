import UIKit

class SelectOptionAlertModalViewController: BaseAlertModalViewController {
    
    private let options: [String]
    private var selectedIndex: Int?
    private var optionViews: [SelectableOptionView] = []
    
    init(title: String, subtitle: String, options: [String], actionHandler: @escaping (String?) -> Void) {
        self.options = options
        super.init(title: title, subtitle: subtitle, actionTitle: "확인", actionHandler: nil)

        self.actionHandler = { [weak self] in
            guard let self = self else { return }
            if let index = self.selectedIndex {
                actionHandler(self.options[index])
            } else {
                actionHandler(self.optionViews.last?.getTextInput()) // ✅ 마지막 입력값 전달
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupOptions()
    }
    
    private func setupOptions() {
        for (index, option) in options.enumerated() {
            let optionView = SelectableOptionView(title: option)
            optionView.tag = index
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(optionTapped(_:)))
            optionView.addGestureRecognizer(tapGesture)
            optionViews.append(optionView)
            addContentView(optionView)
        }
        
        // ✅ 마지막에 직접 입력 옵션 추가
        let customOptionView = SelectableOptionView(title: "", isCustomInput: true)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(customOptionTapped(_:)))
        customOptionView.addGestureRecognizer(tapGesture)
        optionViews.append(customOptionView)
        addContentView(customOptionView)
    }
    
    @objc private func optionTapped(_ sender: UITapGestureRecognizer) {
        guard let selectedView = sender.view as? SelectableOptionView else { return }
        let index = selectedView.tag
        
        for view in optionViews {
            view.isSelectedOption = (view == selectedView)
        }
        
        selectedIndex = index
    }
    
    @objc private func customOptionTapped(_ sender: UITapGestureRecognizer) {
        guard let selectedView = sender.view as? SelectableOptionView else { return }
        
        for view in optionViews {
            view.isSelectedOption = false
        }
        
        selectedView.isSelectedOption = true
        selectedIndex = nil // ✅ 직접 입력 모드일 때 기존 선택 해제
    }
}

import SwiftUI

struct SelectOptionAlertPreview: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> SelectOptionAlertModalViewController {
        return SelectOptionAlertModalViewController(
            title: "옵션을 선택하세요",
            subtitle: "하나의 옵션을 선택하거나 직접 입력할 수 있습니다.",
            options: ["선택지 1", "선택지 2", "선택지 3"],
            actionHandler: { selectedOption in
                print("선택한 값: \(selectedOption ?? "입력 없음")")
            }
        )
    }
    
    func updateUIViewController(_ uiViewController: SelectOptionAlertModalViewController, context: Context) {}
}

struct SelectOptionAlert_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black.opacity(0.4).edgesIgnoringSafeArea(.all)
            SelectOptionAlertPreview()
                .edgesIgnoringSafeArea(.all)
                .previewLayout(.sizeThatFits)
        }
    }
}


class SelectableOptionView: UIView {
    
    private let iconView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "check")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isHidden = true // 초기에는 숨김
        return imageView
    }()
    
    private let selectionIndicator: UIView = {
        let view = UIView()
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.gray3.cgColor
        view.layer.cornerRadius = 9
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .bblack
        label.pretendardStyle = .body4
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let inputField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.placeholder = "직접 입력"
        textField.textColor = .bblack
        textField.font = UIFont.Pretendard.body4.font
        textField.isHidden = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    var isSelectedOption: Bool = false {
        didSet {
            updateSelectionState()
        }
    }
    
    var isCustomInput: Bool = false {
        didSet {
            titleLabel.isHidden = isCustomInput
            inputField.isHidden = !isCustomInput
        }
    }
    
    init(title: String, isCustomInput: Bool = false) {
        super.init(frame: .zero)
        self.isCustomInput = isCustomInput
        if isCustomInput {
            setupCustomInput()
        } else {
            self.titleLabel.text = title
        }
        setupLayout()
        updateSelectionState()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCustomInput() {
        inputField.isHidden = false
        titleLabel.isHidden = true
    }
    
    private func setupLayout() {
        self.layer.cornerRadius = 12
        self.backgroundColor = .gray1
        self.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(selectionIndicator)
        addSubview(iconView)
        addSubview(titleLabel)
        addSubview(inputField)
        
        NSLayoutConstraint.activate([
            selectionIndicator.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            selectionIndicator.centerYAnchor.constraint(equalTo: centerYAnchor),
            selectionIndicator.widthAnchor.constraint(equalToConstant: 18),
            selectionIndicator.heightAnchor.constraint(equalToConstant: 18),
            
            iconView.centerXAnchor.constraint(equalTo: selectionIndicator.centerXAnchor),
            iconView.centerYAnchor.constraint(equalTo: selectionIndicator.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 18),
            iconView.heightAnchor.constraint(equalToConstant: 18),
            
            titleLabel.leadingAnchor.constraint(equalTo: selectionIndicator.trailingAnchor, constant: 8),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            
            inputField.leadingAnchor.constraint(equalTo: selectionIndicator.trailingAnchor, constant: 8),
            inputField.centerYAnchor.constraint(equalTo: centerYAnchor),
            inputField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            
            heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    private func updateSelectionState() {
        if isSelectedOption {
            selectionIndicator.backgroundColor = .main
            selectionIndicator.layer.borderWidth = 0
            iconView.isHidden = false
            layer.borderWidth = 1
            layer.borderColor = UIColor.main.cgColor
            backgroundColor = .blue1
        } else {
            selectionIndicator.backgroundColor = .bwhite
            selectionIndicator.layer.borderWidth = 1
            selectionIndicator.layer.borderColor = UIColor.gray3.cgColor
            iconView.isHidden = true
            layer.borderWidth = 0
            backgroundColor = .gray1
        }
    }
    
    func getTextInput() -> String? {
        return isCustomInput ? inputField.text : nil
    }
}
