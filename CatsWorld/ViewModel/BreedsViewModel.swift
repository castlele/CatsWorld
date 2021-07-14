//
//  BreedsViewModel.swift
//  CatsWorld
//
//  Created by Nikita Semenov on 05.05.2021.
//

import SwiftUI

final class BreedsViewModel: ObservableObject {
	
	private let defaultHeader = ["x-api-key": "9fa4592a-db90-46af-93d7-68743bbd52db"]
	private var fetchingImageForBreedID = ""
	
	static let shared = BreedsViewModel()
	static let breedsEndPoint = EndPoint.breedsAPI([(.attachBreed, "0")])
	
	static var defaultBreed: Breed {
		shared.breeds[0]
	}
		
	lazy var breeds: [Breed] = {
		MockData.breeds
	}()
	
	@Published var favBreeds: [String: Bool] = UserDefaults.standard.dictionary(forKey: "favBreeds") as? [String: Bool] ?? [:]
		
	@Published var textToSearch = ""
	@Published var isLoadingBreeds = false
	@Published var isLoadingImage = false
	@Published var currentImage: Image! = nil
	@Published var isToggledAddToFavourite = false
		
	var wrappedImage: Image {
		if currentImage != nil {
			return currentImage
		}
		return Image(systemName: "person.crop.circle.fill")
	}
}

// MARK:- Public methods
extension BreedsViewModel {
	/// Starts making `URLRequest` and loads breeds
	func loadBreeds() {
		isLoadingBreeds = true
		
		let url = makeURL(endPoint: BreedsViewModel.breedsEndPoint)
		
		NetworkRequester.shared.makeRequest(
			url: url!,
			headers: defaultHeader,
			completion: parseJSON(result:)
		)
	}
	
	func loadImage(forBreed breed: Breed) {
		isLoadingImage = true
		fetchingImageForBreedID = breed.id
		
		let url = makeURL(endPoint: EndPoint.imagesAPI([(.breedID, fetchingImageForBreedID)]))
		
		NetworkRequester.shared.makeRequest(
			url: url!,
			headers: defaultHeader,
			completion: parseImageURL(result:)
		)
	}
	
	func validateBreeds(breed: Breed) -> Bool {
		let searchingText = textToSearch.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
		
		return searchingText == "" || breed.name.localize().lowercased().hasPrefix(searchingText) || breed.origin.localize().lowercased().hasPrefix(searchingText)
	}
	
	func makeBreedFavourite(_ breed: Breed, value v: Bool? = nil) {
		let breedID = breed.id
		var value = v
		
		if let isFavourite = favBreeds[breedID] {
			if value == nil {
				value = isFavourite ? false : true
			}
			
			favBreeds[breedID] = value
		} else {
			favBreeds[breedID] = true
		}
		
		UserDefaults.standard.set(favBreeds, forKey: "favBreeds")
	}
	
	func toggleAddToFavouriteAnimation() {
		withAnimation(.linear(duration: 0.3)) {
			isToggledAddToFavourite = true
		}
		
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { [self] in
			withAnimation(.linear(duration: 0.3)) {
				isToggledAddToFavourite = false
			}
		}
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
					
					self.breeds = breeds.sorted(by: { $0.name.localize() < $1.name.localize() } )
					
					isLoadingBreeds = false
										
				default:
					break
			}
		}
	}
	
	/// Removes mock data from the `breeds` array
	private func removeMockData() {
		breeds.removeAllOccurances(MockData.breeds[0])
	}
	
	private func parseImageURL(result: Result<Data, CWError>) -> Void {
		switch result {
			case .success(let data):
				JSONParser.shared.parseWithSerialization(
					from: data,
					argument: "url",
					completion: getDataFromImageURL(result:)
				)
			default:
				break
		}
	}
	
	private func getDataFromImageURL(result: Result<Any, CWError>) -> Void {
		switch result {
			case .success(let data):
				guard let stringURL = data as? String else { break }
				guard let url = URL(string: stringURL) else { break }
				loadImageFromImageURL(url: url)
				
			default:
				break
		}
	}
	
	private func loadImageFromImageURL(url: URL) {
		NetworkRequester.shared.makeRequest(
			url: url,
			headers: nil,
			completion: convertDataToImage(result:)
		)
	}
	
	private func convertDataToImage(result: Result<Data, CWError>) -> Void {
		DispatchQueue.main.async { [self] in
			switch result {
				case .success(let data):
					guard let uiImage = ImageProcessor.shared.downsampleImage(image: data) else { break }
					
					currentImage = Image(uiImage: uiImage)
					
					isLoadingImage = false
					
				default:
					break
			}
		}
	}
}
