//
//  NetworkRequester.swift
//  CatsWorld
//
//  Created by Nikita Semenov on 05.05.2021.
//

import Foundation

/// Factory class makes network requests
final class NetworkRequester {
	/// Makes request
	/// - Parameters:
	///   - url: `URL` where request will be done
	///   - headers: Headers of the `URLRequest`
	///   - completion: Action, that will be done after loading data
	static func makeRequest(url: URL, headers: [String: String], completion: @escaping (Data?, Error?) -> Void) {
		let request = makeRequestObject(url: url, with: headers)
		load(request: request, completion: completion)
	}
	
	/// Loads data
	/// - Parameters:
	///   - request: URL request with which `URLSession` will be done
	///   - completion: Action, that will be done after loading data
	private static func load(request: URLRequest, completion: @escaping (Data?, Error?) -> Void) {
		URLSession.shared.dataTask(with: request) { data, _, error in
			completion(data, error)
		}.resume()
	}
	
	/// Make `URLRequest` object from URL
	/// - Parameters:
	///   - url: `URL` from which `URLRequest` will be made
	///   - headers: Headers of the `URLRequest`
	/// - Returns: Initialized object of `URLRequest` struct
	private static func makeRequestObject(url: URL, with headers: [String: String]) -> URLRequest {
		let request = NSMutableURLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 15)
		add(headers: headers, for: request)
		return request as URLRequest
	}
	
	/// Adds headers to `URLRequest`
	/// - Parameters:
	///   - headers: `Dictionary` of headers
	///   - request: Request for which headers will be added
	private static func add(headers: [String: String], for request: NSMutableURLRequest) {
		request.httpMethod = "GET"
		request.allHTTPHeaderFields = headers
	}
}
