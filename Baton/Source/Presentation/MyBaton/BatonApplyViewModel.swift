import Foundation
import Combine

class BatonApplyViewModel {
    @Published var profile: Baton
    @Published var endDate: Date
    @Published var preQuestion: String
    @Published var attachedFile: Data?
    @Published var mentorReview: String
    
    init() {
        self.profile = Baton(imageName: "", name: "", company: "", description: "", canStart: nil)
        self.endDate = Date()
        self.preQuestion = ""
        self.attachedFile = nil
        self.mentorReview = ""
    }
}
