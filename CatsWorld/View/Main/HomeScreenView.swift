//
//  HomeScreenView.swift
//  CatsWorld
//
//  Created by Nikita Semenov on 11.05.2021.
//

import SwiftUI

struct HomeScreenView: View {
	
	@EnvironmentObject var breedsViewModel: BreedsViewModel
	@Environment(\.managedObjectContext) var managedObjectContext
	
	@FetchRequest(
		entity: CatsCard.entity(),
		sortDescriptors: [],
		predicate: nil,
		animation: .spring()
	) var catsCards: FetchedResults<CatsCard>
	
	@State var addCatSheet = false
	
	@State var editingView: EditingCatsPageView!
	
    var body: some View {
		NavigationView {
			VStack {
				HStack {

					Spacer()

					Button(action: {
						let cat = CatsCard(context: managedObjectContext)
						editingView = EditingCatsPageView(cat: cat, breedsViewModel: breedsViewModel)
						addCatSheet.toggle()

					}, label: {
						Image(systemName: "plus")
							.resizable()
							.accentColor(.green)
							.padding()
					})
					.background(Color.gray)
					.frame(width: 60, height: 60)
					.clipShape(Circle())
					.padding()
				}
				
				Spacer()
				
				GeometryReader { geometry in
					ScrollView {
						VStack(spacing: 10) {
							ForEach(catsCards) { card in
								CatsCardView(cat: card)
									.padding()
									.frame(width: geometry.size.width, height: geometry.size.width / 2)
									.padding([.bottom, .leading, .trailing])
							}
						}
					}
					.frame(width: geometry.size.width, height: geometry.size.height)
				}

			}
			.sheet(isPresented: $addCatSheet) {
				editingView
			}
			.navigationBarHidden(true)
			.onAppear() {
				if managedObjectContext.hasChanges {
					managedObjectContext.refreshAllObjects()
				}
				editingView = nil
				#if DEBUG
				print(catsCards)
				print(catsCards.count)
				#endif
			}
		}
		
    }
}

struct HomeScreenView_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreenView()
			.environment(\.managedObjectContext, PersistenceController.preview.conteiner.viewContext)
    }
}
