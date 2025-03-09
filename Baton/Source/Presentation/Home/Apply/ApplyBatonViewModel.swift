import Combine
import Foundation

struct Schedule {
    let date: String
    let startTime: String
    let endTime: String
}

class ApplyBatonViewModel: ObservableObject {
    let transIndexToTime: [Int : Int] = [0:20, 1:30, 2:40]
    
    @Published var time: Int = 0
    @Published var schedules: [Schedule] = [
        Schedule(date: "", startTime: "", endTime: ""),
        Schedule(date: "", startTime: "", endTime: ""),
        Schedule(date: "", startTime: "", endTime: ""),
    ]
    @Published var question: String = ""
    @Published var attachedFile: Data?
    
    func updateTime(index: Int) {
        self.time = transIndexToTime[index] ?? 0
    }
    
    func updateSchedule(index: Int, schedule: Schedule) {
        schedules[index] = schedule
    }
    
    func updateQuestion(_ question: String) {
        self.question = question
    }
    
    func updateAttachedFile(_ file: Data) {
        self.attachedFile = file
    }
}
