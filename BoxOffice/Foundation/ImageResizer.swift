//
//  ImageResizer.swift
//  BoxOffice
//
//  Created by Kim EenSung on 3/15/24.
//

import UIKit

extension UIImage {
    func resize(newWidth: CGFloat) -> UIImage {
        let scale = newWidth / self.size.width
        let newHeight = self.size.height * scale

        let size = CGSize(width: newWidth, height: newHeight)
        let renderer = UIGraphicsImageRenderer(size: size)
        let renderedImage = renderer.image { context in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
        
        return renderedImage
    }
}
