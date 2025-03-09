import Combine

class ApplyScheduleSelectionViewModel: ObservableObject {
    @Published var index: Int
    @Published var date: String
    @Published var startTime: String
    @Published var endTime: String
    
    init(index: Int = 0,
         date: String = "",
         startTime: String = "",
         endTime: String = "")
    {
        self.index = index
        self.date = date
        self.startTime = startTime
        self.endTime = endTime
    }
    
    func updateIndex(_ index: Int) {
        self.index = index
    }
    
    func updateDate(_ date: String) {
        self.date = date
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
