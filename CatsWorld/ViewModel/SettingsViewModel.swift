//
//  SettingsViewModel.swift
//  CatsWorld
//
//  Created by Nikita Semenov on 01.07.2021.
//

import SwiftUI

/// View Model of `SettingsView`
final class SettingsViewModel: ObservableObject {
	
	static var shared = SettingsViewModel()
	
	//MARK: - General
	@Published var offset = CGFloat(0)
	
	// MARK: - Starter screen
	@AppStorage("starterScreen") var starterScreen = 0
	
	// MARK: - Color Scheme
	
	/// Represents color scheme as `Int` numbers
	/// - 1: - light color scheme
	/// - 2: - dark color scheme
	@AppStorage("colorScheme") var colorScheme = 1

	@AppStorage("systemColorScheme") var isSystemModeColorScheme = true
	
	var wrappedColorScheme: ColorScheme? {
		if isSystemModeColorScheme {
			return nil
		}
		
		switch colorScheme {
			case 1:
				return .light
			default:
				return .dark
		}
	}
	
	// MARK: - Graphics
	
	var alert: Alert!
	
	@Published var isShadowInfo = false
	
	/// Represents shadow style as `Int` number
	/// - 0: - Default shadows
	/// - 1: - Flat shadows
	/// - 2: - Disabled shadows
	@AppStorage("shadows") var shadows = 0
	
	var wrappedShadows: AppShadow {
		switch shadows {
			case 1:
				return .flat
			case 2:
				return .disabled
			default:
				return .appDefault
		}
	}
}

// MARK:- Public methods
extension SettingsViewModel {
	
	/// Saves everything to `UserDefaults`
	func save() {
		saveColorScheme()
	}
	
	/// Show alert withc infor about why shadows cat be optimized, toggle `isShadowInfo`
	func showShadowsInfo() {
		alert = Alert(title: Text("Shadow optimization"), message: Text("Shadow optimization info"), dismissButton: .cancel(Text("OK")))
		
		isShadowInfo.toggle()
	}
}

// MARK:- Private methods
extension SettingsViewModel {
	
	/// Saves color scheme to `UserDefaults`
	private func saveColorScheme() {
		switch wrappedColorScheme {
			case nil:
				colorScheme = 0
			case .light:
				colorScheme = 1
			case .dark:
				colorScheme = 2
			default:
				colorScheme = 0
		}
	}
}
