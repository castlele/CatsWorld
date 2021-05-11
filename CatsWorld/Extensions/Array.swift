//
//  Array.swift
//  CatsWorld
//
//  Created by Nikita Semenov on 11.05.2021.
//

import Foundation

extension Array where Element: Equatable{
	
	/// Remove all occurances of `element` in the Array
	/// - Parameter element: element, which occurances should be removed from the array
	mutating func removeAllOccurances(_ element: Element) {
		var filteredArray = [Element]()
		for el in self {
			if el != element {
				filteredArray.append(el)
			}
		}
		self = filteredArray
	}
}
