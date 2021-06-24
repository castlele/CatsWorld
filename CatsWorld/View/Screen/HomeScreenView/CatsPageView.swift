//
//  CatPageView.swift
//  CatsWorld
//
//  Created by Nikita Semenov on 17.05.2021.
//

import SwiftUI

struct CatsPageView: View {
	
	@Environment(\.managedObjectContext) var managedObjectContext
	
	@ObservedObject var cat: CatsCard
	
	@State var deleteAfterCancelation = false
	@State var isEditing = false
	
    var body: some View {
		if isEditing {
			EditingCatsPageView(catsViewModel: CatsCardsPageViewModel(cat: cat, deleteAfterCancelation: deleteAfterCancelation, managedObjectContext: managedObjectContext))
		} else {
			MainCatsPageView(catsDescriptionViewModel: CatsDescriptionViewModel(cat: cat))
		}
    }
}

struct CatsPageView_Previews: PreviewProvider {
    static var previews: some View {
		CatsPageView(cat: CatsCard(context: PersistenceController.preview.conteiner.viewContext))
    }
}
