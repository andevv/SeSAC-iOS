//
//  CustomObservable.swift
//  SeSAC0822Homework
//
//  Created by andev on 8/25/25.
//

import Foundation
import RxSwift
import Alamofire

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

extension CustomObservable {
    static func getBoxOffice(date: String, apiKey: String) -> Observable<[DailyBoxOffice]> {
        return Observable<[DailyBoxOffice]>.create { observer in
            let url = "https://kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json"
            let params: Parameters = ["key": apiKey, "targetDt": date]

            AF.request(url, parameters: params)
                .validate()
                .responseDecodable(of: BoxOfficeResponse.self) { response in
                    switch response.result {
                    case .success(let data):
                        observer.onNext(data.boxOfficeResult.dailyBoxOfficeList)
                        observer.onCompleted()
                    case .failure(let error):
                        observer.onError(error)
                    }
                }
            return Disposables.create()
        }
    }
}
