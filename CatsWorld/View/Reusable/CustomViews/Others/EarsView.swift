//
//  EarView.swift
//  CatsWorld
//
//  Created by Nikita Semenov on 23.06.2021.
//

import SwiftUI

struct EarsView: View {
	
	var ear: some View {
		Rectangle()
			.stroke(Color.accentColor, style: StrokeStyle(lineWidth: 2.5, lineCap: .round, lineJoin: .round, miterLimit: 0, dash: [], dashPhase: 0))
			.frame(width: 50, height: 50)
			.background(Color.mainColor)
	}
	
    var body: some View {
		ZStack {
			GeometryReader { geometry in
				ear
					.rotationEffect(Angle(degrees: 10))
					.offset(x: 13, y: 3)
				
				ear
					.rotationEffect(Angle(degrees: -10))
					.offset(x: geometry.frame(in: .local).maxX - 13 - 50, y: 3)
			}
		}
    }
}

struct EarView_Previews: PreviewProvider {
    static var previews: some View {
        EarsView()
    }
}
