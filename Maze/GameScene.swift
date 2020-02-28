//
//  GameScene.swift
//  Maze
//
//  Created by Ethan Humphrey on 12/10/19.
//  Copyright © 2019 Ethan Humphrey. All rights reserved.
//

/*
    Hello and welcome to my maze. Mine is very different from others' in the sense that I added a joystick!
    To accomplish this, I made my own custom SKNode. I used one shape node as the inside "stick" and another shape node as the movement circle.
    Moving your finger while touching the stick moves the stick, but it checks that it's always in the outer ring.
    The joystick sends a delegate call back with a vector of the direction the stick is pointed.
    The magnitude of the vector is 1 when the stick is at it's furthest position.
    The joystick is my favorite addition and I wrote it in such a way that I can just take that file and move it to future projects.
    I also added haptic feedback to the joystick (fun!)
    
    I also enabled dark mode in my game (but it won't change mid game cuz hard (also changing it actually makes you not able to move lol))
 
    There are 50 different mazes I took from mazegenerator.net that randomize.
    There is an easter egg where if you try to get out the top of the maze, you can re randomize the maze.
 
    Collision works by checking the color of pixels in a cross shape.
    It returns which side(s) it detects the walls on and then prevents from moving in that direction.
    This lets the player still move along walls with the joystick instead of being stopped when touching a wall with the only option being moving directly away from the wall.
    
    The timer works as you would expect.
 
    Finally, you win by getting to the end of the maze and attempting to escape, and you can then tap to play again.
 
    Only bugs I've noticed is switching dark mode mid game, everything else should work fine.
*/

import UIKit
import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate, JoystickNodeDelegate {
    
    var mazeImageView: UIImageView!
    var mainView: ViewController!
    
    var player: SKShapeNode!
    let playerSize: CGFloat = 5.0
    
    var joystick: JoystickNode!
    
    let movementSpeed: CGFloat = 50.0
    
    var initialTime: TimeInterval = 0
    var lastFrameTime: TimeInterval = 0
    
    var isGameActive = true
    var isGameStarted = false
    
    var roundStartTime: TimeInterval = 0
    
    var timerLabel: SKLabelNode!
    var congratsLabel: SKLabelNode!
    
    let timeFormatter = DateFormatter()
    
    override func didMove(to view: SKView) {
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        physicsWorld.contactDelegate = self
        
        self.backgroundColor = .clear
        joystick = JoystickNode(stickRadius: 35, movementRadius: 65, color: .label)
        joystick.position = CGPoint(x: 0, y: -(self.frame.height + self.frame.width)/4)
        joystick.delegate = self
        addChild(joystick)
        
        player = SKShapeNode(rect: CGRect(x: 0, y: 0, width: playerSize, height: playerSize))
        player.fillColor = .label
        player.strokeColor = .label
        player.physicsBody = SKPhysicsBody(rectangleOf: player.frame.size)
        player.physicsBody?.affectedByGravity = false
        player.position = CGPoint(x: -12, y: self.frame.width/2 - 20)
        addChild(player)
        
        timerLabel = SKLabelNode()
        timerLabel.horizontalAlignmentMode = .left
        timerLabel.fontColor = .label
        addChild(timerLabel)
        timerLabel.position = CGPoint(x: -self.size.width/2 + 20, y: self.size.height/2 - 80)
        timerLabel.attributedText = getLabelFormattedText("Time: 0:00.00")
        
        timeFormatter.dateFormat = "m:ss.SS"
        
        congratsLabel = SKLabelNode()
        congratsLabel.horizontalAlignmentMode = .center
        congratsLabel.fontColor = .label
        addChild(congratsLabel)
        congratsLabel.position = CGPoint(x: 0, y: self.size.height/2 - 175)
        congratsLabel.isHidden = true
        congratsLabel.attributedText = getLabelFormattedText("Congrats!\nTap to Play Again")
        congratsLabel.numberOfLines = 2
    }
    
    override func update(_ currentTime: TimeInterval) {
        if initialTime == 0 {
            initialTime = currentTime
            lastFrameTime = initialTime
        }
        if isGameActive {
            if isGameStarted {
                let date = Date(timeIntervalSince1970: currentTime - roundStartTime)
                timerLabel.attributedText = getLabelFormattedText("Time: \(timeFormatter.string(from: date))")
                if currentTime - initialTime > 1 {
                    let point = mainView.view.convert(convertPoint(toView: player.position), to: mazeImageView.coordinateSpace)
                    let size: CGFloat = 7
                    let detectionFrame = CGRect(x: point.x - ((size - playerSize)/2), y: point.y-playerSize - ((size - playerSize)/2), width: size, height: size)
                    
                    let directionArray = mazeImageView.getWallDirection(in: detectionFrame)
                    for direction in directionArray {
                        switch direction {
                        case .top:
                            if player.physicsBody!.velocity.dy > 0 {
                                player.physicsBody?.velocity.dy = 0
                            }
                        case .bottom:
                            if player.physicsBody!.velocity.dy < 0 {
                                player.physicsBody?.velocity.dy = 0
                            }
                        case .left:
                            if player.physicsBody!.velocity.dx > 0 {
                                player.physicsBody?.velocity.dx = 0
                            }
                        case .right:
                            if player.physicsBody!.velocity.dx < 0 {
                                player.physicsBody?.velocity.dx = 0
                            }
                        default:
                            break
                        }
                    }
                    if player.position.y >= (mazeImageView.frame.width/2 - 10) && player.physicsBody!.velocity.dy > 0 {
                        timerLabel.attributedText = getLabelFormattedText("Time: 0:00.00")
                        isGameActive = false
                        isGameStarted = false
                        congratsLabel.attributedText = getLabelFormattedText("Tap to Randomize")
                        congratsLabel.isHidden = false
                    }
                    if player.position.y <= -(mazeImageView.frame.width/2 + 5) && player.physicsBody!.velocity.dy < 0 {
                        gameOver()
                    }
                }
            }
        }
        else {
            player.physicsBody?.velocity = .zero
        }
        lastFrameTime = currentTime
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !isGameActive && !isGameStarted {
            isGameActive = true
            player.position = CGPoint(x: -12, y: self.frame.width/2 - 20)
            mainView.randomizeMaze()
            timerLabel.attributedText = getLabelFormattedText("Time: 0:00:00")
            congratsLabel.isHidden = true
        }
    }
    
    func gameOver() {
        isGameActive = false
        isGameStarted = false
        congratsLabel.isHidden = false
        congratsLabel.attributedText = getLabelFormattedText("Congrats!\nTap to Play Again")
    }
    
    func positionChanged(newVector: CGVector, for joystick: JoystickNode) {
        if isGameActive {
            if newVector == .zero {
                player.physicsBody?.velocity = .zero
            }
            else {
                player.physicsBody?.velocity = movementSpeed * newVector
            }
            if !isGameStarted {
                isGameStarted = true
                roundStartTime = lastFrameTime
            }
        }
    }
    
    func getLabelFormattedText(_ originalString: String) -> NSAttributedString {
        let attrString = NSMutableAttributedString(string: originalString)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let range = NSRange(location: 0, length: originalString.count)
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: range)
        attrString.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.label, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 30)], range: range)
        return attrString
    }
}
