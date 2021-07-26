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
			
			FavouriteBreedView(breed: breed, viewModel: viewModel, fgColor: .primary)
		}
	}
}

struct BreedsList: View {
	
	@EnvironmentObject var breedsViewModel: BreedsViewModel
	
    var body: some View {
		ZStack {
			Color.mainColor.ignoresSafeArea()
			
			VStack {
				// MARK: - TopBarView
				TopBarView(
					isVolume: false,
					minHeight: 80,
					maxHeight: 90,
					content: {
						HStack {
							RoundedRectangle(cornerRadius: 20)
								.fill(Color.mainColor)
								.overlay(
									HStack {
										SearchBarView(placeholder: "Search placeholder Breed", text: $breedsViewModel.textToSearch)
											.padding([.top, .bottom, .leading])
										
										Button(action: {
											withAnimation(.easeInOut(duration: 0.5)) {
												breedsViewModel.isShowOnlyFavourites.toggle()
											}
											
										}, label: {
											Image3D(
												topView: breedsViewModel.isShowOnlyFavourites ? Image(systemName: "heart.fill") : Image(systemName: "heart"),
												bottomView: breedsViewModel.isShowOnlyFavourites ? Image(systemName: "heart.fill") : Image(systemName: "heart"),
												topColor: .volumeEffectColorTop,
												bottomColor: .volumeEffectColorBottom,
												isPadding: false
											)
											.equatable()
											.scaleEffect(1.4)
											.aspectRatio(contentMode: .fit)
											
										})
										.padding()
									}
								)
								.frame(height: 50)
								.volumetricShadows()
								.padding()
						}
						.padding(.bottom)
					})
				
				// MARK: - List View
				List {
					ForEach(breedsViewModel.breeds.filter { breedsViewModel.validateBreeds(breed: $0) }) { breed in
						NavigationLink(destination: BreedsDetailView(breed: breed).environmentObject(breedsViewModel)) {
							BreedsRowView(breed: breed, viewModel: breedsViewModel)
						}
					}
					.listRowBackground(Color.mainColor)
				}
				.listStyle(InsetListStyle())
				.overlay(
					VStack {
						if breedsViewModel.breeds.filter { breedsViewModel.validateBreeds(breed: $0) }.isEmpty {
							Text("We didn't find anything")
								.font(.system(.body, design: .rounded))
								.multilineTextAlignment(.center)
								.padding([.leading, .trailing, .top])
								.padding(.top, 30)
						}
						Spacer()
					}
				)
				.gesture(
					DragGesture()
						.onChanged { _ in
							UIApplication.shared.endEditing(true)
						}
				)
			}
			
			// MARK: - Loading View
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
