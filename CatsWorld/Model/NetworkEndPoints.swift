//
//  NetworkEndPoints.swift
//  CatsWorld
//
//  Created by Nikita Semenov on 11.05.2021.
//

import Foundation

enum EndPoint {
	
	case breedsAPI([(query: CatAPIQuery, value: String)])
	case imagesAPI([(query: CatAPIQuery, value: String)])
	
	/// Makes URL from with queries
	/// O(n) complexity, where n - amount of queries
	var url: URL? {
		var stringURL = ""
		switch self {
			case let .breedsAPI(queries):
				stringURL = "https://api.thecatapi.com/v1/breeds"
				addQuery(for: &stringURL, queries: queries)
			case let .imagesAPI(queries):
				stringURL = "https://api.thecatapi.com/v1/images/search"
				addQuery(for: &stringURL, queries: queries)
		}
		return URL(string: stringURL)
	}
	
	/// Adds query to string URL from array
	/// - Parameters:
	///   - url: inout URL as string
	///   - queries: array of `CatAPIQuery`
	private func addQuery(for url: inout String, queries: [(query: CatAPIQuery, value: String)]) {
		guard !queries.isEmpty else { return }
		
		url += "?"
		
		for (index, (query, value)) in queries.enumerated() {
			if index > 0 { url += "&" }
			url += query.rawValue + value
		}
	}
}

enum CatAPIQuery: String {
	case breedID = "breed_ids="
	case attachBreed = "attach_breed="
}
