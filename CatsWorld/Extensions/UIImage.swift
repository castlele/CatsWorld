//
//  UIImage.swift
//  CatsWorld
//
//  Created by Nikita Semenov on 11.06.2021.
//

import UIKit

extension UIImage {
	convenience init?(data: Data?) {
		guard let data = data else { return nil }
		
		self.init(data: data)
	}
}
