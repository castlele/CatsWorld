//
//  CatPageView.swift
//  CatsWorld
//
//  Created by Nikita Semenov on 17.05.2021.
//

import SwiftUI

struct CatsPageView: View {
	
	@Environment(\.presentationMode) var presentationMode
	
	@ObservedObject var cat: CatsCard
	@State var isEditing = false
	
	var breedsViewModel: BreedsViewModel
	var backGroundColor: Color
	
    var body: some View {
		ZStack {
			backGroundColor.opacity(0.5)
			
			VStack {
				HStack {
					CancelButton(presentation: presentationMode)
					Spacer()
				}
				
				Spacer()
				
				if isEditing {
					EditingCatsPageView(cat: cat, breedsViewModel: breedsViewModel)
				} else {
					MainCatsPageView(cat: cat)
				}
			}
			
			
		}
    }
}

struct MainCatsPageView: View {
	
	var cat: CatsCard
	
	var body: some View {
		VStack {
			CatsMainInfoView(cat: cat)
		}
	}
}

struct CatsPageView_Previews: PreviewProvider {
    static var previews: some View {
		CatsPageView(cat: CatsCard(context: PersistenceController.preview.conteiner.viewContext), breedsViewModel: BreedsViewModel.shared, backGroundColor: .clear)
    }
}
