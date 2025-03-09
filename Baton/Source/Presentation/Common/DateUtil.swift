import Foundation

enum DateUtil {
    static func formatToKoreanDate(_ dateString: String) -> String? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "ko_KR")
        
        guard let date = formatter.date(from: dateString) else { return nil }
        
        let resultFormatter = DateFormatter()
        resultFormatter.dateFormat = "M월 d일 (E)" // ✅ "10월 31일 (금)" 형태
        resultFormatter.locale = Locale(identifier: "ko_KR")
        
        return resultFormatter.string(from: date)
    }
}
