//
//  BreedsDetailView.swift
//  CatsWorld
//
//  Created by Nikita Semenov on 01.07.2021.
//

import SwiftUI

struct BreedsDetailView: View {
		
	let breed: Breed
	
    var body: some View {
		ScrollView {
			CatsAvatar(avatar: UIImage(systemName: "person.crop.circle.fill")!)
				.frame(width: 150, height: 150)
				.background(EarsView())
				.padding([.top, .bottom])
			
			Group {
				CatsDescriptionSection {
					Text(breed.name)
					
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
    }
}

// MARK: - Equatable conformance
extension BreedsDetailView: Equatable {
	static func == (lhs: Self, rhs: Self) -> Bool {
		lhs.breed == rhs.breed
	}
}

struct BreedsDetailView_Previews: PreviewProvider {
    static var previews: some View {
		BreedsDetailView(breed: MockData.sampleBreed)
    }
}
