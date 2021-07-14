//
//  ContentView.swift
//  CatsWorld
//
//  Created by Nikita Semenov on 05.05.2021.
//

import SwiftUI

fileprivate struct BreedsRowView: View {
	let breed: Breed
	@ObservedObject var viewModel: BreedsViewModel
	
	var body: some View {
		HStack {
			Text(breed.name.localize())
				.allowsTightening(true)
			
			Spacer()
			
			FavouriteBreedView(breed: breed, viewModel: viewModel)
		}
	}
}

struct BreedsList: View {
	
	@EnvironmentObject var breedsViewModel: BreedsViewModel
	
    var body: some View {
		ZStack {
			Color.mainColor.ignoresSafeArea()
			
			VStack {
				SearchBarView(placeholder: "Search placeholder", text: $breedsViewModel.textToSearch)
				
				List {
					ForEach(breedsViewModel.breeds.filter { breedsViewModel.validateBreeds(breed: $0) }) { breed in
						NavigationLink(destination: BreedsDetailView(breed: breed).environmentObject(breedsViewModel)) {
							BreedsRowView(breed: breed, viewModel: breedsViewModel)
						}
					}
					.listRowBackground(Color.mainColor)
				}
				.gesture(
					DragGesture()
						.onChanged { _ in
							UIApplication.shared.endEditing(true)
						}
				)
			}
			
			if breedsViewModel.isLoadingBreeds {
				ZStack {
					Color.mainColor.ignoresSafeArea()
					
					ProgressView()
						.progressViewStyle(CircularProgressViewStyle(tint: .accentColor))
						.scaleEffect(3)
				}
			}
		}
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        BreedsList()
    }
}
