//
//  NioCollisionPartition.swift
//  PhysicsEngine 2
//
//  Created by Owen Vnek on 11/28/15.
//  Copyright © 2015 Owen Vnek. All rights reserved.
//

import Foundation
import SpriteKit

public class NioCollisionPartition {
    
    var partitions: [Int: [Int: Partition]] = [:]
    let partitionSizeConstant: Int = 100
    
    func convertNodeToParts(node: NioNode) -> (NioPosition, NioPosition) {
        
        var xLowCheck = node.frame.minX
        var xHighCheck = node.frame.maxX
        var yLowCheck = node.frame.minY
        var yHighCheck = node.frame.maxY
        
        if node.velocity.x > 0 {
            
            xHighCheck += CGFloat(node.velocity.x)
            
        } else if node.velocity.x < 0 {
            
            xLowCheck += CGFloat(node.velocity.x)
            
        }
        
        if node.velocity.y > 0 {
            
            yHighCheck += CGFloat(node.velocity.y)
            
        } else if node.velocity.y < 0 {
            
            yLowCheck += CGFloat(node.velocity.y)
            
        }
        
        return (NioCollisionPartition.convertPosToPart(pos: NioPosition(x: Double(xLowCheck), y: Double(yLowCheck)), part: self),                                                                   NioCollisionPartition.convertPosToPart(pos: NioPosition(x: Double(xHighCheck), y: Double(yHighCheck)), part: self))
        
    }
    
    func addToPartition(node: NioNode) {
        
        node.partitionPosition = NioPosition(x: Int(node.position.x) / partitionSizeConstant, y: Int(node.position.y) / partitionSizeConstant)
        
        let parts = convertNodeToParts(node: node)
        
        node.partRange[0] = parts.0
        node.partRange[1] = parts.1
        for partX in Int(parts.0.x)...Int(parts.1.x) {
            for partY in Int(parts.0.y)...Int(parts.1.y) {
                if let _ = partitions[partX] {} else {
                    
                    partitions[partX] = [Int: Partition]()
                    
                }
                
                if let _ = partitions[partX]![partY] {} else {
                    
                    partitions[partX]![partY] = Partition(position: NioPosition(x: Double(partX), y: Double(partY)))
                    
                }
                
                partitions[partX]![partY]!.nodes[node.ref] = node
                node.extendedPartitions.append(NioPosition(x: Double(partX), y: Double(partY)))
            }
            
        }
        
    }
    
    func removeFromPartition(node node: NioNode) {
        
        for part in node.extendedPartitions {
            
            if let _ = partitions[Int(part.x)] {
                
                if let _ = partitions[Int(part.x)]![Int(part.y)] {
                    
                    partitions[Int(part.x)]![Int(part.y)]!.nodes.removeValue(forKey: node.ref)
                    
                }
                
            }
            
        }
        
        node.extendedPartitions = []
        
    }
    
    func updateNodePartition(node node: NioNode) {
        
        let potentialParts = convertNodeToParts(node: node)
        
        if !(potentialParts.0 == node.partRange[0] && potentialParts.1 == node.partRange[1]) {
            
            removeFromPartition(node: node)
            addToPartition(node: node)
            cleanUpPartition()
            
        }
        
    }
    
    func cleanUpPartition() {
        
        for partXIndex in partitions.keys {
            
            for partYIndex in partitions[partXIndex]!.keys {
                
                if partitions[partXIndex]![partYIndex]!.nodes.count == 0 {
                    
                    partitions[partXIndex]!.removeValue(forKey: partYIndex)
                    
                }
                
            }
            
            if partitions[partXIndex]!.count == 0 {
                
                partitions.removeValue(forKey: partXIndex)
                
            }
            
        }
        
    }
    
    func getNodesFromArea(pos1: NioPosition, pos2: NioPosition) -> [NioNode] {
        
        let allignedX1 = NioUtilities.getLesser(num1: pos1.x, num2: pos2.x)
        let allignedY1 = NioUtilities.getLesser(num1: pos1.y, num2: pos2.y)
        let allignedX2 = NioUtilities.getGreater(num1: pos1.x, num2: pos2.x)
        let allignedY2 = NioUtilities.getGreater(num1: pos1.y, num2: pos2.y)
        
        var nodes: [NioNode] = []
        let pos1Part = NioCollisionPartition.convertPosToPart(pos: NioPosition(x: allignedX1, y: allignedY1), part: self)
        let pos2Part = NioCollisionPartition.convertPosToPart(pos: NioPosition(x: allignedX2, y: allignedY2), part: self)
        var partX = pos1Part.x
        while partX <= pos2Part.x {
            var partY = pos1Part.y
            while partY <= pos2Part.y {
                
                if let _ = partitions[Int(partX)] {
                    
                    if let _ = partitions[Int(partX)]![Int(partY)] {
                        
                        for node in partitions[Int(partX)]![Int(partY)]!.nodes {
                            
                            if Double(node.1.frame.maxX) > allignedX1 && Double(node.1.frame.minX) < allignedX2 && Double(node.1.frame.maxY) > allignedY1 && Double(node.1.frame.minY) < allignedY2 {
                                
                                var dupe = false
                                
                                for foundNode in nodes {
                                    
                                    if foundNode.ref.getCompiledRef() == node.1.ref.getCompiledRef() {
                                        
                                        dupe = true
                                        
                                    }
                                    
                                }
                                
                                if !dupe {
                                    
                                    nodes.append(node.1)
                                    
                                }
                                
                            }
                            
                        }
                        
                    }
                    
                }
                partY += 1
            }
            partX += 1
        }
        
        return nodes
        
    }
    
    public static func convertPosToPart(pos: NioPosition, part: NioCollisionPartition) -> NioPosition {
        
        let newPos = NioPosition()
        
        newPos.x = Double(Int(pos.x) / part.partitionSizeConstant)
        newPos.y = Double(Int(pos.y) / part.partitionSizeConstant)
        
        return newPos
        
    }
    
    class Partition {
        
        var position: NioPosition
        var nodes: [NioReference: NioNode] = [:]
        
        init(position: NioPosition) {
            
            self.position = position
            
        }
        
    }
    
}
