//
//  ContentView.swift
//  CatsWorld
//
//  Created by Nikita Semenov on 05.05.2021.
//

import SwiftUI

struct BreedsList: View {
	
	@EnvironmentObject var viewModel: BreedsViewModel
	
    var body: some View {
		List(viewModel.breeds) { breed in
			Text(breed.name)
		}
		.onAppear {
			DispatchQueue.main.async {
				viewModel.loadBreeds()
			}
		}
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        BreedsList()
    }
}
