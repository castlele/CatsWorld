//
//  SettingsView.swift
//  CatsWorld
//
//  Created by Nikita Semenov on 01.07.2021.
//

import SwiftUI

fileprivate struct UserView: View {
	
	let offset: CGFloat
	
	var body: some View {
		HStack {
			VStack(alignment: .leading, spacing: 5) {
				Text("Nikito")
					.font(.system(.title, design: .rounded))
				
				Text("castlelecs@gmail.com")
					.font(.system(.subheadline, design: .serif))
					.foregroundColor(.gray)
			}
			
			Spacer()
		}
		.padding()
		.padding(.top, offset)
		.background(
			Rectangle()
				.fill(Color.mainColor)
		)
		.frame(minHeight: UIApplication.safeAreaInsetsTop)
	}
}

struct SettingsView: View {
	
	private let yOffset = 0 - (UIApplication.safeAreaInsetsTop ?? 0)
	
	@EnvironmentObject var settingsViewModel: SettingsViewModel
	
    var body: some View {
		ScrollView(showsIndicators: false) {
			LazyVStack(pinnedViews: [.sectionHeaders]) {
				GeometryReader { geometry -> AnyView in
					let _offset = geometry.frame(in: .global).minY
					
					if -_offset >= 0 {
						DispatchQueue.main.async {
							settingsViewModel.offset = _offset
						}
					}
					
					return AnyView(
						MutableCornerAvatar(avatar: Image("wolf"), isStroke: false, cornerRadius: .constant(0))
							.frame(width: UIScreen.screenWidth, height: 250)
							.offset(y: yOffset)
							.scaleEffect(_offset > 100 ? _offset <= 150 ? _offset / 100 : 1.5 : 1)
							.animation(.linear)
							.ignoresSafeArea()
					)
				}
				.frame(height: 250)
				
				Section(header: UserView(offset: -yOffset).volumetricShadows(color1: .clear, radius: 7).offset(y: yOffset)) {
					Group {
						CatsDescriptionSection {
							Text("Starter screen")
							
							Picker("", selection: $settingsViewModel.starterScreen) {
								Text("Map").tag(0)
								Text("Home").tag(1)
								Text("Breeds").tag(2)
							}
							.pickerStyle(SegmentedPickerStyle())
						}
						.volumetricShadows()
						.sectionPadding()
						.padding(.top)
						
						CatsDescriptionSection {
							Text("Color scheme")
							
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
						.sectionPadding()
						
						CatsDescriptionSection {
							Text("Graphics")
							
							HStack {
								Text("Shadows")
									.allowsTightening(true)
								
								Button(action: {
									settingsViewModel.showShadowsInfo()
									
								}, label: {
									Image(systemName: "info.circle")
										.foregroundColor(.accentColor)
								})
								
								Picker("", selection: $settingsViewModel.shadows) {
									Text("Default").tag(0)
									Text("Flat").tag(1)
									Text("Disabled").tag(2)
								}
								.pickerStyle(SegmentedPickerStyle())
							}
						}
						.volumetricShadows()
						.sectionPadding()
					}
					.offset(y: yOffset)
				}
			}
		}
		.overlay(
			Color.mainColor
				.frame(height: UIApplication.safeAreaInsetsTop)
				.ignoresSafeArea()
				.opacity(-settingsViewModel.offset > 230 + yOffset ? 1 : 0)

			,alignment: .top
		)
		.alert(isPresented: $settingsViewModel.isShadowInfo) {
			settingsViewModel.alert
		}
		.background(Color.mainColor.ignoresSafeArea())
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
		TabView {
			SettingsView()
				.environmentObject(SettingsViewModel.shared)
				.tabItem {
					Image(systemName: "gearshape")
					Text("Settings")
				}
		}
    }
}
