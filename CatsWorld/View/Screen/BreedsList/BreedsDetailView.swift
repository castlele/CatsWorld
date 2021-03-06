//
//  BreedsDetailView.swift
//  CatsWorld
//
//  Created by Nikita Semenov on 01.07.2021.
//

import SwiftUI

struct BreedsDetailView: View {
	
	@EnvironmentObject var breedsViewModel: BreedsViewModel
			
	let breed: Breed
	
    var body: some View {
		ScrollView {
			
			// MARK: - Image View
			breedsViewModel.wrappedImage
				.resizable()
				.scaledToFit()
				.background(Color.mainColor)
				.overlay(
					// MARK: - Loading Image
					ZStack {
						if breedsViewModel.isLoadingImage {
							ZStack {
								Color.mainColor.ignoresSafeArea()
								
								ProgressView()
									.progressViewStyle(CircularProgressViewStyle(tint: .accentColor))
									.scaleEffect(2)
							}
						}
						
						// MARK: - Bottom Black line
						VStack {
							Spacer()
							
							HStack {
								Text("Add to favourite")
									.foregroundColor(.white)
									.padding()
								
								Spacer()
								
								FavouriteBreedView(breed: breed, viewModel: breedsViewModel, fgColor: .white)
							}
							.background(Color.black.opacity(0.4))
						}
						
						// MARK: - Instagram heath
						if breedsViewModel.isToggledAddToFavourite {
							Image(systemName: "heart.fill")
								.resizable()
								.interpolation(.high)
								.frame(width: 40, height: 40)
								.foregroundColor(.white)
							
						} else {
							EmptyView()
						}
					}
				)
				.cornerRadius(20)
				.background(
					RoundedRectangle(cornerRadius: 20)
						.stroke(Color.accentColor, lineWidth: 4)
				)
				.gesture(
					TapGesture(count: 2)
						.onEnded {
							withAnimation(.easeInOut(duration: 0.5)) {
								breedsViewModel.makeBreedFavourite(breed, value: true)
								breedsViewModel.toggleAddToFavouriteAnimation()
							}
						}
				)
				.frame(height: 300)
				.padding()
			
			Spacer()
			
			Group {
				CatsDescriptionSection {
					Text(breed.name.localize())
					
					CatsDescriptionView(descriptions: breed.getDescriptionsFor(category: .psycological))
				}
				
				CatsDescriptionSection {
					CatsDescriptionView(descriptions: breed.getDescriptionsFor(category: .physical))
				}
				
				CatsDescriptionSection {
					CatsDescriptionView(descriptions: breed.getDescriptionsFor(category: .other))
				}
			}
			.volumetricShadows()
			.sectionPadding()
		}
		.background(Color.mainColor.ignoresSafeArea())
		.onAppear {
			breedsViewModel.loadImage(forBreed: breed)
		}
		.onDisappear {
			breedsViewModel.currentImage = nil
		}
    }
}

struct BreedsDetailView_Previews: PreviewProvider {
    static var previews: some View {
		BreedsDetailView(breed: MockData.sampleBreed)
    }
}
