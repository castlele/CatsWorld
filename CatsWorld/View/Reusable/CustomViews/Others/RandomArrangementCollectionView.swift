//
//  RandomArrangementCollectionView.swift
//  CatsWorld
//
//  Created by Nikita Semenov on 18.07.2021.
//

import SwiftUI

struct RandomArrangementCollectionView: View {
	
	private let width = UIScreen.screenWidth
	private var maxInRow: Int {
		let max = Int(width) / 80
		
		return max > count ? count : max
	}
	private var rows: Int {
		let rowsCount = count / maxInRow
		
		guard rowsCount >= 1 else {
			return 1
		}
		
		return rowsCount
	}
	private var list: Binding<[String]>
	private var count: Int { list.wrappedValue.count }
		
	init(list: Binding<[String]>) {
		self.list = list
	}
	
    var body: some View {
		ScrollView([.vertical, .horizontal], showsIndicators: false) {
			VStack(spacing: 1) {
				
				ForEach(0..<rows) { indexOfRow in
					HStack(spacing: 1) {
						
						ForEach(0..<maxInRow) { indexOfElement in
							CollectionElementView(text: list[maxInRow * indexOfRow + indexOfElement].wrappedValue)
						}
					}
				}
			}
		}
    }
}

struct PickerListView_Previews: PreviewProvider {
	static let list = ["relaxed",
					   "clever",
					   "trainable",
					   "adventurous",
					   "highly intelligent",
					   "affectionate",
					   "expressive",
					   "mischievous",
					   "outgoing",
					   "sociable",
					   "agile",
					   "gentle",
					   "lively",
					   "sensible",
					   "easygoing",
					   "easy going",
					   "sedate",
					   "sweet-tempered",
					   "energetic",
					   "loyal",
					   "curious",
					   "friendly",
					   "alert",
					   "playful",
					   "tenacious",
					   "devoted",
					   "shy",
					   "calm",
					   "independent",
					   "warm",
					   "quiet",
					   "sweet",
					   "loving",
					   "patient",
					   "inquisitive",
					   "active",
					   "peaceful",
					   "sensitive",
					   "dependent",
					   "demanding",
					   "talkative",
					   "fun-loving",
					   "interactive",
					   "highly interactive",
					   "adaptable",
					   "social",
					   "intelligent"
	]
    static var previews: some View {
		RandomArrangementCollectionView(list: .constant(["Hello", "World", "!", "!"]))
    }
}
