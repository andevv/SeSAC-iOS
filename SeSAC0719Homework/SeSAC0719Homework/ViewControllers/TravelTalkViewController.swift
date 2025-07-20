//
//  TravelTalkViewController.swift
//  SeSAC0719Homework
//
//  Created by andev on 7/19/25.
//

import UIKit

class TravelTalkViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet var mySearchBar: UISearchBar!
    @IBOutlet var myCollectionView: UICollectionView!
    
    // MARK: - Properties
    var chatRooms = ChatList.list
    var filteredRooms: [ChatRoom] = []
    
    enum Identifier {
        static let TravelTalkCollectionViewCell = "TravelTalkCollectionViewCell"
        static let ChatViewController = "ChatViewController"
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "TRAVEL TALK"
        filteredRooms = chatRooms
        
        configureCollectionView()
        configureSearchBar()
    }
    
    // MARK: - Configuration
    private func configureCollectionView() {
        myCollectionView.dataSource = self
        myCollectionView.delegate = self
        
        let nib = UINib(nibName: Identifier.TravelTalkCollectionViewCell, bundle: nil)
        myCollectionView.register(nib, forCellWithReuseIdentifier: Identifier.TravelTalkCollectionViewCell)
    }
    
    private func configureSearchBar() {
        mySearchBar.delegate = self
        mySearchBar.placeholder = "친구 이름을 검색해보세요"
    }
}

// MARK: - CollectionView DataSource, Delegate
extension TravelTalkViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredRooms.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = myCollectionView.dequeueReusableCell(withReuseIdentifier: Identifier.TravelTalkCollectionViewCell, for: indexPath) as! TravelTalkCollectionViewCell
        
        let room = filteredRooms[indexPath.item]
        cell.configure(with: room)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: Identifier.ChatViewController) as! ChatViewController
        vc.chatRoom = filteredRooms[indexPath.item]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = myCollectionView.bounds.width
        return CGSize(width: width, height: 80)
    }
}

// MARK: - SearchBar
extension TravelTalkViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.trimmingCharacters(in: .whitespaces).isEmpty {
            filteredRooms = chatRooms
        } else {
            filteredRooms = chatRooms.filter { $0.chatroomName.lowercased().contains(searchText.lowercased()) }
        }
        myCollectionView.reloadData()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
