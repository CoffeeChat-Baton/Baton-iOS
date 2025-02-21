import UIKit

class CustomTimePickerButton: UIButton {
    
    var onTimeSelected: ((String) -> Void)?
    var selectedTime: String?
       
    
    init(title: String = "시간 선택") {
        super.init(frame: .zero)
        setupButton(title: title)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupButton(title: String) {
        setTitle(title, for: .normal)
        setTitleColor(.bblack, for: .normal)
        titleLabel?.pretendardStyle = .body2
        backgroundColor = UIColor.white
        layer.cornerRadius = 12
        layer.borderColor = UIColor.gray3.cgColor
        layer.borderWidth = 1
        
        addTarget(self, action: #selector(showTimePicker), for: .touchUpInside)
    }
    
    @objc private func showTimePicker() {
        let alert = UIAlertController(title: "시간 선택", message: "\n\n\n\n\n\n\n\n", preferredStyle: .actionSheet)
        
        let timePicker = UIDatePicker()
        timePicker.datePickerMode = .time
        timePicker.preferredDatePickerStyle = .wheels // 🔥 휠 스타일 적용
        timePicker.frame = CGRect(x: 0, y: 40, width: alert.view.bounds.width - 20, height: 200)
        
        alert.view.addSubview(timePicker)
        
        let selectAction = UIAlertAction(title: "확인", style: .default) { _ in
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            let selectedTime = formatter.string(from: timePicker.date)
            self.onTimeSelected?(selectedTime)
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(selectAction)
        alert.addAction(cancelAction)
        if let topVC = findViewController() {
            topVC.present(alert, animated: true, completion: nil)
        }
    }
    
    func updateTitle(_ title: String) {
        setTitle(title, for: .normal)
    }
}
