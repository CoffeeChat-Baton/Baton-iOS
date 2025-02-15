import UIKit
import Combine

class JobInfoViewModel {
    
    // ✅ 선택된 값 (UI가 업데이트됨)
    @Published var selectedJob: String = "직무 선택"
    @Published var selectedSubJob: String = "세부 직무 선택"
    @Published var companyName: String = ""
    @Published var selectedExperience: String = "경력 선택"
    // ✅ 각 버튼에 대한 선택 옵션 데이터
    let jobOptions = JobCategory.all
    let subJobOptions = ["프론트엔드", "백엔드", "풀스택"]
    let experienceOptions = ExperienceYears.all
    
    // ✅ 선택된 옵션 업데이트
    func updateSelection(for type: SelectionType, with value: String) {
        switch type {
        case .job:
            selectedJob = value
        case .subJob:
            selectedSubJob = value           
        case .experience:
            selectedExperience = value
        }
    }
    
    // ✅ 선택 타입 정의
    enum SelectionType {
        case job, subJob, experience
    }
    
    // ✅ 해당 타입의 옵션을 반환하는 함수 추가
    func getOptions(for type: SelectionType) -> [String] {
        switch type {
        case .job:
            return jobOptions
        case .subJob:
            return subJobOptions
        case .experience:
            return experienceOptions
        }
    }
    
    func getTitle(for type: JobInfoViewModel.SelectionType) -> String {
        switch type {
        case .job: return "직무 선택"
        case .subJob: return "세부 직무 선택"
        case .experience: return "총 경력 선택"
        }
    }
}
