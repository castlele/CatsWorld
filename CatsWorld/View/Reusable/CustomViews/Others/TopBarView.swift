//
//  TopBarView.swift
//  CatsWorld
//
//  Created by Nikita Semenov on 24.06.2021.
//

import SwiftUI

// MARK: - Leading: View, Trailing: View, Content: View
struct TopBarView<Leading: View, Trailing: View, Content: View>: View {
	
	let isVolume: Bool
	let backgroundColor: Color
	let minHeight: CGFloat?
	let maxHeight: CGFloat?
	let leading: Leading
	let trailing: Trailing
	let content: Content
	
	init(
		isVolume: Bool = true,
		backgroundColor: Color = .mainColor,
		minHeight: CGFloat? = nil,
		maxHeight: CGFloat? = nil,
		@ViewBuilder leading: () -> Leading,
		@ViewBuilder trailing: () -> Trailing,
		@ViewBuilder content: () -> Content
	) {
		self.isVolume = isVolume
		self.backgroundColor = backgroundColor
		self.minHeight = minHeight
		self.maxHeight = maxHeight
		self.leading = leading()
		self.trailing = trailing()
		self.content = content()
	}
	
    var body: some View {
		ZStack {
			backgroundColor.ignoresSafeArea(edges: .top)
			
			VStack {
				HStack {
					leading
					
					Spacer()
					
					trailing
				}
				
				content
			}
		}
		.frame(height: maxHeight)
//		.background(
//			Rectangle()
//				.fill(Color.shadowColor.opacity(1))
//				.blur(radius: 2)
//				.offset(y: 3)
//				.opacity(isVolume ? 1 : 0)
//		)
		.volumetricShadows(shape: .rect, color1: .clear, color2: isVolume ? .shadowColor : .clear, radius: 2, isPressed: false)
    }
}

// MARK:- Content == EmptyView
extension TopBarView where Leading: View, Trailing: View, Content == EmptyView {
	init(
		isVolume: Bool = true,
		backgroundColor: Color = .mainColor,
		minHeight: CGFloat? = nil,
		maxHeight: CGFloat? = nil,
		@ViewBuilder leading: () -> Leading,
		@ViewBuilder trailing: () -> Trailing
	) {
		self.isVolume = isVolume
		self.backgroundColor = backgroundColor
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
		isVolume: Bool = true,
		backgroundColor: Color = .mainColor,
		minHeight: CGFloat? = nil,
		maxHeight: CGFloat? = nil,
		@ViewBuilder trailing: () -> Trailing
	) {
		self.isVolume = isVolume
		self.backgroundColor = backgroundColor
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
		isVolume: Bool = true,
		backgroundColor: Color = .mainColor,
		height: CGFloat? = nil,
		minHeight: CGFloat? = nil,
		maxHeight: CGFloat? = nil,
		@ViewBuilder leading: () -> Leading,
		@ViewBuilder content: () -> Content
	) {
		self.isVolume = isVolume
		self.backgroundColor = backgroundColor
		self.minHeight = minHeight
		self.maxHeight = maxHeight
		self.leading = leading()
		self.trailing = EmptyView()
		self.content = content()
	}
}

// MARK: - Leading == EmptyView, Trailing == EmptyView, Content == EmptyView
extension TopBarView where Leading == EmptyView, Trailing == EmptyView, Content == EmptyView {
	init(
		isVolume: Bool = true,
		backgroundColor: Color = .mainColor,
		height: CGFloat? = nil,
		minHeight: CGFloat? = nil,
		maxHeight: CGFloat? = nil
	) {
		self.isVolume = isVolume
		self.backgroundColor = backgroundColor
		self.minHeight = minHeight
		self.maxHeight = maxHeight
		self.leading = EmptyView()
		self.trailing = EmptyView()
		self.content = EmptyView()
	}
}

// MARK: - Leading == Empty View, Trailing == EmptyView, Content: View
extension TopBarView where Leading == EmptyView, Trailing == EmptyView, Content: View {
	init(
		isVolume: Bool = true,
		backgroundColor: Color = .mainColor,
		minHeight: CGFloat? = nil,
		maxHeight: CGFloat? = nil,
		@ViewBuilder content: () -> Content
	) {
		self.isVolume = isVolume
		self.backgroundColor = backgroundColor
		self.minHeight = minHeight
		self.maxHeight = maxHeight
		self.leading = EmptyView()
		self.trailing = EmptyView()
		self.content = content()
	}
}

struct TopBarView_Previews: PreviewProvider {
    static var previews: some View {
		ZStack {
			Color.blue.zIndex(0)
			
			VStack(spacing:0) {
				TopBarView(isVolume: true, backgroundColor: .red, maxHeight: 80, leading: {
					Text("")
				}, trailing: {
					Text("")
				})
				.zIndex(2)
				
				ScrollView {
					Text("hello")
					
					Text("World")
				}
				.listStyle(InsetListStyle())
				.zIndex(1)
			}
		}
    }
}
