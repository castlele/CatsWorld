//
//  CatsWorldApp.swift
//  CatsWorld
//
//  Created by Nikita Semenov on 05.05.2021.
//

import SwiftUI

@main
struct CatsWorldApp: App {
	
	let persistenceController = PersistenceController.shared
	
	@Environment(\.scenePhase) var scenePhase
			
	init() {
		UITextView.appearance().backgroundColor = .clear
		
		UITableView.appearance().backgroundColor = Color.mainUIColor()
		
		UISegmentedControl.appearance().selectedSegmentTintColor = Color.accentUIColor()
		UISegmentedControl.appearance().setTitleTextAttributes(
			[.foregroundColor:	UIColor.white],
			for: .selected)
	}
	
    var body: some Scene {
        WindowGroup {
			TabBarView()
				.environment(\.managedObjectContext, persistenceController.conteiner.viewContext)
		}
		.onChange(of: scenePhase) { newScenePhase in
			savePersistenceInBackgroundState(newScenePhase)
		}
	}
	
	private func savePersistenceInBackgroundState(_ scenePhase: ScenePhase) {
		switch scenePhase {
			case .background:
				persistenceController.save()
			default:
				break
		}
	}
}
