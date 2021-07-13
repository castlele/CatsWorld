//
//  3DView.swift
//  CatsWorld
//
//  Created by Nikita Semenov on 09.06.2021.
//

import SwiftUI

struct View3D<Content: View>: View, Equatable {

	let topView: Content
	let bottomView: Content

	var topColor: Color?
	var bottomColor: Color?

    var body: some View {
		ZStack {
			bottomView
				.foregroundColor(bottomColor)

			topView
				.offset(x: 1.1, y: -1.1)
				.foregroundColor(topColor)
		}
	}
	
	static func == (lhs: Self, rhs: Self) -> Bool { false }
}

struct Image3D: View, Equatable {
	
	let topView: Image
	let bottomView: Image
	
	var topColor: Color?
	var bottomColor: Color?
	
	var body: some View {
		ZStack {
			bottomView
				.resizable()
				.foregroundColor(bottomColor)
				.padding()
			
			topView
				.resizable()
				.offset(x: 1.1, y: -1.1)
				.foregroundColor(topColor)
				.padding()
		}
	}
	
	static func == (lhs: Self, rhs: Self) -> Bool { false }
}

struct View3D_Previews: PreviewProvider {
    static var previews: some View {
		Image3D(topView: Image(systemName: "plus"), bottomView: Image(systemName: "plus"))
    }
}
