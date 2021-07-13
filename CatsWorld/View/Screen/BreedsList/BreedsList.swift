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
		ZStack {
			Color.mainColor.ignoresSafeArea()
			GeometryReader { geometry in
				VStack {
					SearchBarView(placeholder: "Search placeholder", text: $breedsViewModel.textToSearch)
					
					List {
						ForEach(breedsViewModel.breeds.filter { breedsViewModel.validateBreeds(breed: $0) }) { breed in
							NavigationLink(destination: BreedsDetailView(breed: breed).environmentObject(breedsViewModel)) {
								BreedsRowView(name: breed.name)
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
			}
		}
    }
}

fileprivate struct BreedsRowView: View {
	let name: String
	
	var body: some View {
		HStack {
			Text(name.localize())
				.allowsTightening(true)
			
			Spacer()
			
			Image(systemName: "suit.heart")
		}
	}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        BreedsList()
    }
}
