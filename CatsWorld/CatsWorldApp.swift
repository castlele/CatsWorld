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
				TabView(selection: $selectedView) {
					MapTabView()
						.tabItem {
							Image(systemName: "map")
							Text("Map")
						}
						.tag(0)
						.navigationBarHidden(true)
					
					HomeScreenView()
						.environment(\.managedObjectContext, persistenceController.conteiner.viewContext)
						.tabItem {
							Image(systemName: "house")
							Text("Home")
						}
						.tag(1)
						.navigationBarHidden(true)
					
					BreedsList()
						.environmentObject(BreedsViewModel.shared)
						.tabItem {
							Image(systemName: "list.bullet")
							Text("Breeds")
						}
						.tag(2)
						.navigationBarHidden(true)
					
					SettingsView()
						.tabItem {
							Image(systemName: "gearshape")
							Text("Settings")
						}
						.tag(3)
						.navigationBarHidden(true)
				}
				.environmentObject(settingsViewModel)
				.accentColor(.accentColor)
				.preferredColorScheme(settingsViewModel.wrappedColorScheme)
			}
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
