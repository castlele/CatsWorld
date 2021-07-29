//
//  UIApplication.swift
//  CatsWorld
//
//  Created by Nikita Semenov on 13.07.2021.
//

import UIKit

extension UIApplication {
	
	static let safeAreaInsetsTop = UIApplication.shared.windows.first?.safeAreaInsets.top
	
	/// Dismiss keyboard 
	func endEditing(_ force: Bool) {
		self.windows
			.filter { $0.isKeyWindow }
			.first?
			.endEditing(force)
	}
}
