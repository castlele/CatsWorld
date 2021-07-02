//
//  TabBarView.swift
//  CatsWorld
//
//  Created by Nikita Semenov on 02.07.2021.
//

import SwiftUI

struct TabBarView: View {
	
	@State var selectedTab = 1
	
    var body: some View {
		TabView {
			MapTabView()
				.tabItem {
					Image(systemName: "map")
					Text("Map")
				}
				.navigationBarHidden(true)
				.tag(0)
			
			HomeScreenView()
				.tabItem {
					Image(systemName: "house")
					Text("Home")
				}
				.navigationBarHidden(true)
				.tag(1)
			
			BreedsList()
				.environmentObject(BreedsViewModel.shared)
				.tabItem {
					Image(systemName: "list.bullet")
					Text("Breeds")
				}
				.navigationBarHidden(true)
				.tag(2)
			
			SettingsView()
				.tabItem {
					Image(systemName: "gearshape")
					Text("Settings")
				}
				.navigationBarHidden(true)
				.tag(3)
		}
		.accentColor(.accentColor)
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}
