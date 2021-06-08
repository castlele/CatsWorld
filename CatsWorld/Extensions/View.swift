//
//  View.swift
//  CatsWorld
//
//  Created by Nikita Semenov on 21.05.2021.
//

import SwiftUI

extension View {
	
	/// Adds volume to the view by applying to shadows onto it
	func volumetricShadows(color1: Color = .white, color2: Color = .black, radius: CGFloat = 5) -> some View {
		self.modifier(VolumetricShadows(color1: color1, color2: color2, radius: radius))
	}
}
