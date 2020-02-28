//
//  CGVectorExtension.swift
//  Maze
//
//  Created by Ethan Humphrey on 12/11/19.
//  Copyright © 2019 Ethan Humphrey. All rights reserved.
//

import CoreGraphics

extension CGVector {
    static func * (left: CGFloat, right: CGVector) -> CGVector {
        let newMagnitude = right.magnitude * left
        let xAngle = acos(right.dx/right.magnitude)
        let yAngle = asin(right.dy/right.magnitude)
        let newX = newMagnitude*cos(xAngle)
        let newY = newMagnitude*sin(yAngle)
        return CGVector(dx: newX, dy: newY)
    }
    
    static func * (left: CGVector, right: CGFloat) -> CGVector {
        return right * left
    }
    
    static func + (left: CGVector, right: CGVector) -> CGVector {
        return CGVector(dx: left.dx + right.dx, dy: left.dy + right.dy)
    }
    
    static func - (left: CGVector, right: CGVector) -> CGVector {
        return CGVector(dx: left.dx - right.dx, dy: left.dy - right.dy)
    }
    
    var magnitude: CGFloat {
        return sqrt(pow(dx, 2) + pow(dy, 2))
    }
    
    func normalized() -> CGVector {
        let xAngle = acos(dx/magnitude)
        let yAngle = asin(dy/magnitude)
        let newX = cos(xAngle)
        let newY = sin(yAngle)
        return CGVector(dx: newX, dy: newY)
    }
    
    func toPoint() -> CGPoint {
        return CGPoint(x: dx, y: dy)
    }
    
    init(from initialPoint: CGPoint, to endPoint: CGPoint) {
        self.init()
        dx = endPoint.x - initialPoint.x
        dy = endPoint.y - initialPoint.y
    }
}
