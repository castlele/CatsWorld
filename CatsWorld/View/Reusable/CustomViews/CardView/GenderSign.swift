//
//  GenderSign.swift
//  CatsWorld
//
//  Created by Nikita Semenov on 29.06.2021.
//

import SwiftUI

struct GenderSign: View {
	
	let genderSign: String
	let foregroundColor: Color
	
    var body: some View {
		Text("\(genderSign)")
			.font(.title)
			.fontWeight(.medium)
			.foregroundColor(foregroundColor)
    }
}

// MARK: - Equatable comformance
extension GenderSign: Equatable {
	static func == (lhs: Self, rhs: Self) -> Bool {
		lhs.genderSign == rhs.genderSign
	}
}

struct GenderSign_Previews: PreviewProvider {
    static var previews: some View {
		GenderSign(genderSign: "", foregroundColor: .textColor)
    }
}
