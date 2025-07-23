//
//  BoxOfficeViewController.swift
//  SeSAC0723Homework
//
//  Created by andev on 7/23/25.
//

import UIKit
import SnapKit

class BoxOfficeViewController: UIViewController {
    
    // UI 요소 정의
    private let searchTextField = UITextField()
    private let searchButton = UIButton()
    private let tableView = UITableView()
    
    private var movies: [Movie] = []
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        
        configureUI()
        configureLayout()
        configureTableView()
        
        searchTapped()

    }
    
    private func configureUI() {
        // 텍스트 필드
        searchTextField.borderStyle = .roundedRect
        searchTextField.placeholder = "날짜를 검색하세요"
        searchTextField.textColor = .black
        searchTextField.keyboardType = .numberPad
        view.addSubview(searchTextField)

        // 검색 버튼
        searchButton.setTitle("검색", for: .normal)
        searchButton.setTitleColor(.black, for: .normal)
        searchButton.backgroundColor = .white
        searchButton.layer.cornerRadius = 4
        searchButton.addTarget(self, action: #selector(searchTapped), for: .touchUpInside)
        view.addSubview(searchButton)

        // 테이블뷰
        tableView.backgroundColor = .clear
        view.addSubview(tableView)
    }
    
    // 레이아웃 설정
    private func configureLayout() {
        searchTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalTo(searchButton.snp.leading).offset(-8)
            make.height.equalTo(40)
        }

        searchButton.snp.makeConstraints { make in
            make.centerY.equalTo(searchTextField)
            make.trailing.equalToSuperview().inset(16)
            make.width.equalTo(60)
            make.height.equalTo(40)
        }

        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchTextField.snp.bottom).offset(20)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    // 테이블뷰 설정
    private func configureTableView() {
        tableView.dataSource = self
        tableView.register(BoxOfficeTableViewCell.self, forCellReuseIdentifier: BoxOfficeTableViewCell.identifier)
        tableView.rowHeight = 50
    }

    // 검색 버튼 액션
    @objc private func searchTapped() {
        movies = MovieInfo.movies.shuffled().prefix(10).map { $0 }
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource
extension BoxOfficeViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: BoxOfficeTableViewCell.identifier, for: indexPath) as! BoxOfficeTableViewCell
        
        let movie = movies[indexPath.row]
        cell.configure(rank: indexPath.row + 1, movie: movie)
        return cell
    }
}
