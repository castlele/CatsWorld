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
		
		UITabBar.appearance().barTintColor = Color.mainUIColor()
		
		UISegmentedControl.appearance().selectedSegmentTintColor = Color.accentUIColor()
		UISegmentedControl.appearance().backgroundColor = Color.semiAccentUIColor()
		UISegmentedControl.appearance().setTitleTextAttributes(
			[.foregroundColor: UIColor(Color.volumeEffectShadowColor)],
			for: .selected)
		UISegmentedControl.appearance().setTitleTextAttributes(
			[.foregroundColor: Color.lightUIColor()],
			for: .disabled)
		
		UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).tintColor = Color.accentUIColor()

		BreedsViewModel.shared.loadBreeds()
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
