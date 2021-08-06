//
//  NioArea.swift
//  Kaland
//
//  Created by Owen Vnek on 1/9/16.
//  Copyright © 2016 Owen Vnek. All rights reserved.
//

import Foundation

class NioArea {
    
    var pos1: NioPosition
    var pos2: NioPosition
    
    init(pos1: NioPosition, pos2: NioPosition) {
        
        self.pos1 = pos1
        self.pos2 = pos2
        refine()
        
    }
    
    func refine() {
        
        pos1.x = NioUtilities.getLesser(num1: pos1.x, num2: pos2.x)
        pos1.y = NioUtilities.getLesser(num1: pos1.y, num2: pos2.y)
        pos2.x = NioUtilities.getGreater(num1: pos1.x, num2: pos2.x)
        pos2.y = NioUtilities.getGreater(num1: pos1.y, num2: pos2.y)
        
    }
    
}
