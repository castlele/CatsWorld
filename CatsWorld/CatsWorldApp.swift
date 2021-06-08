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
	
	@StateObject private var breedsViewModel = BreedsViewModel.shared
	
	@State var selectedView = 1
	
	init() {
		UITableViewCell.appearance().backgroundColor = UIColor.clear
	}
	
    var body: some Scene {
        WindowGroup {
			TabView(selection: $selectedView) {
				MapView()
					.tabItem {
						Image(systemName: "map")
						Text("Map")
					}
					.tag(0)
				HomeScreenView()
					.environmentObject(breedsViewModel)
					.environment(\.managedObjectContext, persistenceController.conteiner.viewContext)
					.tabItem {
						Image(systemName: "house")
						Text("Home")
					}
					.tag(1)

				BreedsList()
					.environmentObject(breedsViewModel)
					.tabItem {
						Image(systemName: "list.bullet")
						Text("Breeds")
					}
					.tag(2)
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
