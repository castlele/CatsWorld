//
//  SpiderPlot.swift
//  CatsWorld
//
//  Created by Nikita Semenov on 17.06.2021.
//

import SwiftUI

fileprivate func determineRadius(in rect: CGRect) -> CGFloat {
	min(rect.maxX - rect.midX, rect.maxY - rect.midY)
}

struct RadarChartView: View {
	
	let data: [(categoryName: String, value: Int)]
	let gridColor: Color
	let dataColor: Color
	
	init(data: [(String, Int)], gridColor: Color, dataColor: Color) {
		self.data = data
		self.gridColor = gridColor
		self.dataColor = dataColor
		
		self.dataValues = self.data.map { Double($0.value) }
		self.dataNames = self.data.map { $0.categoryName }
		
		reorderDataNames()
	}
	
	init(data: [(String, Int)], gridColor: Color, dataColor: Color, reorder: ([String]) -> [String]) {
		self.data = data
		self.gridColor = gridColor
		self.dataColor = dataColor
		
		self.dataValues = self.data.map { Double($0.value) }
		
		let names = self.data.map { $0.categoryName }
		self.dataNames = reorder(names)
	}
	
	private var dataValues: [Double]
	
	@State private var dataNames: [String]
	
	private var scale = 5
	
	private var count: Int { data.count }
	
	var body: some View {
		ZStack(alignment: .center) {
			GeometryReader { geometry in
				ForEach(1..<count + 1) { category in
					Text(dataNames[category - 1])
						.offset(
							x: determineOffset(xAxis: true, geometryProxy: geometry, category: category),
							y: determineOffset(xAxis: false, geometryProxy: geometry, category: category)
						)
				}
			}
			
			RadarChartGrid(categories: count, scale: 5)
				.stroke(gridColor)
			
			RadarChartDataVisualisation(data: dataValues)
				.fill(dataColor.opacity(0.5))
			
			RadarChartDataVisualisation(data: dataValues)
				.stroke(dataColor)
		}
	}
	
	private func determineOffset(xAxis: Bool, geometryProxy: GeometryProxy, category: Int) -> CGFloat {
		let rect = geometryProxy.frame(in: .local)
		let radius = determineRadius(in: rect)
		
		if xAxis {
			return (rect.midX + cos(CGFloat(category) * 2 * .pi / CGFloat(count) - .pi / 2) * radius) - 60
		}
		
		switch category {
			case count:
				return (rect.midY + sin(CGFloat(category) * 2 * .pi / CGFloat(count) - .pi / 2) * radius) - 15
			default:
				return (rect.midY + sin(CGFloat(category) * 2 * .pi / CGFloat(count) - .pi / 2) * radius)
		}
		
	}
	
	mutating private func reorderDataNames() {
		var index = 0
		let first = dataNames[index]
		var result = [String](repeating: "", count: dataNames.count)
		print(dataNames)
		while index != (dataNames.count - 1) {
			index += 1
			let nextName = dataNames[index]
			result[index] = first
			result[index - 1] = nextName
		}
		print(result)
		dataNames = result
	}
}

fileprivate struct RadarChartDataVisualisation: Shape {
	
	let data: [Double]
	
	func path(in rect: CGRect) -> Path {
		guard
			3 <= data.count,
			let minimum = data.min(),
			0 <= minimum,
			let maximum = data.max()
		else { return Path() }
		
		let radius = determineRadius(in: rect)
		var path = Path()
		
		for (index, entry) in data.enumerated() {
			switch index {
				case 0:
					path.move(to:
								CGPoint(
									x: rect.midX + CGFloat(entry / maximum) * cos(CGFloat(index) * 2 * .pi / CGFloat(data.count) - .pi / 2) * radius,
									y: rect.midY + CGFloat(entry / maximum) * sin(CGFloat(index) * 2 * .pi / CGFloat(data.count) - .pi / 2) * radius
								)
					)
					
				default:
					path.addLine(to:
									CGPoint(
										x: rect.midX + CGFloat(entry / maximum) * cos(CGFloat(index) * 2 * .pi / CGFloat(data.count) - .pi / 2) * radius,
										y: rect.midY + CGFloat(entry / maximum) * sin(CGFloat(index) * 2 * .pi / CGFloat(data.count) - .pi / 2) * radius
									)
					)
			}
		}
		path.closeSubpath()
		return path
	}
}

fileprivate struct RadarChartGrid: Shape {
	
	let categories: Int
	let scale: Int
	
	func path(in rect: CGRect) -> Path {
		let radius = determineRadius(in: rect)
		let stride = radius / CGFloat(scale)
		
		var path = Path()
		
		for category in 1 ... categories {
			path.move(to: CGPoint(x: rect.midX, y: rect.midY))
			path.addLine(to:
							CGPoint(
								x: rect.midX + cos(CGFloat(category) * 2 * .pi / CGFloat(categories) - .pi / 2) * radius,
								y: rect.midY + sin(CGFloat(category) * 2 * .pi / CGFloat(categories) - .pi / 2) * radius
							)
			)
		}
		
		for step in 1 ... scale {
			let rad = CGFloat(step) * stride
			path.move(to:
						CGPoint(
							x: rect.midX + cos(-.pi / 2) * rad,
							y: rect.midY + sin(-.pi / 2) * rad
						)
			)
			
			for category in 1 ... categories {
				path.addLine(to:
								CGPoint(
									x: rect.midX + cos(CGFloat(category) * 2 * .pi / CGFloat(categories) - .pi / 2) * rad,
									y: rect.midY + sin(CGFloat(category) * 2 * .pi / CGFloat(categories) - .pi / 2) * rad
								)
				)
			}
		}
		
		return path
	}
}

struct SpiderPlot_Previews: PreviewProvider {
    static var previews: some View {
		RadarChartView(data: [("Child friendly", 2), ("Stranger friendly", 1), ("Dog friendly", 5)], gridColor: .gray, dataColor: .green)
			.frame(width: 200, height: 200)
    }
}
