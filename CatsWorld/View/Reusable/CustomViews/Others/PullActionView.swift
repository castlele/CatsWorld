//
//  PullActionView.swift
//  CatsWorld
//
//  Created by Nikita Semenov on 16.07.2021.
//

import SwiftUI

struct PullActionView<Content: View>: View {
	
	private let minTimeToDoAction = TimeInterval(0.5)
	private let triggerHeight = CGFloat(50)
	private let viewHeight = CGFloat(80)
	private let fullHeight = CGFloat(130)
	
	let action: () -> Void
	@ViewBuilder var viewToShow: Content
	
	@State var timeOfPulling: Date? = nil
	@State var isViewShown = false
	
    var body: some View {
		VStack(spacing: 0) {
			LazyVStack(spacing: 0) {
				Color.clear
					.frame(height: triggerHeight)
					.onAppear {
						withAnimation(.linear) {
							isViewShown = true
						}
						
						timeOfPulling = Date()
					}
					.onDisappear {
						if isViewShown {
							if let difference = timeOfPulling?.distance(to: Date()),
							   difference >= minTimeToDoAction {
								action()
							}
						}
						
						withAnimation(.linear) {
							isViewShown = false
						}
						
						timeOfPulling = nil
					}
			}
			.frame(height: triggerHeight)
			
			viewToShow
				.frame(height: viewHeight)
				.opacity(isViewShown ? 1 : 0)
		}
		.background(Color.clear)
		.ignoresSafeArea()
		.frame(height: fullHeight)
		.padding(.top, -fullHeight)
    }
}

struct PullActionView_Previews: PreviewProvider {
    static var previews: some View {
		PullActionView(action: {}) {Text("")}
    }
}