//
//  CatPageView.swift
//  CatsWorld
//
//  Created by Nikita Semenov on 17.05.2021.
//

import SwiftUI

struct CatsPageView: View {
	
	@ObservedObject var cat: CatsCard
	@State var isEditing = false
	
	var breedsViewModel: BreedsViewModel
	
    var body: some View {
		if isEditing {
			EditingCatsPageView(cat: cat, breedsViewModel: breedsViewModel)
		} else {
			MainCatsPageView(cat: cat, catsDescriptionViewModel: CatsDescriptionViewModel(cat: cat))
		}
    }
}

struct CatsPageView_Previews: PreviewProvider {
    static var previews: some View {
		CatsPageView(cat: CatsCard(context: PersistenceController.preview.conteiner.viewContext), breedsViewModel: BreedsViewModel.shared)
    }
}
