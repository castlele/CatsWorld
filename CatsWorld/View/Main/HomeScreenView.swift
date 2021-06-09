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
		VStack {
			HStack {
				#if DEBUG
				Button(action: {
					for cat in catsCards {
						managedObjectContext.delete(cat)
						try! managedObjectContext.save()
					}
					
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
				#endif
				
				Spacer()
				
				Button(action: {
					let cat = CatsCard(context: managedObjectContext)
					editingView = EditingCatsPageView(cat: cat, breedsViewModel: breedsViewModel)
					addCatSheet.toggle()
					
				}, label: {
					Image(systemName: "plus")
						.resizable()
						.accentColor(.gray)
						.padding()
				})
				.background(Color.white)
				.frame(width: 60, height: 60)
				.clipShape(Circle())
				.volumetricShadows()
				.padding()
			}
			
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
		.sheet(isPresented: $addCatSheet) {
			editingView
		}
		.navigationBarHidden(true)
		.onAppear {
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

struct HomeScreenView_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreenView()
			.environment(\.managedObjectContext, PersistenceController.preview.conteiner.viewContext)
    }
}
