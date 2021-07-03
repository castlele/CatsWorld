//
//  CatManipulator.swift
//  CatsWorld
//
//  Created by Nikita Semenov on 03.07.2021.
//

import Foundation

protocol CatManipulator: ObservableObject {
	func selectCat(_ cat: CatsCard)
	func deselectCat()
}
