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
	
	var content: (Object) -> Content
	
    var body: some View {
		VStack {
			ForEach(entities) { entity in
				content(entity)
			}
		}
    }
	
	init(sortingDescriptor: NSSortDescriptor, @ViewBuilder content: @escaping (Object) -> Content) {
		self.fetchedRequest = FetchRequest<Object>(entity: Object.entity(), sortDescriptors: [sortingDescriptor])
		self.content = content
	}
}
