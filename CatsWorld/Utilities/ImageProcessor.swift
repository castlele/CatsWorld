//
//  ImageProcesser.swift
//  CatsWorld
//
//  Created by Nikita Semenov on 08.07.2021.
//

import UIKit

struct ImageProcessor {
	static let shared = ImageProcessor()
	
	func downsampleImage(image: Data) -> UIImage? {
		let pointSize = CGSize(width: UIScreen.screenWidth, height: UIScreen.screenHeight)
		let imageSourceOptions = [kCGImageSourceShouldCache: false] as CFDictionary
		
		guard let imageSource = CGImageSourceCreateWithData(image as CFData, imageSourceOptions) else { return nil }
		
		let maxDimensionInPixels = max(pointSize.width, pointSize.height) * UIScreen.main.scale
		
		let downsampleOptions = [kCGImageSourceCreateThumbnailFromImageAlways: true,
								 kCGImageSourceShouldCacheImmediately: true,
								 kCGImageSourceCreateThumbnailWithTransform: true,
								 kCGImageSourceThumbnailMaxPixelSize: maxDimensionInPixels
		] as CFDictionary
		
		guard let downsampledImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, downsampleOptions) else { return nil }
		
		return UIImage(cgImage: downsampledImage)
	}
}
