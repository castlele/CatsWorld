//
//  EnvironmentValues.swift
//  CatsWorld
//
//  Created by Nikita Semenov on 20.07.2021.
//

import SwiftUI

extension EnvironmentValues {
	
	var menuWidth: CGFloat {
		get { self[MenuWidth.self] }
	}
}
