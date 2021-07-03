//
//  XButton.swift
//  CatsWorld
//
//  Created by Nikita Semenov on 25.06.2021.
//

import SwiftUI

struct XButton: View {
    var body: some View {
		Image3D(
			topView: Image(systemName: "xmark"),
			bottomView: Image(systemName: "xmark"),
			topColor: .white,
			bottomColor: Color(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1))
		)
		.equatable()
    }
}

struct XButton_Previews: PreviewProvider {
    static var previews: some View {
        XButton()
    }
}
