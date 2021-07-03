//
//  TabBarView.swift
//  CatsWorld
//
//  Created by Nikita Semenov on 02.07.2021.
//

import SwiftUI

struct TabBarView: View {
	
	@StateObject var settingsViewModel = SettingsViewModel()
	
	@State var selectedTab = 1
	
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
		.accentColor(.accentColor)
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}
