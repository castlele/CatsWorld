//
//  TabBarView.swift
//  CatsWorld
//
//  Created by Nikita Semenov on 02.07.2021.
//

import SwiftUI

struct TabBarView: View {
	
	@Environment(\.colorScheme) var colorScheme
	
	@StateObject var settingsViewModel = SettingsViewModel()
	
	@State var selectedTab = 1
	
	init() {
		BreedsViewModel.shared.loadBreeds()
	}
	
    var body: some View {
		TabView(selection: $selectedTab) {
			MapTabView()
				.environmentObject(settingsViewModel)
				.tabItem {
					Image(systemName: "map")
					Text("Map")
				}
				.tag(0)
			NavigationView {
				HomeScreenView()
					.environmentObject(settingsViewModel)
					.navigationBarHidden(true)
			}
			.tag(1)
			.tabItem {
				Image(systemName: "house")
				Text("Home")
			}
			
			NavigationView {
				BreedsList()
					.environmentObject(BreedsViewModel.shared)
					.environmentObject(settingsViewModel)
					.navigationBarHidden(true)
					.accentColor(.accentColor)
			}
			.tag(2)
			.tabItem {
				Image(systemName: "list.bullet")
				Text("Breeds")
			}
			
			SettingsView()
				.environmentObject(settingsViewModel)
				.tabItem {
					Image(systemName: "gearshape")
					Text("Settings")
				}
				.tag(3)
		}
		.preferredColorScheme(settingsViewModel.wrappedColorScheme)
		.onAppear {
			UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).tintColor = colorScheme == .dark ? Color.darkAccentUIColor() : Color.lightAccentUIColor()
		}
		.onChange(of: colorScheme) { newScheme in
			UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).tintColor = newScheme == .dark ? Color.darkAccentUIColor() : Color.lightAccentUIColor()
		}
		.accentColor(.accentColor)
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}
