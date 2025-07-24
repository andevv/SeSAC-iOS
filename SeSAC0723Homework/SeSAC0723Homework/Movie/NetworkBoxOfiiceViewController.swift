//
//  NetworkBoxOfiiceViewController.swift
//  SeSAC0723Homework
//
//  Created by andev on 7/24/25.
//

import UIKit
import SnapKit
import Alamofire

// MARK: - 프로토콜 정의
protocol ConfigureLabel: AnyObject {
    func applyDefaultStyle()
}

// UILabel 타입만 프로토콜 사용 가능하도록
extension ConfigureLabel where Self: UILabel {
    func applyDefaultStyle() {
        self.font = .systemFont(ofSize: 14)
        self.textColor = .black
        self.numberOfLines = 1
    }
}

// 프로토콜 채택
extension UILabel: ConfigureLabel {}

// MARK: - 디코딩
struct BoxOfficeResponse: Decodable {
    let boxOfficeResult: BoxOfficeResult
}

struct BoxOfficeResult: Decodable {
    let dailyBoxOfficeList: [DailyBoxOffice]
}

struct DailyBoxOffice: Decodable {
    let rank: String
    let movieNm: String
    let openDt: String
}

// MARK: - ViewController
class NetworkBoxOfiiceViewController: UIViewController {
    
    // UI 요소 정의
    private let dateTextField = UITextField()

    private let rankLabel1 = UILabel()
    private let titleLabel1 = UILabel()
    private let dateLabel1 = UILabel()

    private let rankLabel2 = UILabel()
    private let titleLabel2 = UILabel()
    private let dateLabel2 = UILabel()

    private let rankLabel3 = UILabel()
    private let titleLabel3 = UILabel()
    private let dateLabel3 = UILabel()
    
    // API Key
    private let apiKey = Bundle.main.object(forInfoDictionaryKey: "MOVIE_API_KEY") as? String ?? ""
    private let initialDate = "20250723"
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setup()
        layout()
        fetchBoxOffice(date: initialDate)
    }
    
    // MARK: - UI 설정
    private func setup() {
        dateTextField.borderStyle = .roundedRect
        dateTextField.placeholder = "날짜를 입력하세요"
        dateTextField.text = initialDate
        dateTextField.keyboardType = .default
        dateTextField.returnKeyType = .done
        dateTextField.delegate = self
        view.addSubview(dateTextField)
        
        let labels = [
            rankLabel1, titleLabel1, dateLabel1,
            rankLabel2, titleLabel2, dateLabel2,
            rankLabel3, titleLabel3, dateLabel3
        ]

        labels.forEach {
            $0.applyDefaultStyle()
            view.addSubview($0)
        }
    }
    
    // MARK: - 레이아웃 설정
    private func layout() {
        dateTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(24)
            make.centerX.equalToSuperview()
            make.width.equalTo(220)
            make.height.equalTo(44)
        }

        let labels = [
            rankLabel1, titleLabel1, dateLabel1,
            rankLabel2, titleLabel2, dateLabel2,
            rankLabel3, titleLabel3, dateLabel3
        ]

        for (i, label) in labels.enumerated() {
            label.snp.makeConstraints { make in
                make.top.equalTo(dateTextField.snp.bottom).offset(20 + (i * 24))
                make.leading.equalToSuperview().offset(20)
            }
        }
    }
    
    
    // MARK: - API 호출
    private func fetchBoxOffice(date: String) {
        let url = "https://kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json"
        let parameters: Parameters = [
            "key": apiKey,
            "targetDt": date
        ]
        
        AF.request(url, parameters: parameters)
            .validate()
            .responseDecodable(of: BoxOfficeResponse.self) { [weak self] response in
                guard let self = self else { return }
                switch response.result {
                case .success(let data):
                    let list = data.boxOfficeResult.dailyBoxOfficeList
                    self.updateLabels(with: Array(list.prefix(3)))
                case .failure(let error):
                    print("fail:", error.localizedDescription)
                }
            }
    }
    
    // MARK: - 결과 업데이트
    private func updateLabels(with movies: [DailyBoxOffice]) {
        let labels = [
            (rankLabel1, titleLabel1, dateLabel1),
            (rankLabel2, titleLabel2, dateLabel2),
            (rankLabel3, titleLabel3, dateLabel3)
        ]

        for i in 0..<3 {
            if i < movies.count {
                let movie = movies[i]
                labels[i].0.text = "순위: \(movie.rank)위"
                labels[i].1.text = "제목: \(movie.movieNm)"
                labels[i].2.text = "개봉일: \(movie.openDt)"
            } else {
                labels[i].0.text = ""
                labels[i].1.text = ""
                labels[i].2.text = ""
            }
        }
    }
}

// MARK: - UITextFieldDelegate
extension NetworkBoxOfiiceViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let date = textField.text, date.count == 8 else {
            return true
        }
        fetchBoxOffice(date: date)
        textField.resignFirstResponder()
        return true
    }
}
