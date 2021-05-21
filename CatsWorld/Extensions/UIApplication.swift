//
//  UIApplication.swift
//  CatsWorld
//
//  Created by Nikita Semenov on 19.05.2021.
//

import UIKit

extension UIApplication {
	func endEditing() {
		sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
	}
}
