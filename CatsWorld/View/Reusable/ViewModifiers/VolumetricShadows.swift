//
//  VolumetricShadows.swift
//  CatsWorld
//
//  Created by Nikita Semenov on 08.06.2021.
//

import SwiftUI

struct VolumetricShadows: ViewModifier {
	
	var color1: Color
	var color2: Color
	var radius: CGFloat
	
	func body(content: Content) -> some View {
		content
			.shadow(color: color1, radius: radius, x: -5, y: -5)
			.shadow(color: color2, radius: radius, x: 5, y: 5)
	}
}
