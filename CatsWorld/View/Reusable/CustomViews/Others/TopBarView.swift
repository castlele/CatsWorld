//
//  TopBarView.swift
//  CatsWorld
//
//  Created by Nikita Semenov on 24.06.2021.
//

import SwiftUI

struct TopBarView<Leading: View, Trailing: View, Content: View>: View {
	
	let backgroundColor: Color
	let height: CGFloat?
	let minHeight: CGFloat?
	let maxHeight: CGFloat?
	let leading: Leading
	let trailing: Trailing
	let content: Content
	
	init(
		backgroundColor: Color = .mainColor,
		height: CGFloat? = nil,
		minHeight: CGFloat? = nil,
		maxHeight: CGFloat? = nil,
		@ViewBuilder leading: () -> Leading,
		@ViewBuilder trailing: () -> Trailing,
		@ViewBuilder content: () -> Content
	) {
		self.backgroundColor = backgroundColor
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
				.fill(Color.shadowColor.opacity(0.5))
				.blur(radius: 2)
				.offset(x: 0, y: 3)
				.ignoresSafeArea(edges: .top)
			
			Rectangle()
				.fill(backgroundColor)
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
		backgroundColor: Color = .mainColor,
		height: CGFloat? = nil,
		minHeight: CGFloat? = nil,
		maxHeight: CGFloat? = nil,
		@ViewBuilder leading: () -> Leading,
		@ViewBuilder trailing: () -> Trailing
	) {
		self.backgroundColor = backgroundColor
		self.height = height
		self.minHeight = minHeight
		self.maxHeight = maxHeight
		self.leading = leading()
		self.trailing = trailing()
		self.content = EmptyView()
	}
}

// MARK:- Leading == EmptyView, Content == EmptyView
extension TopBarView where Leading == EmptyView, Trailing: View, Content == EmptyView {
	init(
		backgroundColor: Color = .mainColor,
		height: CGFloat? = nil,
		minHeight: CGFloat? = nil,
		maxHeight: CGFloat? = nil,
		@ViewBuilder trailing: () -> Trailing
	) {
		self.backgroundColor = backgroundColor
		self.height = height
		self.minHeight = minHeight
		self.maxHeight = maxHeight
		self.leading = EmptyView()
		self.trailing = trailing()
		self.content = EmptyView()
	}
}

// MARK:- Leading == EmptyView, Content == EmptyView
extension TopBarView where Leading: View, Trailing == EmptyView, Content: View {
	init(
		backgroundColor: Color = .mainColor,
		height: CGFloat? = nil,
		minHeight: CGFloat? = nil,
		maxHeight: CGFloat? = nil,
		@ViewBuilder leading: () -> Leading,
		@ViewBuilder content: () -> Content
	) {
		self.backgroundColor = backgroundColor
		self.height = height
		self.minHeight = minHeight
		self.maxHeight = maxHeight
		self.leading = leading()
		self.trailing = EmptyView()
		self.content = content()
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
