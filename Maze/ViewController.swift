//
//  ViewController.swift
//  Maze
//
//  Created by Ethan Humphrey on 12/10/19.
//  Copyright © 2019 Ethan Humphrey. All rights reserved.
//

import UIKit
import SpriteKit

class ViewController: UIViewController {

    @IBOutlet weak var sceneView: SKView!
    @IBOutlet weak var mazeImage: UIImageView!
    var gameScene: GameScene!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor(cgColor: UIColor.systemBackground.cgColor)
        if traitCollection.userInterfaceStyle == .dark {
            invertImage()
        }
        gameScene = GameScene(size: sceneView.bounds.size)
        gameScene.mazeImageView = mazeImage
        gameScene.mainView = self
        sceneView.allowsTransparency = true
//        sceneView.backgroundColor = .clear
        sceneView.isOpaque = false
        sceneView.presentScene(gameScene)
        randomizeMaze()
    }
    
    func randomizeMaze() {
        let mazeNumber = Int.random(in: 1...50)
        gameScene.mazeImageView.image = UIImage(named: "20 by 20 orthogonal maze-\(mazeNumber)")
        if traitCollection.userInterfaceStyle == .dark {
            invertImage()
        }
    }
    
    func invertImage() {
        let beginImage = CIImage(image: mazeImage!.image!)
        if let filter = CIFilter(name: "CIColorInvert") {
            if beginImage != nil {
                filter.setValue(beginImage, forKey: kCIInputImageKey)
                let newImage = UIImage(ciImage: filter.outputImage!)
                mazeImage!.image = newImage
            }
            else {
                filter.setValue(nil, forKey: kCIInputImageKey)
                let newImage = UIImage(ciImage: filter.outputImage!)
                mazeImage!.image = newImage
            }
        }
    }


}

