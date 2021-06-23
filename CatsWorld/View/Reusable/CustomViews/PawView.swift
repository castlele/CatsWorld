//
//  PawView.swift
//  CatsWorld
//
//  Created by Nikita Semenov on 19.06.2021.
//

import SwiftUI

struct PawView: Shape {
	
	func path(in rect: CGRect) -> Path {
		let radius = min(rect.maxX - rect.midX, rect.maxY - rect.midY)
		var path = Path()
		
		let middlePad = drawMiddlePad(in: rect, with: radius)
		path.addPath(middlePad)
		
		let fingersPads = drawFingersPads(in: rect)
		path.addPath(fingersPads)
		
		return path
	}
	
	private func drawMiddlePad(in rect: CGRect, with radius: CGFloat) -> Path {
		var path = Path()
		
		path.addEllipse(
			in: CGRect(
				x: rect.midX - radius / 2 - 2.5,
				y: rect.midY,
				width: radius + 5,
				height: radius - 5
			)
		)
		
		return path
	}
	
	private func drawFingersPads(in rect: CGRect) -> Path {
		var path = Path()
		
		path.addEllipse(
			in: CGRect(
				x: 5,
				y: rect.midY - rect.width / 5,
				width: rect.width / 4.5,
				height: rect.width / 4.5
			)
		)
		
		path.addEllipse(
			in: CGRect(
				x: 3 + rect.width / 4.5,
				y: 9,
				width: rect.width / 4.5,
				height: rect.width / 4.5
			)
		)
		
		path.addEllipse(
			in: CGRect(
				x: rect.maxX - 3 - rect.width / 2.25,
				y: 9,
				width: rect.width / 4.5,
				height: rect.width / 4.5
			)
		)
		
		path.addEllipse(
			in: CGRect(
				x: rect.maxX - 5 - rect.width / 4.5,
				y: rect.midY - rect.width / 5,
				width: rect.width / 4.5,
				height: rect.width / 4.5
			)
		)
		
		return path
	}
}

struct PawView_Previews: PreviewProvider {
    static var previews: some View {
        PawView()
			.stroke(style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round, miterLimit: 1, dash: [], dashPhase: 1))
			.frame(width: 100, height: 100)
			.background(Color.gray)
    }
}
