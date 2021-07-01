//
//  String.swift
//  CatsWorld
//
//  Created by Nikita Semenov on 30.06.2021.
//

import Foundation

extension String {
	
	/// Laxalizes value from .stringdict file
	/// - Parameters:
	///   - tableName: Name of the file with localization
	///   - key: Key of value, which should be localized
	///   - arguments: Argument for localizing `String`. Have to be `Int.Type`
	/// - Returns: Localized `String` value
	func localize(from tableName: String = "Localizable", withKey key: String? = nil, arguments: Int) -> String {
		let format = NSLocalizedString(key ?? self, tableName: tableName, bundle: .main, value: "None", comment: "")
		
		let resultString = String.localizedStringWithFormat(format, arguments)
		
		return resultString
	}
	
	/// Localizes value from .string file
	/// - Parameters:
	///   - tableName: Name of the file with localization
	///   - key: Key of value, which should be localized
	/// - Returns: Localized `String` value
	func localize(from tableName: String = "Localizable", withKey key: String? = nil) -> String {
		NSLocalizedString(key ?? self, tableName: tableName, bundle: .main, value: key ?? self, comment: "")
	}
}
