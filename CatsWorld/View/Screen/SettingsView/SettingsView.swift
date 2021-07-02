//
//  SettingsView.swift
//  CatsWorld
//
//  Created by Nikita Semenov on 01.07.2021.
//

import SwiftUI

struct SettingsView: View {
	
	@EnvironmentObject var settingsViewModel: SettingsViewModel
	
    var body: some View {
		ZStack {
			Color.mainColor
			
			VStack {
				TopBarView(minHeight: 60, maxHeight: 60)
				
				ScrollView(showsIndicators: false) {
					CatsDescriptionSection {
						Toggle("Match System Mode", isOn: $settingsViewModel.isSystemModeColorScheme)
							.toggleStyle(SwitchToggleStyle(tint: .accentColor))
						
						if !settingsViewModel.isSystemModeColorScheme {
							Picker("Color scheme", selection: $settingsViewModel.colorScheme) {
								Text("Light").tag(1)
								Text("Dark").tag(2)
							}
							.pickerStyle(SegmentedPickerStyle())
						}
					}
					.volumetricShadows()
					.padding(.top)
					
					CatsDescriptionSection {
						Text("Graphics")
						
						HStack {
							Text("Shadows")
							
							Picker("", selection: $settingsViewModel.shadows) {
								Text("Default").tag(0)
								Text("Flat").tag(1)
								Text("Disabled").tag(2)
							}
							.pickerStyle(SegmentedPickerStyle())
						}
					}
					.volumetricShadows()
					.padding(.top)
				}
			}
		}
		.ignoresSafeArea()
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}