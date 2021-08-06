//
//  File.swift
//  PhysicsEngine 2
//
//  Created by Owen Vnek on 11/28/15.
//  Copyright © 2015 Owen Vnek. All rights reserved.
//

import Foundation

class NioVector {
    
    var x: Double
    var y: Double
    
    init(x: Double, y: Double) {
        
        self.x = x
        self.y = y
        
    }
    
    convenience init() {
        
        self.init(x: 0, y: 0)
        
    }
}
