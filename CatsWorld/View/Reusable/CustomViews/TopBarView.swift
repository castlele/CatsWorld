//
//  TopBarView.swift
//  CatsWorld
//
//  Created by Nikita Semenov on 24.06.2021.
//

import SwiftUI

struct TopBarView<Leading: View, Trailing: View, Content: View>: View {
	
	let height: CGFloat?
	let minHeight: CGFloat?
	let maxHeight: CGFloat?
	let leading: Leading
	let trailing: Trailing
	let content: Content
	
	init(
		height: CGFloat? = nil,
		minHeight: CGFloat? = nil,
		maxHeight: CGFloat? = nil,
		@ViewBuilder leading: () -> Leading,
		@ViewBuilder trailing: () -> Trailing,
		@ViewBuilder content: () -> Content
	) {
		self.height = height
		self.minHeight = minHeight
		self.maxHeight = maxHeight
		self.leading = leading()
		self.trailing = trailing()
		self.content = content()
	}
	
    var body: some View {
		ZStack {
			Rectangle()
				.fill(Color.black.opacity(0.5))
				.blur(radius: 2)
				.offset(x: 0, y: 3)
				.ignoresSafeArea(edges: .top)
			
			Rectangle()
				.fill(Color.white)
				.ignoresSafeArea(edges: .top)
			
			VStack {
				HStack {
					leading
					
					Spacer()
					
					trailing
				}
				
				content
			}
		}
		.frame(minHeight: minHeight, idealHeight: height, maxHeight: maxHeight)
    }
}

// MARK:- Content == EmptyView
extension TopBarView where Leading: View, Trailing: View, Content == EmptyView {
	init(
		height: CGFloat? = nil,
		minHeight: CGFloat? = nil,
		maxHeight: CGFloat? = nil,
		@ViewBuilder leading: () -> Leading,
		@ViewBuilder trailing: () -> Trailing
	) {
		self.height = height
		self.minHeight = minHeight
		self.maxHeight = maxHeight
		self.leading = leading()
		self.trailing = trailing()
		self.content = EmptyView()
	}
}

struct TopBarView_Previews: PreviewProvider {
    static var previews: some View {
		TopBarView(height: 100, leading: {
			Text("")
		}, trailing: {
			Text("")
		})
    }
}
