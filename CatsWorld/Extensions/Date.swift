//
//  Date.swift
//  CatsWorld
//
//  Created by Nikita Semenov on 09.06.2021.
//

import Foundation

extension Date {
	func getFormattedDate(format: String) -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = format
		
		return dateFormatter.string(from: self)
	}
}
