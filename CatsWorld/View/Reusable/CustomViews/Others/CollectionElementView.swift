//
//  CollectionElementView.swift
//  CatsWorld
//
//  Created by Nikita Semenov on 18.07.2021.
//

import SwiftUI

struct CollectionElementView: View {
	
	let text: String
	let bgColor: Color = .semiAccentColor
	let fgColor: Color = .primary
	
    var body: some View {
        Text(text.localize().capitalized)
			.allowsTightening(true)
			.font(.system(.body, design: .rounded))
			.foregroundColor(fgColor)
			.lineLimit(1)
			.padding(5)
			.frame(height: 35)
			.background(
				Color.semiAccentColor
			)
			.clipShape(RoundedRectangle(cornerRadius: 15))

    }
}

struct PickedElementView_Previews: PreviewProvider {
	
    static var previews: some View {
		CollectionElementView(text: "Hello")
    }
}
