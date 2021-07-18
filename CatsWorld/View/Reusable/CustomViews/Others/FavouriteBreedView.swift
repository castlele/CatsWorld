//
//  FavouriteBreedView.swift
//  CatsWorld
//
//  Created by Nikita Semenov on 14.07.2021.
//

import SwiftUI

struct FavouriteBreedView: View {
	
	let breed: Breed
	@ObservedObject var viewModel: BreedsViewModel
	let fgColor: Color
	
	var body: some View {
		Group {
			if viewModel.favBreeds[breed.id] ?? false {
				Image(systemName: "heart.fill")
					.foregroundColor(.red)
					.padding()
			} else {
				Image(systemName: "heart")
					.padding()
					.foregroundColor(fgColor)
			}
		}
		.onTapGesture {
			viewModel.makeBreedFavourite(breed)
		}
	}
}

struct FavouriteBreedView_Previews: PreviewProvider {
    static var previews: some View {
		FavouriteBreedView(breed: MockData.sampleBreed, viewModel: BreedsViewModel.shared, fgColor: .white)
    }
}
