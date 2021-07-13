//
//  UIApplication.swift
//  CatsWorld
//
//  Created by Nikita Semenov on 13.07.2021.
//

import UIKit

extension UIApplication {
	func endEditing(_ force: Bool) {
		self.windows
			.filter { $0.isKeyWindow }
			.first?
			.endEditing(force)
	}
}
