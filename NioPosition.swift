//
//  NioPosition.swift
//  PhysicsEngine 2
//
//  Created by Owen Vnek on 11/28/15.
//  Copyright © 2015 Owen Vnek. All rights reserved.
//

import Foundation

public class NioPosition {
    
    var x: Double
    var y: Double
    
    init(x: Double, y: Double) {
        
        self.x = x
        self.y = y
        
    }
    
    convenience init(x: Int, y: Int) {
        
        self.init(x: Double(x), y: Double(y))
        
    }
    
    convenience init() {
        
        self.init(x: 0, y: 0)
        
    }
    
}

func ==(lsh: NioPosition, rsh: NioPosition) -> Bool {
    
    return lsh.x == rsh.x && lsh.y == rsh.y
    
}