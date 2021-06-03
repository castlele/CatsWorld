//
//  PersistenceController.swift
//  CatsWorld
//
//  Created by Nikita Semenov on 13.05.2021.
//

import CoreData

struct PersistenceController {
	
	static let shared = PersistenceController()
	
	/// Used for injecting as `environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)` in previews
	/// Complexity -  O(10)
	static var preview: PersistenceController = {
		let result = PersistenceController(inMemory: true)
		let viewContext = result.conteiner.viewContext
		
		for _ in 0..<10 {
			let newCat = CatsCard(context: viewContext)
			newCat.name = "Example cat"
		}
		
		do {
			try viewContext.save()
		} catch {
			let nsError = error as NSError
			fatalError("Error: \(nsError), \(nsError.userInfo)")
		}
		
		return result
	}()
	
	let conteiner: NSPersistentContainer
	
	init(inMemory: Bool = false) {
		conteiner = NSPersistentContainer(name: "Stash")
		
		if inMemory {
			conteiner.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
		}
		
		conteiner.loadPersistentStores { description, error in
			if let error = error {
				fatalError("Error: Cant load Data Model\nError description: \(error.localizedDescription)")
			}
		}
	}
	
	/// Saves  changes
	/// - Parameter completion: Error handling function
	func save(completion: @escaping (Error?) -> Void = {_ in}) {
		let context = conteiner.viewContext
		
		if context.hasChanges {
			do {
				try context.save()
				completion(nil)
			} catch {
				completion(error)
			}
		}
	}
	
	/// Delets certain object from data base
	/// - Parameters:
	///   - object: Object which should me removed from data base
	///   - completion: Error handling function
	func delete(_ object: NSManagedObject, completion: @escaping (Error?) -> Void = {_ in}) {
		let context = conteiner.viewContext
		context.delete(object)
		save(completion: completion)
	}
}
