//
//  DateFormatter+Extension.swift
//  SeSAC0719Homework
//
//  Created by andev on 7/20/25.
//

import Foundation


extension DateFormatter {
    static func timeFormat(from dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy-MM-dd HH:mm"

        guard let date = formatter.date(from: dateString) else { return "" }

        formatter.dateFormat = "hh:mm a"
        return formatter.string(from: date)
    }
}
