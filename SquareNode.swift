//
//  Enemy.swift
//  Rage Squares
//
//  Created by Owen Vnek on 3/23/17.
//  Copyright © 2017 Pullus. All rights reserved.
//

import SpriteKit

class SquareNode: NioNode {
    
    private var squareType: SquareType!
    
    public init(size: CGSize, squareType: SquareType) {
        self.squareType = squareType
        super.init(name: squareType.name, texture: SquareNode.createTexture(size: size, color: squareType.color), size: size)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func getSquareType() -> SquareType {
        return squareType
    }
    
    static func createTexture(size: CGSize, color: UIColor) -> SKTexture {
        let node = SKShapeNode(rect: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        node.lineWidth = 0
        node.fillColor = color
        return NioUtilities.tempView.texture(from: node)!
    }
    
    enum SquareType {
        
        case BOOST
        case EVIL
        case SHIELD
        case TRACKER
        
        init() {
            let randomNum: Int
            randomNum = Int(arc4random_uniform(30))
            if randomNum <= 2 {
                self = .BOOST
            } else if randomNum == 3 {
                self = .SHIELD
            } else if randomNum == 4 {
                self = .TRACKER
            } else {
                self = .EVIL
            }
        }
        
        var name: String {
            get {
                var name: String
                name = ""
                switch self {
                case .BOOST:
                    name = "boost"
                case .EVIL:
                    name = "evil"
                case .SHIELD:
                    name = "shield"
                case .TRACKER:
                    name = "tracker"
                }
                return name
            }
        }
        
        var color: UIColor {
            get {
                var color: UIColor
                color = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                switch self {
                case .BOOST:
                    color = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
                case .EVIL:
                    color = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
                case .SHIELD:
                    color = #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)
                case .TRACKER:
                    color = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
                }
                return color
            }
            
        }
        
    }
    
}
