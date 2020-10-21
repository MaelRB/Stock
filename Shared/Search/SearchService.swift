//
//  SearchService.swift
//  Stock
//
//  Created by Mael Romanin Bluteau on 21/10/2020.
//

import Foundation

class SearchService {
    
    private let client = WebClient(url: "https://financialmodelingprep.com/api/v3/search", token: "ad8e404ddeec4cd7f3a1130bdf833e21")
    
    func fetch(for params: Param, completion: @escaping (String) -> ()) {
        
    }
}
