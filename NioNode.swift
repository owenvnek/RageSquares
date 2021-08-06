//
//  NioNode.swift
//  PhysicsEngine 2
//
//  Created by Owen Vnek on 11/28/15.
//  Copyright © 2015 Owen Vnek. All rights reserved.
//

import Foundation
import SpriteKit

public class NioNode: SKSpriteNode {
    
    var velocity: NioVector = NioVector()
    var gravity: Bool = false
    var mass: Double = 50
    var frictionConstant: Double = 0.35
    var bounceConstant: Double = 0.0
    var speedLimit = NioVector(x: 10, y: 500)
    var ref: NioReference = NioReference(name: "null name")
    var partitionPosition: NioPosition = NioPosition()
    var extendedPartitions: [NioPosition] = []
    var partRange = [NioPosition(x: 0, y: 0), NioPosition(x: 0, y: 0)]
    var movable: Bool = true
    var notes: String = ""
    var friction: Bool = true
    var stoppable: Bool = true;
    
    init(name: String, texture: SKTexture, size: CGSize) {
        
        super.init(texture: texture, color: UIColor.black, size: size)
        self.name = name
        self.ref = NioReference(name: name)
        
    }
    
    override convenience init(texture: SKTexture?, color: UIColor, size: CGSize) {
        
        self.init(name: "null", texture: texture!, size: size)
        
    }
    
    convenience init(name: String, imageDir: String) {
        
        let node = SKSpriteNode(imageNamed: imageDir)
        self.init(name: name, texture: NioUtilities.tempView.texture(from: node)!, size: node.size)
        
    }
    
    convenience init(name: String, size: CGSize, color: UIColor) {
        
        let node = SKShapeNode(rect: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        node.lineWidth = 0
        node.fillColor = color
        self.init(name: name, texture: NioUtilities.tempView.texture(from: node)!, size: size)
        
    }
    
    convenience init(name: String, radius: Int, color: UIColor) {
        
        let node = SKShapeNode(circleOfRadius: CGFloat(radius));
        node.lineWidth = 0;
        node.fillColor = color;
        self.init(name: name, texture: NioUtilities.tempView.texture(from: node)!, size: CGSize(width: radius * 2, height: radius * 2));
        
    }
    
    convenience init(name: String, text: String, textColor: UIColor, textFont: String, textSize: Double) {
        
        let node = SKLabelNode(text: text)
        node.fontColor = textColor
        node.fontName = textFont
        node.fontSize = CGFloat(textSize)
        let skNode = SKSpriteNode(texture: NioUtilities.tempView.texture(from: node)!)
        self.init(name: name, texture: NioUtilities.tempView.texture(from: skNode)!, size: skNode.size)
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func modifyPosition(x: Double, y: Double) {
        
        self.position.x = CGFloat(x)
        self.position.y = CGFloat(y)
        
    }
    /**
     static func createShapeNode(name: String, size: CGSize, color: UIColor) -> NioNode {
     
     let tempNode: SKShapeNode = SKShapeNode(rect: CGRect(x: 0, y: 0, width: size.width, height: size.height))
     
     tempNode.lineWidth = 0
     tempNode.fillColor = color
     let node = NioNode(texture: NioUtilities.tempView.textureFromNode(tempNode))
     node.name = name
     node.ref = NioReference(name: name)
     
     return node
     
     }
     
     static func createImageNode(name: String, image imageName: String) -> NioNode {
     
     let node = NioNode(imageNamed: imageName)
     node.ref = NioReference(name: name)
     node.name = name
     return node
     
     }
     
     static func createLabelNode(name: String, text: String, textColor: UIColor, textFont: String, textSize: Double) -> NioNode {
     
     let tempNode: SKLabelNode = SKLabelNode(text: text)
     
     tempNode.fontColor = textColor
     tempNode.fontName = textFont
     tempNode.fontSize = CGFloat(textSize)
     
     let node = NioNode(texture: NioUtilities.tempView.textureFromNode(tempNode))
     node.ref = NioReference(name: name)
     node.name = name
     
     return node
     
     }
     **/
}



