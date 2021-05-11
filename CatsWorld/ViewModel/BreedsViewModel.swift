//
//  BreedsViewModel.swift
//  CatsWorld
//
//  Created by Nikita Semenov on 05.05.2021.
//

import Foundation

final class BreedsViewModel: ObservableObject {
	
	static let defaultEndPoint = EndPoint.breedsAPI([.attachBreed])
		
	@Published var breeds: [Breed] = MockData.breeds
	
	init() {
		makeNetworkRequest()
	}
	
	/// Starts making `URLRequest`
	private func makeNetworkRequest() {
		let url = makeURL(endPoint: BreedsViewModel.defaultEndPoint)
		
		NetworkRequester.makeRequest(
			url: url!,
			headers: ["x-api-key": "9fa4592a-db90-46af-93d7-68743bbd52db"],
			completion: parseJSON(data:error:)
		)
	}
	
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
	private func parseJSON(data: Data?, error: Error?) -> Void {
		if let data = data {
			do{
				try JSONParser.parse(from: data, completion: addBreeds(breeds:))
			} catch {
				print(error)
			}
		}
		// TODO: - Error handling
	}
	
	/// Adds breeds from the array and removes all mock data
	/// - Parameter breeds: Array of `Breed` which should be added
	private func addBreeds(breeds: [Breed]) -> Void {
		DispatchQueue.main.async { [self] in
			removeMockData()
			
			for breed in breeds {
				self.breeds.append(breed)
			}
		}
	}
	
	/// Removes mock data from the `breeds` array
	private func removeMockData() {
		breeds.removeAllOccurances(MockData.breeds[0])
	}
}
