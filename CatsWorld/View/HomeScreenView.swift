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
		List {
			ForEach(catsCards, id: \.id) { catsCard in
				VStack {
					Text("\(catsCard.name ?? "")")
					Text("\(catsCard.age)")
					Text("\(catsCard.breed ?? "")")
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
