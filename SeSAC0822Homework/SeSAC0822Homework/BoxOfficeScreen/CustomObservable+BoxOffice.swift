//
//  CustomObservable.swift
//  SeSAC0822Homework
//
//  Created by andev on 8/25/25.
//

import Foundation
import RxSwift
import Alamofire

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

final class BoxOfficeService {
    static let shared = BoxOfficeService()
    private init() {}

    func fetch(date: String, apiKey: String) -> Single<Result<[DailyBoxOffice], BoxOfficeError>> {
        Single<Result<[DailyBoxOffice], BoxOfficeError>>.create { single in
            let url = "https://kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json"
            let params: Parameters = ["key": apiKey, "targetDt": date]

            let req = AF.request(url, parameters: params)
                .validate()
                .responseDecodable(of: BoxOfficeResponse.self) { response in
                    switch response.result {
                    case .success(let data):
                        single(.success(.success(data.boxOfficeResult.dailyBoxOfficeList)))
                    case .failure(let afError):
                        if case .responseSerializationFailed(let reason) = afError,
                           case .decodingFailed = reason {
                            single(.success(.failure(.decoding)))
                        } else {
                            single(.success(.failure(.network(afError.localizedDescription))))
                        }
                    }
                }

            return Disposables.create { req.cancel() }
        }
    }
}
