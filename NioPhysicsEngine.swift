//
//  NioPhysicsEngine.swift
//  PhysicsEngine 2
//
//  Created by Owen Vnek on 11/28/15.
//  Copyright © 2015 Owen Vnek. All rights reserved.
//

import Foundation
import SpriteKit

public class NioPhysicsEngine {
    
    let gravitationalConstant: Double = 1.0
    let airResistanceConstant: Double = 0.01
    var collisionListener: [NioListenerItem] = []
    var gravityEnabled: Bool = true
    var physicsNodes: [NioReference: NioNode] = [:]
    var collisionPartition: NioCollisionPartition = NioCollisionPartition();
    
    func tick(size: CGSize) {
        
        for node in physicsNodes {
            
            if node.1.movable {
                
                if gravityEnabled && node.1.gravity { doGravity(node: node.1) }
                doDrag(node: node.1)
                doMoveNode(node: node.1)
                
            }
            
            let x = Int(node.1.position.x)
            let y = Int(node.1.position.y)
        
            if x < -100 || y < -100 || x > Int(size.width) + 100 || y > Int(size.height) + 100 {
                node.1.removeFromParent()
                collisionPartition.removeFromPartition(node: node.1)
                physicsNodes.removeValue(forKey: node.0)
            }
            
            
        }
 
    }
    
    public func reset() {
        
        for node in physicsNodes {
            if node.1.name != "player" {
                node.1.removeFromParent()
                collisionPartition.removeFromPartition(node: node.1);
            }
        }
        physicsNodes = [:]

    }
    
    func doGravity(node: NioNode) {
        
        let collision = collisionCalculation(direction: Direction.south, node: node)
        
        if collision.0 > 0 {
            
            node.velocity.y = node.velocity.y - gravitationalConstant
            
        } else {
            
            collisionListener.append(NioListenerItem(item1: node.ref, item2: collision.1.ref, direction: Direction.south))
            
        }
        
    }
    
    func doDrag(node: NioNode) {
        
        if node.stoppable {
            if node.velocity.x > 0 {
                
                if abs(node.velocity.x) > airResistanceConstant {
                    
                    accelerateNode(node: node, vector: NioVector(x: -airResistanceConstant, y: 0))
                    
                } else {
                    
                    node.velocity.x = 0
                    
                }
                
            } else if node.velocity.x < 0 {
                
                if abs(node.velocity.x) > airResistanceConstant {
                    
                    accelerateNode(node: node, vector: NioVector(x: airResistanceConstant, y: 0))
                    
                } else {
                    
                    node.velocity.x = 0
                    
                }
                
            }
            
            if node.velocity.y > 0 {
                
                if abs(node.velocity.y) > airResistanceConstant {
                    
                    accelerateNode(node: node, vector: NioVector(x: 0, y: -airResistanceConstant))
                    
                } else {
                    
                    node.velocity.y = 0
                    
                }
                
            } else if node.velocity.y < 0 {
                
                if abs(node.velocity.y) > airResistanceConstant {
                    
                    accelerateNode(node: node, vector: NioVector(x: 0, y: airResistanceConstant))
                    
                } else {
                    
                    node.velocity.y = 0
                    
                }
                
            }
        }
        
        
    }
    
    func accelerateNode(node: NioNode, vector: NioVector) {
        
        if vector.x != 0 {
            
            if (vector.x > 0 && node.velocity.x < 0 && vector.x + node.velocity.x < Double(node.speedLimit.x)) || (vector.x < 0 && node.velocity.x > 0 && vector.x + node.velocity.x > Double(-node.speedLimit.x)) {
                
                node.velocity.x += vector.x
                
            } else if (node.velocity.x + vector.x < Double(node.speedLimit.x) && node.velocity.x + vector.x > Double(-node.speedLimit.x)) {
                
                node.velocity.x += vector.x
                
            }
                
            else {
                
                node.velocity.x = node.speedLimit.x * Double(NioUtilities.binaryReduce(input: vector.x))
                
            }
            
        }
        
        if vector.y != 0 {
            
            if (vector.y > 0 && node.velocity.y < 0 && vector.y + node.velocity.y < Double(node.speedLimit.y)) || (vector.y < 0 && node.velocity.y > 0 && vector.y + node.velocity.y > Double(-node.speedLimit.y)) {
                
                node.velocity.y += vector.y
                
            } else if (node.velocity.y + vector.y < Double(node.speedLimit.y) && node.velocity.y + vector.y > Double(-node.speedLimit.y)) {
                
                node.velocity.y += vector.y
                
            }
                
            else {
                
                node.velocity.y = node.speedLimit.y * Double(NioUtilities.binaryReduce(input: vector.y))
                
            }
            
        }
        
    }
    
    func doMoveNode(node: NioNode) {
        
        let posX = node.position.x;
        let posY = node.position.y;
        let velX = node.velocity.x;
        let velY = node.velocity.y;
        
        let collisionDetectionEast: (Double, NioNode) = collisionCalculation(direction: Direction.east, node: node)
        let collisionDetectionWest: (Double, NioNode) = collisionCalculation(direction: Direction.west, node: node)
        let collisionDetectionNorth: (Double, NioNode) = collisionCalculation(direction: Direction.north, node: node)
        let collisionDetectionSouth: (Double, NioNode) = collisionCalculation(direction: Direction.south, node: node)
        
        if node.velocity.x > 0 {
            
            let canMoveRight: Double = collisionDetectionEast.0
            
            if canMoveRight > 0 {
                
                let doFrictionSouth: Bool = abs(node.velocity.x) > collisionDetectionSouth.1.frictionConstant * node.mass * 0.005
                let doFrictionNorth: Bool = abs(node.velocity.x) > collisionDetectionNorth.1.frictionConstant * node.mass * 0.005
                
                if node.friction {
                    
                    if doFrictionSouth && collisionDetectionSouth.0 < 1 {
                        
                        accelerateNode(node: node, vector: NioVector(x: -(collisionDetectionSouth.1.frictionConstant * node.mass * 0.005), y: 0))
                        
                    } else if collisionDetectionSouth.0 < 1 {
                        
                        node.velocity.x = 0
                        
                    }
                    
                    if doFrictionNorth && collisionDetectionNorth.0 < 1 {
                        
                        accelerateNode(node: node, vector: NioVector(x: -(collisionDetectionNorth.1.frictionConstant * node.mass * 0.005), y: 0))
                        
                    } else if collisionDetectionNorth.0 < 1 {
                        
                        node.velocity.x = 0
                        
                    }
                    
                }
                
                if canMoveRight < abs(node.velocity.x) {
                    
                    node.modifyPosition(x: Double(node.position.x) + canMoveRight, y: Double(node.position.y))
                    collisionListener.append(NioListenerItem(item1: node.ref, item2: collisionDetectionEast.1.ref, direction: Direction.east))
                    
                } else {
                    
                    node.modifyPosition(x: Double(node.position.x) + node.velocity.x, y: Double(node.position.y))
                    
                }
                
            } else {
                
                node.velocity.x = 0
                
                collisionListener.append(NioListenerItem(item1: node.ref, item2: collisionDetectionEast.1.ref, direction: Direction.east))
                
            }
            
        }
        
        if node.velocity.x < 0 {
            
            let canMoveLeft: Double = collisionDetectionWest.0
            
            if canMoveLeft > 0 {
                
                let doFrictionSouth: Bool = abs(node.velocity.x) > collisionDetectionSouth.1.frictionConstant * node.mass * 0.005
                let doFrictionNorth: Bool = abs(node.velocity.x) > collisionDetectionNorth.1.frictionConstant * node.mass * 0.005
                
                if node.friction {
                    
                    if doFrictionSouth && collisionDetectionSouth.0 < 1 {
                        
                        accelerateNode(node: node, vector: NioVector(x: (collisionDetectionSouth.1.frictionConstant * node.mass * 0.005), y: 0))
                        
                    } else if collisionDetectionSouth.0 < 1 {
                        
                        node.velocity.x = 0
                        
                    }
                    
                    if doFrictionNorth && collisionDetectionNorth.0 < 1 {
                        
                        accelerateNode(node: node, vector: NioVector(x: (collisionDetectionNorth.1.frictionConstant * node.mass * 0.005), y: 0))
                        
                    } else if collisionDetectionNorth.0 < 1 {
                        
                        node.velocity.x = 0
                        
                    }
                    
                }
                
                if canMoveLeft < abs(node.velocity.x) {
                    
                    node.modifyPosition(x: Double(node.position.x) - canMoveLeft, y: Double(node.position.y))
                    collisionListener.append(NioListenerItem(item1: node.ref, item2: collisionDetectionWest.1.ref, direction: Direction.west))
                    
                } else {
                    
                    node.modifyPosition(x: Double(node.position.x) + node.velocity.x, y: Double(node.position.y))
                    
                }
                
            } else {
                
                node.velocity.x = 0
                
                collisionListener.append(NioListenerItem(item1: node.ref, item2: collisionDetectionWest.1.ref, direction: Direction.west))
                
            }
            
            
        }
        
        if node.velocity.y > 0 {
            
            let canMoveUp: Double = collisionDetectionNorth.0
            
            if canMoveUp > 0 {
                
                let doFrictionWest: Bool = abs(node.velocity.y) > collisionDetectionWest.1.frictionConstant * node.mass * 0.005
                let doFrictionEast: Bool = abs(node.velocity.y) > collisionDetectionEast.1.frictionConstant * node.mass * 0.005
                
                if node.friction {
                    
                    if  doFrictionWest && collisionDetectionWest.0 < 1 {
                        
                        accelerateNode(node: node, vector: NioVector(x: 0, y: -(collisionDetectionWest.1.frictionConstant * node.mass * 0.005)))
                        
                    } else if collisionDetectionWest.0 < 1 {
                        
                        node.velocity.y = 0
                        
                    }
                    
                    if doFrictionEast && collisionDetectionEast.0 < 1 {
                        
                        accelerateNode(node: node, vector: NioVector(x: 0, y: -(collisionDetectionEast.1.frictionConstant * node.mass * 0.005)))
                        
                    } else if collisionDetectionEast.0 < 1 {
                        
                        node.velocity.y = 0
                        
                    }
                    
                }
                
                if canMoveUp < abs(node.velocity.y) {
                    
                    node.modifyPosition(x: Double(node.position.x), y: Double(node.position.y) + canMoveUp)
                    collisionListener.append(NioListenerItem(item1: node.ref, item2: collisionDetectionNorth.1.ref, direction: Direction.north))
                    
                } else {
                    
                    node.modifyPosition(x: Double(node.position.x), y: Double(node.position.y) + node.velocity.y)
                    
                }
                
            } else {
                
                node.velocity.y = 0
                
                collisionListener.append(NioListenerItem(item1: node.ref, item2: collisionDetectionNorth.1.ref, direction: Direction.north))
                
            }
            
        }
        
        if node.velocity.y < 0 {
            
            let canMoveDown: Double = collisionDetectionSouth.0
            
            if canMoveDown > 0 {
                
                let doFrictionWest: Bool = abs(node.velocity.y) > collisionDetectionWest.1.frictionConstant * node.mass * 0.005
                let doFrictionEast: Bool = abs(node.velocity.y) > collisionDetectionEast.1.frictionConstant * node.mass * 0.005
                
                if node.friction {
                    
                    if doFrictionWest && collisionDetectionWest.0 < 1 {
                        
                        accelerateNode(node: node, vector: NioVector(x: 0, y: collisionDetectionWest.1.frictionConstant * node.mass * 0.005))
                        
                    } else if collisionDetectionWest.0 < 1 {
                        
                        node.velocity.y = 0
                        
                    }
                    
                    if doFrictionEast && collisionDetectionEast.0 < 1 {
                        
                        accelerateNode(node: node, vector: NioVector(x: 0, y: collisionDetectionEast.1.frictionConstant * node.mass * 0.005))
                        
                    } else if collisionDetectionEast.0 < 1 {
                        
                        node.velocity.y = 0
                        
                    }
                    
                }
                
                if canMoveDown < abs(node.velocity.y) {
                    
                    node.modifyPosition(x: Double(node.position.x), y: Double(node.position.y) - canMoveDown)
                    collisionListener.append(NioListenerItem(item1: node.ref, item2: collisionDetectionSouth.1.ref, direction: Direction.south))
                    
                } else {
                    
                    node.modifyPosition(x: Double(node.position.x), y: Double(node.position.y) + node.velocity.y)
                    
                }
                
            } else {
                
                collisionListener.append(NioListenerItem(item1: node.ref, item2: collisionDetectionSouth.1.ref, direction: Direction.south))
                
                node.velocity.y = 0
                
            }
            
        }
        
        if !node.stoppable {
            node.velocity.x = velX;
            node.velocity.y = velY;
            node.position.x = posX + CGFloat(node.velocity.x)
            node.position.y = posY + CGFloat(node.velocity.y)
        }
        
        collisionPartition.updateNodePartition(node: node)
        
    }
    
    func collisionCalculation(direction direction: Direction, node: NioNode) -> (Double, NioNode) {
        
        var moveQuantities: [Direction: [(Double, NioNode)]] = [:]
        var decidingQuantities: [Direction: (Double, NioNode)] = [:]
        let tempNode: NioNode = NioUtilities.mundaneNode
        
        moveQuantities[Direction.north] = []
        moveQuantities[Direction.south] = []
        moveQuantities[Direction.west] = []
        moveQuantities[Direction.east] = []
        
        tempNode.frictionConstant = 0
        tempNode.bounceConstant = 0
        
        decidingQuantities[Direction.north] = (Double(collisionPartition.partitionSizeConstant), tempNode)
        decidingQuantities[Direction.south] = (Double(collisionPartition.partitionSizeConstant), tempNode)
        decidingQuantities[Direction.east] = (Double(collisionPartition.partitionSizeConstant), tempNode)
        decidingQuantities[Direction.west] = (Double(collisionPartition.partitionSizeConstant), tempNode)
        
        let parts = collisionPartition.convertNodeToParts(node: node)
        var xPos = parts.0.x
        while xPos <= parts.1.x {
                var yPos = parts.0.y
                while yPos <= parts.1.y {
                        
                        let targetPartitionPosition: NioPosition = NioPosition(x: xPos, y: yPos)
                        
                        if let _ = collisionPartition.partitions[Int(targetPartitionPosition.x)] {
                            
                            if let _ = collisionPartition.partitions[Int(targetPartitionPosition.x)]![Int(targetPartitionPosition.y)] {
                                
                                for otherNode in collisionPartition.partitions[Int(targetPartitionPosition.x)]![Int(targetPartitionPosition.y)]!.nodes {
                                    
                                    let node2 = otherNode.1
                                    
                                    if node2.ref != node.ref {
                                        
                                        if direction == Direction.north {
                                            
                                            if  node.frame.midY < node2.frame.minY &&
                                                node.frame.maxX > node2.frame.minX &&
                                                node.frame.minX < node2.frame.maxX {
                                                
                                                moveQuantities[Direction.north]!.append((Double(-node.frame.maxY + (node2.frame.minY)), node2))
                                                
                                            }
                                            
                                        }
                                        
                                        if direction == Direction.south {
                                            
                                            if  node.frame.midY > node2.frame.maxY &&
                                                node.frame.maxX > node2.frame.minX &&
                                                node.frame.minX < node2.frame.maxX {
                                                
                                                moveQuantities[Direction.south]!.append((Double(node.frame.minY - (node2.frame.maxY)), node2))
                                                
                                            }
                                            
                                        }
                                        
                                        if direction == Direction.west {
                                            
                                            if node.frame.minY < node2.frame.maxY &&
                                                node.frame.maxY > node2.frame.minY &&
                                                node.frame.midX > node2.frame.maxX {
                                                
                                                moveQuantities[Direction.west]!.append((Double(node.frame.minX - (node2.frame.maxX)), node2))
                                                
                                            }
                                            
                                        }
                                        
                                        if direction == Direction.east {
                                            
                                            if node.frame.minY < node2.frame.maxY &&
                                                node.frame.maxY > node2.frame.minY &&
                                                node.frame.midX < node2.frame.minX {
                                                
                                                moveQuantities[Direction.east]!.append((Double(-node.frame.maxX + (node2.frame.minX)), node2))
                                                
                                            }
                                            
                                        }
                                        
                                    }
                                    
                                }
                                
                            }
                            
                        }
                    yPos += 1
                    
                
            }
                xPos += 1
                
        }
        
        
        for quantArray in moveQuantities {
            
            var decider: (Double, NioNode) = (Double(collisionPartition.partitionSizeConstant), tempNode)
            
            for moveQuant in quantArray.1 {
                
                if moveQuant.0 < decider.0 {
                    
                    decider = moveQuant
                    //print(decider.1.ref.name)
                    
                }
                
            }
            
            decidingQuantities[quantArray.0] = decider
            
        }
        
        switch direction {
            
        case .north: return decidingQuantities[Direction.north]!
        case .south: return decidingQuantities[Direction.south]!
        case .west: return decidingQuantities[Direction.west]!
        case .east: return decidingQuantities[Direction.east]!
            
        }
        
    }
    
    func force(node node: NioNode, vector: NioVector) {
        
        accelerateNode(node: node, vector: NioVector(x: vector.x / node.mass, y: vector.y / node.mass))
        
    }
    
    func addNode(node node: NioNode) {
        
        physicsNodes[node.ref] = node
        collisionPartition.addToPartition(node: node)
        
    }
    
    func removeNode(node node: NioNode) {
        
        collisionPartition.removeFromPartition(node: node)
        physicsNodes.removeValue(forKey: node.ref)
        
    }
    
}

enum Direction {
    
    case north
    case south
    case west
    case east
    
}

class NioListenerItem {
    
    var item1: NioReference
    var item2: NioReference
    var direction: Direction
    
    init(item1: NioReference, item2: NioReference, direction: Direction) {
        
        self.item1 = item1
        self.item2 = item2
        self.direction = direction
        
    }
    
    func equals(item2: NioListenerItem) -> Bool {
        
        return self.item1.getCompiledRef() == item2.item1.getCompiledRef() && self.item2.getCompiledRef() == item2.item2.getCompiledRef() && self.direction == item2.direction ||
            self.item1.getCompiledRef() == item2.item2.getCompiledRef() && self.item2.getCompiledRef() == item2.item1 .getCompiledRef() && self.direction == item2.direction
        
    }
    
    func compare(name1: String, name2: String, direction: Direction) -> (Bool, [String: String]) {
        
        let dict: [String: String] = [self.item1.name: item1.getCompiledRef(), self.item2.name: item2.getCompiledRef()]
        
        return (self.item1.name == name1 && self.item2.name == name2 && self.direction == direction ||
            self.item1.name == name2 && self.item2.name == name1 && self.direction == direction, dict)
        
    }
    
    func compare(name1: String, name2: String) -> (Bool, [String: String]) {
        
        let dict: [String: String] = [self.item1.name: item1.getCompiledRef(), self.item2.name: item2.getCompiledRef()]
        
        return (self.item1.name == name1 && self.item2.name == name2 && self.direction == direction ||
            self.item1.name == name2 && self.item2.name == name1, dict)
        
    }
    
    func compare(name1: String, direction: Direction) -> (Bool, [String]) {
        
        var array: [String] = []
        let is1: Bool = self.item1.name == name1
        let is2: Bool = self.item2.name == name1
        
        if is1 {
            
            array.append(self.item1.getCompiledRef())
            array.append(self.item2.getCompiledRef())
            
        } else if is2 {
            
            array.append(self.item2.getCompiledRef())
            array.append(self.item1.getCompiledRef())
            
        }
        
        return (is1 || is2 && direction == self.direction, array)
        
    }
    
    func compare(name1: String) -> (Bool, [String]) {
        
        var array: [String] = []
        let is1: Bool = self.item1.name == name1
        let is2: Bool = self.item2.name == name1
        
        if is1 {
            
            array.append(self.item1.getCompiledRef())
            array.append(self.item2.getCompiledRef())
            
        } else if is2 {
            
            array.append(self.item2.getCompiledRef())
            array.append(self.item1.getCompiledRef())
            
        }
        
        return (is1 || is2, array)
        
    }
    
}

