//
//  Gloabal.swift
//  CatsWorld
//
//  Created by Nikita Semenov on 20.07.2021.
//

import SwiftUI

func makeMediumHaptics() {
	let impactMedium = UIImpactFeedbackGenerator(style: .medium)
	impactMedium.impactOccurred()
}

struct MenuWidth: EnvironmentKey {
	static var defaultValue: CGFloat = UIScreen.screenWidth / 1.2
}
