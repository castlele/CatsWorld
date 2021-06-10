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
	
	@State var catsPageView: CatsPageView!
	
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
					catsPageView = CatsPageView(cat: cat, isEditing: true, breedsViewModel: breedsViewModel)
					addCatSheet.toggle()
					
				}, label: {
					Image3D(
						topView: Image(systemName: "plus"),
						bottomView: Image(systemName: "plus"),
						topColor: Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)),
						bottomColor: .gray
					)
				})
				.frame(width: 60, height: 60)
				.buttonStyle(CircleButtonStyle())
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
			catsPageView
		}
		.navigationBarHidden(true)
		.onAppear {
			if managedObjectContext.hasChanges {
				managedObjectContext.refreshAllObjects()
			}
			catsPageView = nil
			
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
