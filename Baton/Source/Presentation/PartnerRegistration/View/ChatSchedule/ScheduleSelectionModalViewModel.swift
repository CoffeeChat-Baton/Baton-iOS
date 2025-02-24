import Combine

class ScheduleSelectionViewModel: ObservableObject {
    @Published var index: Int = 0
    @Published var selectedDays: Set<String> = []
    @Published var startTime: String = ""
    @Published var endTime: String = ""
    
    init(index: Int, selectedDays: Set<String>, startTime: String, endTime: String) {
        self.index = index
        self.selectedDays = selectedDays
        self.startTime = startTime
        self.endTime = endTime
    }
    
    func updateIndex(_ index: Int) {
        self.index = index
    }
    
    func updateSelection(day: String, isSelected: Bool) {
        if isSelected {
            selectedDays.insert(day)
        } else {
            selectedDays.remove(day)
        }
    }
    
    func updateStartTime(_ time: String) {
        startTime = time
        print("시작 시간", startTime)
    }
    
    func updateEndTime(_ time: String) {
        endTime = time
        print("종료 시간", endTime)
    }
}
