//
//  ShoppingResultViewModel.swift
//  SeSAC0723Homework
//
//  Created by andev on 8/12/25.
//

import Foundation

enum SortType: String, CaseIterable {
    case sim = "정확도"
    case date = "날짜순"
    case asc = "가격낮은순"
    
    var apiParameter: String {
        switch self {
        case .sim: return "sim"
        case .date: return "date"
        case .asc: return "asc"
        }
    }
}

final class ShoppingResultViewModel<R: ShoppingRepository> {
    // Inputs
    let selectedSort = Observable<SortType>(.sim)
    
    // Outputs
    let titleText: Observable<String>
    let items = Observable<[ShoppingItem]>([])
    let totalText = Observable<String>("")
    let recommended = Observable<[ShoppingItem]>([])
    let isLoading = Observable<Bool>(false)
    let errorMessage = Observable<String?>(nil)
    
    private let repo: R
    private let query: String
    
    init(query: String, repo: R) {
        self.query = query
        self.repo = repo
        self.titleText = Observable(query)
    }
    
    func refresh() {
        load(query: query, sort: selectedSort.value)
    }
    
    func changeSort(_ sort: SortType) {
        selectedSort.value = sort
        load(query: query, sort: sort)
    }
    
    func loadRecommended() {
        repo.fetchRecommended { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let res): self.recommended.value = res.items
                case .failure: self.errorMessage.value = "추천 아이템을 불러오지 못했습니다."
                }
            }
        }
    }
    
    private func load(query: String, sort: SortType) {
        guard !isLoading.value else { return }
        isLoading.value = true
        repo.fetchItems(query: query, sort: sort.apiParameter) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.isLoading.value = false
                switch result {
                case .success(let res):
                    self.items.value = res.items
                    self.totalText.value = "\(res.total.formatted())개의 검색 결과"
                case .failure:
                    self.errorMessage.value = "데이터를 불러오지 못했습니다."
                }
            }
        }
    }
}
