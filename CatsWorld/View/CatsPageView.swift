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

struct EditingCatsPageView: View {
	
	@Environment(\.presentationMode) var presentation
	@Environment(\.managedObjectContext) var persistenceController
	
	var cat: CatsCard = CatsCard(context: PersistenceController.shared.conteiner.viewContext)
	@State var isSheet = false
	@State var wasChanged = false
	
	var body: some View {
		let nameBinding: Binding<String> = Binding(
			get: { return cat.name ?? ""},
			set: {
				cat.name = $0
				
				if cat.name != $0 {
					wasChanged = true
				} else {
					wasChanged = false
				}
			}
		)
		
		if !isSheet {
			return AnyView(VStack {
				CatsAvatar(avatar: cat.wrappedImage)
					.frame(maxWidth: 150, maxHeight: 150)
				
				Form {
					Section {
						TextField("Name", text: nameBinding)
						
//						DatePicker()
						
					}
				}
			})
		} else {
			return AnyView(NavigationView {
				
			})
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
