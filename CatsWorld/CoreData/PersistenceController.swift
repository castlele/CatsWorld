//
//  PersistenceController.swift
//  CatsWorld
//
//  Created by Nikita Semenov on 13.05.2021.
//

import CoreData

struct PersistenceController {
	
	static let shared = PersistenceController()
	
	let conteiner: NSPersistentContainer
	
	init() {
		conteiner = NSPersistentContainer(name: "Stash")
		conteiner.loadPersistentStores { (description, error) in
			if let error = error {
				fatalError("Error: Cant load Data Model\nError description: \(error.localizedDescription)")
			}
		}
	}
	
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
	
	func delete(_ object: NSManagedObject, completion: @escaping (Error?) -> Void = {_ in}) {
		let context = conteiner.viewContext
		context.delete(object)
		save(completion: completion)
	}
}
