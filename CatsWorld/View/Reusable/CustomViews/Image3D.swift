//
//  3DView.swift
//  CatsWorld
//
//  Created by Nikita Semenov on 09.06.2021.
//

import SwiftUI

//struct View3D<Content: View>: View {
//
//	var topView: Content
//	var bottomView: Content
//
//	var topColor: Color?
//	var bottomColor: Color?
//
//    var body: some View {
//		ZStack {
//			bottomView
//				.foregroundColor(bottomColor)
//				.padding()
//
//			topView
//				.offset(x: 1, y: -1)
//				.foregroundColor(topColor)
//				.padding()
//		}
//    }
//}

struct Image3D: View {
	
	var topView: Image
	var bottomView: Image
	
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
				.offset(x: 1, y: -1)
				.foregroundColor(topColor)
				.padding()
		}
	}
}

struct View3D_Previews: PreviewProvider {
    static var previews: some View {
		Image3D(topView: Image(systemName: "plus"), bottomView: Image(systemName: "plus"))
    }
}
