//
//  NioUtilities.swift
//  PhysicsEngine 2
//
//  Created by Owen Vnek on 11/28/15.
//  Copyright © 2015 Owen Vnek. All rights reserved.
//

import Foundation
import SpriteKit

class NioUtilities {
    
    static let mundaneNode = NioNode(name: "bob", size: CGSize(width: 1, height: 1), color: UIColor.black)
    static let tempView = SKView()
    static let pi = 3.1415
    static let referenceNode = NioNode(name: "bob", size: CGSize(width: 1, height: 1), color: UIColor.black)
    
    static func getRefWall1() -> NioNode {
        
        let node = NioNode(name: "wall", imageDir: "stonebrickx1x1")
        node.xScale = 2
        node.yScale = 2
        
        return node
        
    }
    
    static func getRefWall2() -> NioNode {
        
        let node = NioNode(name: "wall", imageDir: "stonebrickx10x1")
        node.xScale = 2
        node.yScale = 2
        
        return node
        
    }
    
    
    static func doNodesOverlap(node node: NioNode, node2: NioNode) -> Bool {
        
        var result: Bool = false
        
        if node.frame.maxY >= node2.frame.minY &&
            node.frame.minX <= node2.frame.maxX &&
            node.frame.maxX >= node2.frame.minX &&
            node.frame.maxY >= node2.frame.minY {
            
            result = true
            
        }
        
        return result
        
    }
    
    static func binaryReduce(input: Double) -> Int {
        
        if input > 0 { return 1 }
        if input < 0 { return -1}
        if input == 0 { return 0 }
        
        return 0
        
    }
    
    static func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
        
    }
    
    static func getReferencePlatformH() -> NioNode {
        
        let node = NioNode(name: "platf", imageDir: "stonebrickx10x1")
        node.xScale = 2
        node.yScale = 2
        return node
        
    }
    
    static func getReferencePlatformV() -> NioNode {
        
        let node = NioNode(name: "platf", imageDir: "stonebrickx1x10")
        node.xScale = 2
        node.yScale = 2
        return node
        
    }
    
    static func getReferenceBG() -> NioNode {
        
        let node = NioNode(name: "background", imageDir: "background")
        node.xScale = 3.5
        node.yScale = 3.5
        return node
        
    }
    
    static func difference(num1: Double, num2: Double) -> Double {
        
        return abs(num1 - num2)
        
    }
    
    static func getGreater(num1: Double, num2: Double) -> Double {
        
        if num1 > num2 {
            
            return num1
            
        } else if num2 > num1 {
            
            return num2
            
        } else {
            
            return num1
            
        }
        
    }
    
    static func getLesser(num1: Double, num2: Double) -> Double {
        
        if num1 < num2 {
            
            return num1
            
        } else if num2 < num1 {
            
            return num2
            
        } else {
            
            return num1
            
        }
        
    }
    
    static func getLesser(nums: [Double]) -> Double {
        
        var least = nums[0]
        
        for num in nums {
            
            if num < least {
                
                least = num
                
            }
            
        }
        
        return least
        
    }
    
    static func getGreater(nums: [Double]) -> Double {
        
        var greatest = nums[0]
        
        for num in nums {
            
            if num > greatest {
                
                greatest = num
                
            }
            
        }
        
        return greatest
        
    }
    
    
    
}
