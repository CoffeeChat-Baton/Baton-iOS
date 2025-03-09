import UIKit

protocol BatonCalendarDelegate: AnyObject {
    func didSelectDate(_ date: String)
}

class BatonCalendarView: UIView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    weak var delegate: BatonCalendarDelegate?
    
    // MARK: - UI Components
    private let monthLabel = UILabel()
    private let prevButton = UIButton()
    private let nextButton = UIButton()
    private var collectionView: UICollectionView!
    private var selectedIndexPath: IndexPath? // 선택된 셀 추적
    private let dayHeaderStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.spacing = 0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    private let dayTitles = ["일", "월", "화", "수", "목", "금", "토"]
    
    // 현재 표시할 달
    private var currentDate = Date()
    
    // 캘린더 데이터 관련 변수
    private var days = [String]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupCollectionView()
        loadCalendarData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let itemWidth = (self.bounds.width - 20) / 7
            print("📌 itemWidth (Updated):", itemWidth) // ✅ 디버깅용
            layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
            layout.invalidateLayout() // ✅ 레이아웃 다시 계산
        }
    }
    
    private func setupUI() {        
        // 📌 월 표시 라벨
        monthLabel.textAlignment = .center
        monthLabel.pretendardStyle = .title2
        
        // 📌 이전/다음 버튼 (이미지 설정)
        prevButton.setImage(UIImage(resource: .arrowLeft), for: .normal)
        prevButton.addTarget(self, action: #selector(prevMonth), for: .touchUpInside)
        
        nextButton.setImage(UIImage(resource: .arrowRight), for: .normal)
        nextButton.addTarget(self, action: #selector(nextMonth), for: .touchUpInside)
        
        // 📌 상단 헤더 (이전/다음 버튼 + 월 표시)
        let headerStack = UIStackView(arrangedSubviews: [UIView(), prevButton, monthLabel, nextButton, UIView()])
        headerStack.axis = .horizontal
        headerStack.alignment = .center
        headerStack.distribution = .equalSpacing
        headerStack.spacing = 6
        headerStack.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(headerStack)
        
        for (index, title) in dayTitles.enumerated() {
            let label = UILabel()
            label.text = title
            label.textAlignment = .center
            label.pretendardStyle = .caption2
            label.textColor = .gray5
            dayHeaderStackView.addArrangedSubview(label)
        }
        self.addSubview(dayHeaderStackView)
        
        NSLayoutConstraint.activate([
            prevButton.widthAnchor.constraint(equalToConstant: 24),
            prevButton.heightAnchor.constraint(equalToConstant: 24),

            nextButton.widthAnchor.constraint(equalToConstant: 24),
            nextButton.heightAnchor.constraint(equalToConstant: 24),

            headerStack.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            headerStack.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            headerStack.heightAnchor.constraint(equalToConstant: 29),
            headerStack.widthAnchor.constraint(equalToConstant: 200),
            
            dayHeaderStackView.topAnchor.constraint(equalTo: headerStack.bottomAnchor),
            dayHeaderStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            dayHeaderStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            dayHeaderStackView.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        let itemWidth = (self.frame.width - 20) / 7
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(CalendarCell.self, forCellWithReuseIdentifier: "CalendarCell")
        
        self.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: dayHeaderStackView.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    private func loadCalendarData() {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: currentDate)
        
        if let firstDayOfMonth = calendar.date(from: components) {
            let range = calendar.range(of: .day, in: .month, for: firstDayOfMonth)!
            let weekday = calendar.component(.weekday, from: firstDayOfMonth) - 1 // ✅ 시작 요일 반영
            
            days = Array(repeating: "", count: weekday) + (1...range.count).map { "\($0)" }
            
               // ✅ 디버깅용 프린트 추가
               print("📅 \(components.year!)년 \(components.month!)월 달력 로드")
               print("🗓 요일 시작 위치: \(weekday), 총 날짜 수: \(range.count)")
               print("📌 days 배열: \(days)")
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 M월"
        monthLabel.text = formatter.string(from: currentDate)
        
        collectionView.reloadData()
    }
    
    @objc private func prevMonth() {
        currentDate = Calendar.current.date(byAdding: .month, value: -1, to: currentDate)!
        loadCalendarData()
    }

    @objc private func nextMonth() {
        currentDate = Calendar.current.date(byAdding: .month, value: 1, to: currentDate)!
        loadCalendarData()
    }
    
    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return days.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CalendarCell", for: indexPath) as! CalendarCell
        let day = days[indexPath.item]
        let isSelectable = !day.isEmpty
        cell.isUserInteractionEnabled = isSelectable
        cell.configure(day: day)
        cell.updateSelection(isSelected: indexPath == selectedIndexPath)
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedDay = days[indexPath.item]
        guard !selectedDay.isEmpty, let selectedDate = getDate(from: selectedDay) else { return }
        
        selectedIndexPath = indexPath
        collectionView.reloadData()
        delegate?.didSelectDate(selectedDate)
    }
    
    private func getDate(from day: String) -> String? {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month], from: currentDate)
        components.day = Int(day)
        guard let date = calendar.date(from: components) else { return nil }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
}


class CalendarCell: UICollectionViewCell {
    private let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.pretendardStyle = .title2
        label.textColor = .bblack
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let selectionBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.main
        view.layer.cornerRadius = 12 // 둥근 사각형 효과
        view.isHidden = true // 기본적으로 숨김 처리
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        backgroundColor = .red
//
//        contentView.layer.cornerRadius = 12
//        contentView.layer.masksToBounds = true
        contentView.backgroundColor = .clear
        contentView.addSubview(label)
        contentView.addSubview(selectionBackgroundView)
        
        NSLayoutConstraint.activate([
            selectionBackgroundView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            selectionBackgroundView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            selectionBackgroundView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            selectionBackgroundView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            
            label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(day: String) {
        label.text = day
        label.isHidden = day.isEmpty
    }
    
    func updateSelection(isSelected: Bool) {
        selectionBackgroundView.isHidden = !isSelected // 선택 시 배경 표시
        label.textColor = isSelected ? UIColor.bwhite : UIColor.bblack
        selectionBackgroundView.layer.zPosition = -1 // 배경이 라벨 뒤로 가도록 설정
    }
}

#if DEBUG
import SwiftUI

struct CalendarPreview: UIViewRepresentable {
    func makeUIView(context: Context) -> BatonCalendarView {
        return BatonCalendarView()
    }
    
    func updateUIView(_ uiView: BatonCalendarView, context: Context) {}

    static var previews: some View {
        CalendarPreview()
            .edgesIgnoringSafeArea(.all)
            .previewDisplayName("Custom Calendar")
    }
}

struct CalendarPreview_Previews: PreviewProvider {
    static var previews: some View {
        CalendarPreview()
        
    }
}
#endif
