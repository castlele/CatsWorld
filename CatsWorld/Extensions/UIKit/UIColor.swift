//
//  UIColor.swift
//  CatsWorld
//
//  Created by Nikita Semenov on 17.05.2021.
//

import SwiftUI

extension UIColor {
	
	/// Decode `UIColor` from `Data`
	/// - Parameter data: Optional data that represents color
	/// - Returns: Decoded `UIColor` if succseed or default `.white`
	class func color(withData data: Data?) -> UIColor {
		do {
			if let data = data {
				let uiColor = try NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: data)
				return uiColor ?? UIColor(Color.mainColor)
			}
			return UIColor(Color.mainColor)
		} catch {
			fatalError("\(error.localizedDescription)")
		}
	}
	
	/// Encode `UIColor` to `Data`
	/// - Returns: `Data` that represents `UIColor`
	func encode() -> Data {
		do {
			let data = try NSKeyedArchiver.archivedData(withRootObject: self, requiringSecureCoding: false)
			return data
		} catch {
			fatalError("\(error.localizedDescription)")
		}
	}
}
