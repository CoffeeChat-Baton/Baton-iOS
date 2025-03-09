import UIKit
import Combine

class ShowBatonsViewModel {
    
    @Published var datas: [Baton] = []
    @Published var currfilter: FilterType = .all
    
    enum FilterType: String {
        case baton = "바통"
        case portfolioReview = "포트폴리오 리뷰"
        case resumeCheck = "이력서 첨삭"
        case all = "모두 보기"
    }
    
    func updateFilter(_ filter: FilterType) {
        currfilter = filter
        print(currfilter)
    }
    
}

struct Baton {
    let imageName: String
    let name: String
    let company: String
    let description: String
    let canStart: Bool?
    let shortIntro: String?
    
    init(imageName: String, name: String, company: String, description: String, canStart: Bool?, shortIntro: String? = nil) {
        self.imageName = imageName
        self.name = name
        self.company = company
        self.description = description
        self.canStart = canStart
        self.shortIntro = shortIntro
    }
}
