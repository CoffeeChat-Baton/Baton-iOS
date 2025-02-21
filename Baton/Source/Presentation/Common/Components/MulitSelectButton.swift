import UIKit

class MulitSelectButton: UIButton {
    var isSelectedState: Bool = false {
        didSet { updateAppearance() }
    }

    var onSelectionChanged: ((Bool) -> Void)? // 선택 상태 변경 시 실행될 클로저

    init(title: String) {
        super.init(frame: .zero)
        configureButton(title: title)
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureButton(title: String, isSelectd: Bool = false) {
        setTitle(title, for: .normal)
        setTitleColor(.black, for: .normal)
        layer.cornerRadius = 12
        layer.borderWidth = 1
        updateAppearance()
    }

    @objc private func buttonTapped() {
        isSelectedState.toggle()
        onSelectionChanged?(isSelectedState) // 상태 변경 시 클로저 실행
    }

    private func updateAppearance() {
        titleLabel?.pretendardStyle = isSelectedState ? .body1 : .body2
        setTitleColor(isSelectedState ? UIColor.bblack : UIColor.gray5, for: .normal)
        backgroundColor = isSelectedState ? UIColor.blue1 : UIColor.gray1
        layer.borderColor = isSelectedState ? UIColor.main.cgColor : UIColor.clear.cgColor
    }
}
