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
			breedsViewModel.wrappedImage
				.resizable()
				.scaledToFit()
				.background(Color.mainColor)
				.cornerRadius(20)
				.background(
					RoundedRectangle(cornerRadius: 20)
						.stroke(Color.accentColor, lineWidth: 4)
				)
				.frame(height: 200)
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
    }
}

struct BreedsDetailView_Previews: PreviewProvider {
    static var previews: some View {
		BreedsDetailView(breed: MockData.sampleBreed)
    }
}
