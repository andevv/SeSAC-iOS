//
//  LottoModel.swift
//  SeSAC0822Homework
//
//  Created by andev on 8/26/25.
//

import Foundation

struct Lotto: Decodable {
    let drwNoDate: String
    let drwtNo1: Int
    let drwtNo2: Int
    let drwtNo3: Int
    let drwtNo4: Int
    let drwtNo5: Int
    let drwtNo6: Int
    let bnusNo: Int
}

enum LottoError: Error {
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
