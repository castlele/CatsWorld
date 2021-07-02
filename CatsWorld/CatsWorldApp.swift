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
	
	@StateObject var settingsViewModel = SettingsViewModel()
	
	@State var selectedView = 1
	
	init() {
		UITableViewCell.appearance().backgroundColor = UIColor.clear
		
		UITextView.appearance().backgroundColor = .clear
		
		UITabBar.appearance().barTintColor = Color.mainUIColor()
		UITabBar.appearance().isTranslucent = false
		
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
			NavigationView {
				TabBarView()
					.environment(\.managedObjectContext, persistenceController.conteiner.viewContext)
					.environmentObject(settingsViewModel)
					.preferredColorScheme(settingsViewModel.wrappedColorScheme)
			}
			.accentColor(.accentColor)
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
