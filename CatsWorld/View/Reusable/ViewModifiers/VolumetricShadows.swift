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
	
	var isPressed: Bool
	
	func body(content: Content) -> some View {
		content
			.shadow(color: color1, radius: isPressed ? radius : radius + 3, x: isPressed ? -5 : -10, y: isPressed ? -5 : -10)
			.shadow(color: color2, radius: isPressed ? radius : radius + 3, x: isPressed ? 5 : 10, y: isPressed ? 5 : 10)
	}
}
