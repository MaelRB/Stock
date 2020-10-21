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
    
    init() {
        
    }
    
    private func fetchUserQuery() {
        SearchService().fetch(for: ["query": userQuery, "limit": 5]) { (_) in
            
        }
    }
}
