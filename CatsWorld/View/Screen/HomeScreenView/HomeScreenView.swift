//
//  HomeScreenView.swift
//  CatsWorld
//
//  Created by Nikita Semenov on 11.05.2021.
//

import SwiftUI

struct HomeScreenView: View {
	
	@Environment(\.managedObjectContext) var managedObjectContext
	
	@FetchRequest(
		entity: CatsCard.entity(),
		sortDescriptors: [],
		predicate: nil,
		animation: .spring()
	) var catsCards: FetchedResults<CatsCard>
	
	@StateObject var homeScreenViewModel = HomeScreenViewModel()
	
    var body: some View {
		VStack {
			TopBarView(minHeight: 80, maxHeight: 80, trailing: {
				Button(action: {
					let cat = CatsCard(context: managedObjectContext)
					homeScreenViewModel.catsPageView = CatsPageView(cat: cat, deleteAfterCancelation: true, isEditing: true)
					homeScreenViewModel.addCatSheet.toggle()
					
				}, label: {
					Image3D(
						topView: Image(systemName: "plus"),
						bottomView: Image(systemName: "plus"),
						topColor: .volumeEffectColorTop,
						bottomColor: .volumeEffectColorBottom
					)
				})
				.frame(width: 60, height: 60)
				.buttonStyle(CircleButtonStyle())
				.padding()
			})
			
			Spacer()
			
			GeometryReader { geometry in
				ScrollView(.vertical, showsIndicators: false) {
					ForEach(catsCards) { card in
						CatsCardView(cat: card)
							.padding([.leading, .trailing, .top])
						
						Spacer(minLength: 10)
					}
				}
			}
		}
		.background(Color.mainColor)
		.sheet(isPresented: $homeScreenViewModel.addCatSheet) {
			homeScreenViewModel.catsPageView
		}
    }
}

struct HomeScreenView_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreenView()
			.environment(\.managedObjectContext, PersistenceController.preview.conteiner.viewContext)
    }
}
