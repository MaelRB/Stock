//
//  SearchLogic.swift
//  Stock
//
//  Created by Mael Romanin Bluteau on 21/10/2020.
//

import Foundation

struct SearchResult: Identifiable {
    let id = UUID()
    let symbolSearch: SearchSymbol
    let marquetInfo: MarketQuote
}

class SearchLogic: ObservableObject {
    
    @Published var userQuery = "" {
        didSet {
            if userQuery.isEmpty == false {
                fetchUserQuery()
            }
        }
    }
    
    @Published var searchResultList = [SearchResult]()
    
    func resetValue() {
        searchResultList.removeAll()
        userQuery = ""
    }
    
    private var searchService = SearchService()
    
    private func fetchUserQuery() {
        searchService.fetch(for: ["query": userQuery, "limit": 5, "apikey": FMPtoken]) { (result, error) in
            DispatchQueue.main.async {
                self.manageResult(result, error: error)
            }
        }
    }
    
    private func manageResult(_ result: [SearchResult]?, error: Error?) {
        if error != nil {
            print(error!)
        } else {
            guard let safeResult = result else { return }
            self.searchResultList = safeResult
        }
    }
    
}
