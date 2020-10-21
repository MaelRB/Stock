//
//  SearchLogic.swift
//  Stock
//
//  Created by Mael Romanin Bluteau on 21/10/2020.
//

import Foundation

class SearchLogic: ObservableObject {
    
    @Published var userQuery = "" {
        didSet {
            fetchUserQuery()
        }
    }
    
    @Published var searchSymbolList = [SearchSymbol]()
    
    func resetValue() {
        userQuery = ""
        searchSymbolList = []
    }
    
    private var searchService = SearchService()
    
    private func fetchUserQuery() {
        searchService.fetch(for: ["query": userQuery, "limit": 5, "apikey": FMPtoken]) { (result, error) in
            DispatchQueue.main.async {
                self.manageResult(result, error: error)
            }
        }
    }
    
    private func manageResult(_ result: [SearchSymbol]?, error: Error?) {
        if error != nil {
            print(error!)
        } else {
            guard let safeResult = result else { return }
            self.searchSymbolList = safeResult
        }
    }
}
