//
//  SearchHistoryManager.swift
//  UX_WeatherApp
//
//  Created by Dheeraj Pj on 28/11/23.
//

import Foundation

class SearchHistoryManager {
    static let shared = SearchHistoryManager()

    private let userDefaults = UserDefaults.standard
    private let searchHistoryKey = "SearchHistory"

    func addToHistory(searchTerm: String) {
        var searchHistory = userDefaults.stringArray(forKey: searchHistoryKey) ?? []
        
        // Avoid duplicates
        searchHistory = searchHistory.filter { $0 != searchTerm }

        // Add the new search term
        searchHistory.insert(searchTerm, at: 0)

        // Limit the number of items if needed
        let maxItems = 5
        searchHistory = Array(searchHistory.prefix(maxItems))

        // Save the updated history
        userDefaults.set(searchHistory, forKey: searchHistoryKey)
    }

    func getSearchHistory() -> [String] {
        return userDefaults.stringArray(forKey: searchHistoryKey) ?? ["Hyderabad", "Pune"]
    }
}
