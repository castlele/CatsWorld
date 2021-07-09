//
//  ContentView.swift
//  CatsWorld
//
//  Created by Nikita Semenov on 05.05.2021.
//

import SwiftUI

struct BreedsList: View {
	
	@EnvironmentObject var breedsViewModel: BreedsViewModel
	
    var body: some View {
		List(breedsViewModel.breeds) { breed in
			NavigationLink(breed.name.localize(), destination: BreedsDetailView(breed: breed).environmentObject(breedsViewModel))
		}
		.background(Color.mainColor)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        BreedsList()
    }
}
