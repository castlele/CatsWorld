//
//  EarView.swift
//  CatsWorld
//
//  Created by Nikita Semenov on 23.06.2021.
//

import SwiftUI

struct EarsView: View {
    var body: some View {
		ZStack {
			GeometryReader { geometry in
				Rectangle()
					.fill(Color.mainColor)
					.frame(width: 50, height: 50)
					.rotationEffect(Angle(degrees: 10))
					.offset(x: 10, y: 0)
				
				Rectangle()
					.fill(Color.mainColor)
					.frame(width: 50, height: 50)
					.rotationEffect(Angle(degrees: -10))
					.offset(x: geometry.frame(in: .local).maxX - 10 - 50, y: 0)
			}
		}
    }
}

struct EarView_Previews: PreviewProvider {
    static var previews: some View {
        EarsView()
    }
}
