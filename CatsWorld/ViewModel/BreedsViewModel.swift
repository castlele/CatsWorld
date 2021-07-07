//
//  BreedsViewModel.swift
//  CatsWorld
//
//  Created by Nikita Semenov on 05.05.2021.
//

import SwiftUI

final class BreedsViewModel: ObservableObject {
	
	private let defaultHeader = ["x-api-key": "9fa4592a-db90-46af-93d7-68743bbd52db"]
	
	static let shared = BreedsViewModel()
	static let breedsEndPoint = EndPoint.breedsAPI([(.attachBreed, "0")])
	
	static var defaultBreed: Breed {
		shared.breeds[0]
	}
		
	lazy var breeds: [Breed] = {
		MockData.breeds
	}()
	
	@Published var images: [String: Image] = [:]
	
	@Published var isLoading = false
}

// MARK:- Public methods
extension BreedsViewModel {
	/// Starts making `URLRequest` and loads breeds
	func loadBreeds() {
		isLoading = true
		
		let url = makeURL(endPoint: BreedsViewModel.breedsEndPoint)
		
		NetworkRequester.shared.makeRequest(
			url: url!,
			headers: defaultHeader,
			completion: parseJSON(result:)
		)
	}
	
	func loadImage(forBreed breed: Breed) {
		let breedID = breed.id
		let endPoint = EndPoint.imagesAPI([(.breedID, breedID)])
		
		let url = makeURL(endPoint: endPoint)
		
		NetworkRequester.shared.makeRequest(
			url: url!,
			headers: defaultHeader,
			completion: loadImage(result:)
		)
	}
}

// MARK:- Private methods
extension BreedsViewModel {
	
	/// Makes `URL`
	/// - Parameter endPoint: Instance of `EndPoint` enumeration
	/// - Returns: Optional `URL` made from `endPoint`
	private func makeURL(endPoint: EndPoint) -> URL? {
		return endPoint.url
		
	}
	
	/// Starts parsing JSON
	/// - Parameters:
	///   - data: Optional `Data` which should be parsed
	///   - error: Optional `Error` which should be handled
	///   Only one parameter can have `nil` value at the same time
	private func parseJSON(result: Result<Data, CWError>) -> Void {
		switch result {
			case .success(let data):
				JSONParser.shared.parse(from: data, completion: addBreeds(result:))
			default:
				break
		}
	}
	
	/// Adds breeds from the array and removes all mock data
	/// - Parameter breeds: Array of `Breed` which should be added
	private func addBreeds(result: Result<[Breed], CWError>) -> Void {
		DispatchQueue.main.async { [self] in
			switch result {
				case .success(let breeds):
					removeMockData()
					
					self.breeds = breeds
					
					isLoading = false
					
				default:
					break
			}
		}
	}
	
	/// Removes mock data from the `breeds` array
	private func removeMockData() {
		breeds.removeAllOccurances(MockData.breeds[0])
	}
	
	private func loadImage(result: Result<Data, CWError>) -> Void {
		
	}
}
