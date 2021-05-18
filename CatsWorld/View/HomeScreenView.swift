//
//  HomeScreenView.swift
//  CatsWorld
//
//  Created by Nikita Semenov on 11.05.2021.
//

import SwiftUI

struct HomeScreenView: View {
	
	@Environment(\.managedObjectContext) var persistenceController
	
	@FetchRequest(
		entity: CatsCard.entity(),
		sortDescriptors: [NSSortDescriptor(keyPath: \CatsCard.name, ascending: true)]
	) var catsCards: FetchedResults<CatsCard>
	
    var body: some View {
		NavigationView {
			VStack {
				Button(action: {
					let cat = CatsCard(context: persistenceController)
					cat.name = "Lulu"
//					cat.age = 5
					cat.breed = "Unicorn"
					cat.id = UUID()
					cat.sex = "M"
					let color = UIColor.orange
					cat.color = color.encode()
					PersistenceController.shared.save()
				}, label: {
					Text("Add")
				})
				.frame(width: 200, height: 100)
				.padding()
				
				Button(action: {
					catsCards.forEach { card in
						PersistenceController.shared.delete(card)
					}
				}, label: {
					Text("Delete all")
				})
				.frame(width: 200, height: 100)
				.padding()
				
				GeometryReader { geometry in
					ScrollView {
						VStack(spacing: 10) {
							ForEach(catsCards, id: \.id) { card in
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
		}
    }
}

struct HomeScreenView_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreenView()
    }
}
