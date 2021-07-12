//
//  UITabBarController.swift
//  CatsWorld
//
//  Created by Nikita Semenov on 12.07.2021.
//

import SwiftUI

extension UITabBarController {
	override open func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		let standardAppearance = UITabBarAppearance()
		
		standardAppearance.backgroundColor = Color.mainUIColor()
		standardAppearance.shadowColor = UIColor(named: "shadowColor")
		
		tabBar.standardAppearance = standardAppearance
	}
}
