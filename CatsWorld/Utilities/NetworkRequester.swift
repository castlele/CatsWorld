//
//  NetworkRequester.swift
//  CatsWorld
//
//  Created by Nikita Semenov on 05.05.2021.
//

import Foundation

/// Factory class makes network requests
final class NetworkRequester {
	
	static var shared = NetworkRequester()
	
	init() {}
}

// MARK:- Public methods
extension NetworkRequester {
	/// Makes request
	/// - Parameters:
	///   - url: `URL` where request will be done
	///   - headers: Headers of the `URLRequest`
	///   - completion: Action, that will be done after loading data
	func makeRequest(url: URL, headers: [String: String]?, completion: @escaping (Result<Data, CWError>) -> Void) {
		var request: URLRequest
		
		if let headers = headers {
			request = makeRequestObject(url: url, with: headers)
		} else {
			request = makeRequestObject(url: url)
		}
		
		load(request: request, completion: completion)
	}
}

// MARK:- Private methods
extension NetworkRequester {
	/// Loads data
	/// - Parameters:
	///   - request: URL request with which `URLSession` will be done
	///   - completion: Action, that will be done after loading data
	private func load(request: URLRequest, completion: @escaping (Result<Data, CWError>) -> Void) {
		URLSession.shared.dataTask(with: request) { data, _, error in
			if let _ = error {
				completion(.failure(.invalidURLRequest))
			}
			
			if let data = data {
				completion(.success(data))
			}
		}.resume()
	}
	
	/// Make `URLRequest` object from URL
	/// - Parameters:
	///   - url: `URL` from which `URLRequest` will be made
	///   - headers: Headers of the `URLRequest`
	/// - Returns: Initialized object of `URLRequest` struct
	private func makeRequestObject(url: URL, with headers: [String: String]) -> URLRequest {
		let request = NSMutableURLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 15)
		add(headers: headers, for: request)
		return request as URLRequest
	}
	
	private func makeRequestObject(url: URL) -> URLRequest {
		let request = NSMutableURLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 15)
		return request as URLRequest
	}
	
	/// Adds headers to `URLRequest`
	/// - Parameters:
	///   - headers: `Dictionary` of headers
	///   - request: Request for which headers will be added
	private func add(headers: [String: String], for request: NSMutableURLRequest) {
		request.httpMethod = "GET"
		request.allHTTPHeaderFields = headers
	}
}
