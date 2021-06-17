//
//  LinearGradient.swift
//  CatsWorld
//
//  Created by Nikita Semenov on 17.06.2021.
//

import SwiftUI

extension LinearGradient {
	
	init(_ colors: Color...) {
		self.init(gradient: Gradient(colors: colors), startPoint: .topLeading, endPoint: .bottomTrailing)
	}
}
