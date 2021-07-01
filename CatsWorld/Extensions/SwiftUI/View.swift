//
//  View.swift
//  CatsWorld
//
//  Created by Nikita Semenov on 21.05.2021.
//

import SwiftUI

extension View {
	
	/// Adds volume to the view by applying to shadows onto it
	func volumetricShadows(shape: AnyView = AnyView(RoundedRectangle(cornerRadius: 25, style: .continuous)), color1: Color = .volumeEffectShadowColor, color2: Color = .shadowColor, radius: CGFloat = 5, isPressed: Bool = false) -> some View {
		self.modifier(VolumetricShadows(shape: shape, color1: color1, color2: color2, radius: radius, isPressed: isPressed))
	}
}
