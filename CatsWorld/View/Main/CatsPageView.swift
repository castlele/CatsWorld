//
//  CatPageView.swift
//  CatsWorld
//
//  Created by Nikita Semenov on 17.05.2021.
//

import SwiftUI

struct CatsPageView: View {
	
	@State var isEditing = true
	
	var cat: CatsCard
	
    var body: some View {
		NavigationView {
			ZStack {
				if isEditing {
					EditingCatsPageView()
				} else {
					MainCatsPageView(cat: cat)
				}
			}
			.navigationBarItems(trailing: EditButton(isEditing: $isEditing))
		}
    }
}

struct MainCatsPageView: View {
	
	var cat: CatsCard
	
	var body: some View {
		VStack {
			CatsMainInfoView(cat: cat)
			
			Form {
				Section {
					Text("Hello")
				}
			}
		}
	}
}

struct CatsPageView_Previews: PreviewProvider {
    static var previews: some View {
		CatsPageView(cat: CatsCard(context: PersistenceController.shared.conteiner.viewContext))
    }
}
