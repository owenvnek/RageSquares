//
//  NioUUID.swift
//  PhysicsEngine 2
//
//  Created by Owen Vnek on 11/28/15.
//  Copyright © 2015 Owen Vnek. All rights reserved.
//

import Foundation

class NioUUID {
    
    static var id: Int = 0
    
    static func getNewId() -> Int {
        
        let result: Int = self.id
        
        self.id += 1
        return result
        
    }
    
}
