//
//  UIViewExtension.swift
//  Maze
//
//  Created by Ethan Humphrey on 12/12/19.
//  Copyright © 2019 Ethan Humphrey. All rights reserved.
//


import UIKit

extension UIView {
    func getColor(at point: CGPoint) -> UIColor {

        let pixel = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: 4)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let context = CGContext(data: pixel, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)!

        context.translateBy(x: -point.x, y: -point.y)
        self.layer.render(in: context)
        let color = UIColor(red:   CGFloat(pixel[0]) / 255.0,
                            green: CGFloat(pixel[1]) / 255.0,
                            blue:  CGFloat(pixel[2]) / 255.0,
                            alpha: CGFloat(pixel[3]) / 255.0)

        pixel.deallocate()
        return color
    }
    
    func getWallDirection(in rect: CGRect) -> [Direction] {
        let yArray = [rect.minY, rect.maxY]
        let xArray = [rect.minX, rect.maxX]
        var directionArray = [Direction.none]
        
        var backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        if traitCollection.userInterfaceStyle == .dark {
            backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        }
        
        for y in Int(yArray[0]) ... Int(yArray[1]) {
            for x in Int(rect.midX - 1) ... Int(rect.midX + 1) {
                let color = getColor(at: CGPoint(x: x, y: y))
                if color != backgroundColor {
                    if CGFloat(y) < rect.midY {
                        directionArray.append(.top)
                    }
                    else {
                        directionArray.append(.bottom)
                    }
                    break
                }
            }
        }
        for x in Int(xArray[0]) ... Int(xArray[1]) {
            for y in Int(rect.midY - 1) ... Int(rect.midY + 1) {
                if getColor(at: CGPoint(x: x, y: y)) != backgroundColor {
                    if CGFloat(x) < rect.midX {
                        directionArray.append(.right)
                    }
                    else {
                        directionArray.append(.left)
                    }
                    break
                }
            }
        }
        return directionArray
    }
}

enum Direction {
    case none
    case top
    case bottom
    case left
    case right
}
