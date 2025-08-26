//
//  BoxOfficeModel.swift
//  SeSAC0822Homework
//
//  Created by andev on 8/27/25.
//

import Foundation

struct BoxOfficeResponse: Decodable {
    let boxOfficeResult: BoxOfficeResult
}
struct BoxOfficeResult: Decodable {
    let dailyBoxOfficeList: [DailyBoxOffice]
}
struct DailyBoxOffice: Decodable {
    let rank: String
    let movieNm: String
}

enum BoxOfficeError: Error {
    case decoding
    case network(String)
    case unknown

    var message: String {
        switch self {
        case .decoding: return "데이터 디코딩 실패"
        case .network(let msg): return "네트워크 통신 실패 (\(msg))"
        case .unknown: return "알 수 없는 오류 발생"
        }
    }
}
