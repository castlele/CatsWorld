//
//  UIColor.swift
//  CatsWorld
//
//  Created by Nikita Semenov on 17.05.2021.
//

import Foundation
import UIKit

extension UIColor {
	class func color(withData data: Data?) -> UIColor {
		do {
			if let data = data {
				let uiColor = try NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: data)
				return uiColor ?? .white
			}
			return .white
		} catch {
			fatalError("\(error.localizedDescription)")
		}
	}
	
	func encode() -> Data {
		do {
			let data = try NSKeyedArchiver.archivedData(withRootObject: self, requiringSecureCoding: false)
			return data
		} catch {
			fatalError("\(error.localizedDescription)")
		}
	}
}
