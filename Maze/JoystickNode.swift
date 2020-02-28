//
//  JoystickNode.swift
//  Maze
//
//  Created by Ethan Humphrey on 12/11/19.
//  Copyright © 2019 Ethan Humphrey. All rights reserved.
//

import SpriteKit

class JoystickNode: SKNode {
    
    weak var delegate: JoystickNodeDelegate?
    
    var mainStick: SKShapeNode!
    var outerRing: SKShapeNode!
    
    var isMoving = false
    fileprivate var initialPoint: CGPoint!
    
    let feedbackGenerator = UIImpactFeedbackGenerator()
    
    init(stickRadius: CGFloat = 35, movementRadius: CGFloat = 65, color: UIColor = .black) {
        super.init()
        self.isUserInteractionEnabled = true
        mainStick = SKShapeNode(circleOfRadius: stickRadius)
        mainStick.fillColor = color
        mainStick.strokeColor = color
        mainStick.zPosition = 10
        self.addChild(mainStick)
        
        outerRing = SKShapeNode(circleOfRadius: movementRadius)
        outerRing.fillColor = .clear
        outerRing.strokeColor = color
        outerRing.zPosition = 1
        self.addChild(outerRing)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let firstTouch = touches.first {
            if mainStick.contains(firstTouch.location(in: self)) {
                initialPoint = firstTouch.location(in: self)
                isMoving = true
            }
        }
    }
    var wasLastOnEdge = false
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isMoving {
            if let firstTouch = touches.first {
                let currentPoint = firstTouch.location(in: self)
                let dVector = CGVector(from: initialPoint, to: currentPoint)
                let dPoint = dVector.toPoint()
                
                let radius = outerRing.frame.height/2
                if outerRing.contains(dPoint) {
                    mainStick.position = dPoint
                    let newVector = (dVector.magnitude / radius) * dVector.normalized()
                    delegate?.positionChanged(newVector: newVector, for: self)
                    wasLastOnEdge = false
                }
                else {
                    if !wasLastOnEdge {
                        feedbackGenerator.impactOccurred()
                    }
                    wasLastOnEdge = true
                    mainStick.position = (radius * dVector.normalized()).toPoint()
                    delegate?.positionChanged(newVector: dVector.normalized(), for: self)
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        isMoving = false
        let moveAction = SKAction.move(to: CGPoint(x: 0, y: 0), duration: 0.075)
        mainStick.run(moveAction)
        wasLastOnEdge = false
        feedbackGenerator.impactOccurred()
        delegate?.positionChanged(newVector: .zero, for: self)
    }
}

protocol JoystickNodeDelegate: class {
    func positionChanged(newVector: CGVector, for joystick: JoystickNode)
}
