//
//  CustomObservable.swift
//  SeSAC0822Homework
//
//  Created by andev on 8/25/25.
//

import Foundation
import RxSwift
import Alamofire

final class CustomObservable {
    
    static func getLotto(query: String) -> Observable<Lotto> {
        
        return Observable<Lotto>.create { observer in
            let url = "https://www.dhlottery.co.kr/common.do?method=getLottoNumber&drwNo=\(query)"
            
            AF.request(url).responseDecodable(of: Lotto.self) { response in
                switch response.result {
                case .success(let value):
                    print(value)
                    
                    observer.onNext(value)
                    observer.onCompleted()
                    
                case .failure(let error):
                    print(error)
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }
}

final class LottoService {
    static let shared = LottoService()
    private init() {}

    // 실패도 error 이벤트로 던지지 않고 success(Result.failure)로 래핑
    func fetch(draw: Int) -> Single<Result<Lotto, LottoError>> {
        Single<Result<Lotto, LottoError>>.create { single in
            let url = "https://www.dhlottery.co.kr/common.do"
            let params: Parameters = ["method": "getLottoNumber", "drwNo": draw]

            let req = AF.request(url, parameters: params)
                .validate()
                .responseDecodable(of: Lotto.self) { response in
                    switch response.result {
                    case .success(let lotto):
                        single(.success(.success(lotto)))
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
