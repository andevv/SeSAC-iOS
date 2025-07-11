//
//  SettingTableViewController.swift
//  SeSAC0708Homework
//
//  Created by andev on 7/9/25.
//

import UIKit

class SettingTableViewController: UITableViewController {

    //섹션별 목록
    let allSettingList = ["공지사항", "실험실", "버전 정보"]
    let personalSettingList = ["개인/보안", "알림", "채팅", "멀티프로필"]
    let etcSettingList = ["고객센터/도움말"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "설정"
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.boldSystemFont(ofSize: 18)
        ]
        
        // 네비게이션 바 배경
        navigationController?.navigationBar.barTintColor = .black

        // 네비게이션 바 전체 영역
        navigationController?.view.backgroundColor = .black

        // 현재 뷰의 배경색
        view.backgroundColor = .black

        //셀 구분선 색
        tableView.separatorColor = .darkGray
    }
    
    //섹션 개수
    override func numberOfSections(in tableView: UITableView) -> Int {
        print(#function)
        return 3
    }

    //셀 개수 (numberOfRowsInSection)
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(#function)
        
        switch section {
        case 0: return allSettingList.count
        case 1: return personalSettingList.count
        case 2: return etcSettingList.count
        default: return 0
        }
    }
    
    //셀 디자인 및 데이터 처리 (cellForRowAt)
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingCell", for: indexPath) //복붙할 셀 설정
        
        switch indexPath.section {
        case 0:
            cell.textLabel?.text = allSettingList[indexPath.row]
        case 1:
            cell.textLabel?.text = personalSettingList[indexPath.row]
        case 2:
            cell.textLabel?.text = etcSettingList[indexPath.row]
        default:
            break
        }
        
        // 셀 스타일 커스터마이징
        cell.backgroundColor = .black
        cell.textLabel?.textColor = .white
        cell.textLabel?.font = UIFont.systemFont(ofSize: 12)

        return cell
    }
    
    //섹션 헤더 타이틀 설정
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
            case 0: return "전체 설정"
            case 1: return "개인 설정"
            case 2: return "기타"
            default: return nil
        }
    }
    
    //셀 높이 (heightForRowAt)
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        print(#function)
        return 44
    }
    
    //섹션 스타일 커스터마이징
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let header = view as? UITableViewHeaderFooterView {
            header.textLabel?.textColor = .lightGray
            header.textLabel?.font = UIFont.boldSystemFont(ofSize: 14)
            header.contentView.backgroundColor = UIColor.black
        }
    }
}
