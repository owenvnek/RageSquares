//
//  NioReference.swift
//  Kaland
//
//  Created by Owen Vnek on 12/24/15.
//  Copyright © 2015 Owen Vnek. All rights reserved.
//

import Foundation

class NioReference: Hashable {
    
    var id: Int
    var name: String
    
    var hashValue: Int {
        
        get {
            
            return self.getCompiledRef().hashValue
            
        }
        
    }
    
    static var catalogue: [Int: String] = [:]
    
    init(name: String) {
        
        id = NioUUID.getNewId()
        self.name = name
        
    }
    
    func compare(ref: NioReference) -> Bool {
        
        return ref.name == self.name && ref.id == self.id
        
    }
    
    func getCompiledRef() -> String {
        
        return "\(self.name)\(self.id)"
        
    }
    
}

func ==(lsh: NioReference, rsh: NioReference) -> Bool {
    
    return lsh.hashValue == rsh.hashValue
    
}