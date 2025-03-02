import UIKit
import Combine

struct CategoryWithName {
    let image: UIImage?
    let name: String
}

class HomeViewModel: ObservableObject {
    @Published var categories: [CategoryWithName] = []

    init() {
        loadCategories()
    }

    private func loadCategories() {
        let categoryNames = [
            "경영", "서비스기획", "개발", "데이터·AI·ML", "마케팅",
            "디자인", "미디어", "이커머스", "금융", "회계",
            "인사", "고객·영업", "게임", "물류", "의료",
            "연구", "엔지니어링", "생산", "교육", "법률·특허",
            "공공"
        ]

        let categoryImages: [UIImage?] = [
            UIImage(resource: .categoryBusins),
            UIImage(resource: .categoryService),
            UIImage(resource: .categoryDev),
            UIImage(resource: .categoryData),
            UIImage(resource: .categoryMarketing),
            UIImage(resource: .categoryDesign),
            UIImage(resource: .categoryMedia),
            UIImage(resource: .categoryEcommerce),
            UIImage(resource: .categoryFinance),
            UIImage(resource: .categoryAccounting),
            UIImage(resource: .categoryHrCustomersale),
            UIImage(resource: .categoryHrCustomersale),
            UIImage(resource: .categoryGame),
            UIImage(resource: .categoryMarketing),
            UIImage(resource: .categoryMedical),
            UIImage(resource: .categoryResearch),
            UIImage(resource: .categoryEngineering),
            UIImage(resource: .categoryProduction),
            UIImage(resource: .categoryEducation),
            UIImage(resource: .categoryLaw),
            UIImage(resource: .categoryPublic)
        ]

        categories = zip(categoryImages, categoryNames).map { CategoryWithName(image: $0, name: $1) }
    }
}
