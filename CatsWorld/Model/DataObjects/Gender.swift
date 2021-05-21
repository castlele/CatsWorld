//
//  Gender.swift
//  CatsWorld
//
//  Created by Nikita Semenov on 18.05.2021.
//

import Foundation

/// Cats' Gender representation
enum Gender: String, Identifiable {
	case male
	case female
	
	var id: String {
		self.rawValue
	}
}

extension Gender: CaseIterable {
	
}
