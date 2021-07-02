//
//  Describable.swift
//  CatsWorld
//
//  Created by Nikita Semenov on 02.07.2021.
//

import Foundation

protocol Describable {
	func getDescriptionsFor(category: CatsDescriptionCategory) -> [Description]
}
