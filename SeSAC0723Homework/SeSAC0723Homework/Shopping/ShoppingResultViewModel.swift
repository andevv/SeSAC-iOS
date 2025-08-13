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

final class ShoppingResultViewModel {

    struct Input {
        let refresh: Observable<Void?>
        let changeSort: Observable<SortType?>
        let loadRecommended: Observable<Void?>
    }

    struct Output {
        let titleText: Observable<String>
        let items: Observable<[ShoppingItem]>
        let totalText: Observable<String>
        let recommended: Observable<[ShoppingItem]>
        let isLoading: Observable<Bool>
        let errorMessage: Observable<String?>
        let selectedSort: Observable<SortType>
    }

    private let query: String

    init(query: String) {
        self.query = query
    }

    func transform(_ input: Input) -> Output {
        let titleText = Observable(query)
        let items = Observable<[ShoppingItem]>([])
        let totalText = Observable<String>("")
        let recommended = Observable<[ShoppingItem]>([])
        let isLoading = Observable<Bool>(false)
        let errorMessage = Observable<String?>(nil)
        let selectedSort = Observable<SortType>(.sim)

        func load(query: String, sort: SortType) {
            guard !isLoading.value else { return }
            isLoading.value = true

            let route = ShopRouter.search(query: query, sort: sort.apiParameter, start: 1, display: 100)
            NetworkManager.shared.request(route, type: ShoppingResponse.self) { result in
                DispatchQueue.main.async {
                    isLoading.value = false
                    switch result {
                    case .success(let res):
                        items.value = res.items
                        totalText.value = "\(res.total.formatted())개의 검색 결과"
                    case .failure:
                        errorMessage.value = "데이터를 불러오지 못했습니다."
                    }
                }
            }
        }

        input.refresh.lazyBind { [weak self] in
            guard let self = self else { return }
            load(query: self.query, sort: selectedSort.value)
        }

        input.changeSort.lazyBind {
            if let s = input.changeSort.value {
                selectedSort.value = s
                load(query: self.query, sort: s)
            }
        }

        input.loadRecommended.lazyBind {
            let route = ShopRouter.recommended
            NetworkManager.shared.request(route, type: ShoppingResponse.self) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let res):
                        recommended.value = res.items
                    case .failure:
                        errorMessage.value = "추천 아이템을 불러오지 못했습니다."
                    }
                }
            }
        }

        return Output(
            titleText: titleText,
            items: items,
            totalText: totalText,
            recommended: recommended,
            isLoading: isLoading,
            errorMessage: errorMessage,
            selectedSort: selectedSort
        )
    }
}
