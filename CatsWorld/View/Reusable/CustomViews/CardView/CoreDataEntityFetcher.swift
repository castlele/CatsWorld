//
//  CoreDataEntityFetcher.swift
//  CatsWorld
//
//  Created by Nikita Semenov on 17.07.2021.
//

import SwiftUI
import CoreData

struct CoreDataEntityFetcher<Object: NSManagedObject & Identifiable, Content: View>: View {
	
	var fetchedRequest: FetchRequest<Object>
	var entities: FetchedResults<Object>  { fetchedRequest.wrappedValue }
	var filter: (Object) -> Bool
	
	var content: (Object) -> Content
	
    var body: some View {
		VStack {
			ForEach(entities.filter { filter($0) }) { entity in
				content(entity)
			}
		}
    }
	
	init(sortingDescriptor: NSSortDescriptor, filter: @escaping (Object) -> Bool, @ViewBuilder content: @escaping (Object) -> Content) {
		self.fetchedRequest = FetchRequest<Object>(entity: Object.entity(), sortDescriptors: [sortingDescriptor])
		self.content = content
		self.filter = filter
	}
}
