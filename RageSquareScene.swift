//
//  RageSquareScene.swift
//  Rage Squares
//
//  Created by Owen Vnek on 8/6/16.
//  Copyright © 2016 Pullus. All rights reserved.
//

import SpriteKit

public class RageSquareScene: SKScene {
    
    public var physicsEngine: NioPhysicsEngine! = NioPhysicsEngine();
    private var player: NioNode! = NioNode(name: "player", size: CGSize(width: 60, height: 60), color: NioUtilities.UIColorFromRGB(rgbValue: 0x349CBF));
    private var touchAnchor: NioPosition?;
    private var touchCircle: NioNode!;
    private var enemiesPerTick: Double!;
    private var score: Int!;
    private var highScore: Int!;
    private var scoreTimer: Int!;
    private var scoreLabel: SKLabelNode!;
    private var highScoreLabel: SKLabelNode!;
    private var playerSpeed: Double = 4
    private var playerSize: Double = 60
    private var shield: SKShapeNode?
    private var trackers: [(SquareNode, Int)]!
    
    public override func didMove(to view: SKView) {
        super.didMove(to: view)
        size = view.bounds.size
        enemiesPerTick = 0.005;
        physicsEngine.addNode(node: player);
        player.zPosition = 10;
        touchCircle = NioNode(name: "touch circle", radius: 120, color: UIColor(red: 0, green: 0, blue: 0, alpha: 0.4));
        player.position.x = 200
        player.position.y = 200
        addChild(player);
        score = 0;
        trackers = []
        scoreTimer = 0;
        scoreLabel = SKLabelNode(text: "Score: 0")
        highScoreLabel = SKLabelNode(text: "Highscore: 0")
        scoreLabel.position = CGPoint(x: 120, y: size.height - 50)
        highScoreLabel.position = CGPoint(x: 120, y: -50 + size.height - scoreLabel.frame.height * 1.5)
        highScoreLabel.zPosition = 200
        scoreLabel.zPosition = 200
        addChild(scoreLabel)
        addChild(highScoreLabel)
        loadHighScore()
    }
    
    public func loadHighScore() {
        let userDefaults = UserDefaults.standard
        highScore = userDefaults.value(forKey: "highscore") as? Int
        if highScore == nil {
            highScore = 0;
        }
        highScoreLabel.text = "HighScore: \(highScore!)";
    }
    
    public func saveHighScore() {
        let userDefaults = UserDefaults.standard
        userDefaults.set(highScore, forKey: "highscore")
    }
    
    public func touchScreen(point: NioPosition) {
        if let _ = touchAnchor {
            var angle = atan(Double(point.y - touchAnchor!.y) / Double(point.x - touchAnchor!.x));
            if point.x - touchAnchor!.x < 0 {
                angle += 3.14
            }
            player.velocity.x = playerSpeed * cos(angle)
            player.velocity.y = playerSpeed * sin(angle)
        }
    }
    
    public override func update(_ currentTime: TimeInterval) {
        physicsEngine.tick(size: size);
        enemiesPerTick! += 0.000006;
        let rand: Double = Double(arc4random_uniform(10000)) / 10000
        if enemiesPerTick > Double(rand) {
            addEnemy();
        }
        for var i: Int in 0..<trackers.count {
            if i < trackers.count {
                let tracker: (SquareNode, Int) = trackers[i]
                let trackerNode: SquareNode = tracker.0
                let timer: Int = tracker.1
                guard trackerNode.parent != nil else {
                    trackers.remove(at: i)
                    i -= 1
                    continue
                }
                if timer == 0 {
                    trackers.remove(at: 0)
                    trackerNode.removeFromParent()
                    physicsEngine.removeNode(node: trackerNode)
                    i -= 1
                } else {
                    let deltaY: Double = Double(player.position.y - trackerNode.position.y)
                    let deltaX: Double = Double(player.position.x - trackerNode.position.x)
                    var angle: Double = atan(deltaY / deltaX)
                    if deltaX < 0 {
                        angle += Double.pi
                    }
                    trackerNode.velocity.x = cos(angle)
                    trackerNode.velocity.y = sin(angle)
                    trackers[i] = (trackerNode, timer - 1)
                }
            }
        }
        for collision in physicsEngine.collisionListener {
            if collision.item1.name == "player" && collision.item2.name == "evil" ||
                collision.item2.name == "player" && collision.item1.name == "evil" {
                if shield == nil {
                    reset()
                } else {
                    removeShield()
                    if collision.item1.name == "evil" {
                        if let node = physicsEngine.physicsNodes[collision.item1] {
                            node.removeFromParent()
                            physicsEngine.removeNode(node: node)
                        }
                    } else if collision.item2.name == "evil" {
                        if let node = physicsEngine.physicsNodes[collision.item2] {
                            node.removeFromParent()
                            physicsEngine.removeNode(node: node)
                        }
                    }
                }
            } else if collision.item1.name == "player" && collision.item2.name == "boost" ||
                collision.item2.name == "player" && collision.item1.name == "boost" {
                upgrade()
                if collision.item1.name == "boost" {
                    if let node = physicsEngine.physicsNodes[collision.item1] {
                        node.removeFromParent()
                        physicsEngine.removeNode(node: node)
                    }
                } else if collision.item2.name == "boost" {
                    if let node = physicsEngine.physicsNodes[collision.item2] {
                        node.removeFromParent()
                        physicsEngine.removeNode(node: node)
                    }
                }
            } else if collision.item1.name == "playerShield" && collision.item2.name == "evil" ||
                collision.item2.name == "playerShield" && collision.item1.name == "evil" {
                let node1 = physicsEngine.physicsNodes[collision.item1]
                let node2 = physicsEngine.physicsNodes[collision.item2]
                removeShield()
                node1?.removeFromParent()
                node2?.removeFromParent()
                physicsEngine.removeNode(node: node1!)
                physicsEngine.removeNode(node: node2!)
            } else if collision.item1.name == "player" && collision.item2.name == "shield" ||
                collision.item2.name == "player" && collision.item1.name == "shield"{
                addShield()
                if collision.item1.name == "shield" {
                    if let node = physicsEngine.physicsNodes[collision.item1] {
                        node.removeFromParent()
                        physicsEngine.removeNode(node: node)
                    }
                } else if collision.item2.name == "shield" {
                    if let node = physicsEngine.physicsNodes[collision.item2] {
                        node.removeFromParent()
                        physicsEngine.removeNode(node: node)
                    }
                }
            } else if collision.item1.name == "player" && collision.item2.name == "tracker" ||
                collision.item2.name == "player" && collision.item1.name == "tracker" {
                if shield == nil {
                    reset()
                } else {
                    removeShield()
                    if collision.item1.name == "tracker" {
                        if let node = physicsEngine.physicsNodes[collision.item1] {
                            node.removeFromParent()
                            physicsEngine.removeNode(node: node)
                        }
                    } else if collision.item2.name == "tracker" {
                        if let node = physicsEngine.physicsNodes[collision.item2] {
                            node.removeFromParent()
                            physicsEngine.removeNode(node: node)
                        }
                    }
                }
            }
        }
         if player.frame.minX < 0 {
         player.position.x = player.frame.width / 2;
         } else if player.frame.maxX > size.width {
         player.position.x = size.width - player.frame.width / 2
         }
         if player.frame.minY < 0 {
         player.position.y = player.frame.height / 2
         } else if player.frame.maxY > size.height {
         player.position.y = size.height - player.frame.height / 2
         }
        physicsEngine.collisionListener = []
        scoreTimer = scoreTimer + 1;
        if scoreTimer == 15 {
            score = score + 1;
            scoreTimer = 1
            scoreLabel.text = "Score: \(score!)"
        }
    }
    
    
    public func reset() {
        player.removeFromParent()
        physicsEngine.removeNode(node: player)
        player = NioNode(name: "player", size: CGSize(width: 60, height: 60), color: NioUtilities.UIColorFromRGB(rgbValue: 0x349CBF));
        addChild(player)
        physicsEngine.addNode(node: player)
        playerSpeed = 4
        playerSize = 60
        if score > highScore {
            highScore = score
            highScoreLabel.text = "Highscore: \(highScore!)"
            saveHighScore()
        }
        score = 0
        shield = nil
        enemiesPerTick = 0.005;
        physicsEngine.reset()
        physicsEngine.addNode(node: player)
        player.position.x = size.width / 2
        player.position.y = size.height / 2
        trackers = []
    }
    
    private func upgrade() {
        playerSpeed += 0.4
        if playerSize > 5 {
            playerSize -= 5
            let newNode = NioNode(name: "player", size: CGSize(width: playerSize, height: playerSize), color: NioUtilities.UIColorFromRGB(rgbValue: 0x349CBF))
            newNode.position = player.position
            if shield != nil {
                shield!.removeFromParent()
                newNode.addChild(shield!)
            }
            player.removeFromParent()
            physicsEngine.removeNode(node: player)
            addChild(newNode)
            physicsEngine.addNode(node: newNode)
            player = newNode
        }
    }
    
    func addShield() {
        if shield == nil {
            shield = SKShapeNode(rect: CGRect(x: -45, y: -45, width: 90, height: 90))
            shield!.lineWidth = 10
            shield!.strokeColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
            shield!.name = "playerShield"
            player.addChild(shield!)
        }
    }
    
    func removeShield() {
        if shield != nil {
            shield?.removeFromParent()
            shield = nil
        }
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let cgPoint = touch.location(in: self);
            let point = NioPosition(x: Int(cgPoint.x), y: Int(cgPoint.y));
            if touchAnchor == nil {
                touchAnchor = NioPosition(x: point.x, y: point.y)
                touchCircle.position = cgPoint;
                addChild(touchCircle);
            } else {
                touchScreen(point: point);
            }
        }
    }
    
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let cgPoint = touch.location(in: self);
            let point = NioPosition(x: Int(cgPoint.x), y: Int(cgPoint.y));
            touchScreen(point: point);
        }
    }
    
    public func addEnemy() {
        let width = Int(size.width);
        let height = Int(size.height);
        let w = UInt32(size.width);
        let h = UInt32(size.height);
        let pos = Double(arc4random_uniform(10000)) / 10000;
        let speed = Double(arc4random_uniform(2)) + 1.5
        var x = 0;
        var y = 0;
        var xVel: Double = 0;
        var yVel: Double = 0;
        if pos >= 0 && pos < 0.25 {
            x = Int(arc4random_uniform(w));
            y = height + 50;
            xVel = 0
            yVel = -speed
        } else if pos >= 0.25 && pos < 0.5 {
            x = width + 50;
            y = Int(arc4random_uniform(h));
            xVel = -speed
            yVel = 0
        } else if pos >= 0.5 && pos < 0.75 {
            x = Int(arc4random_uniform(w));
            y = -50
            xVel = 0
            yVel = speed
        } else if pos >= 0.75 && pos <= 1 {
            x = -50
            y = Int(arc4random_uniform(h));
            xVel = speed
            yVel = 0
        }
        let node = generateEnemy();
        if node.name == "tracker" {
            trackers.append((node as! SquareNode, 350))
            xVel /= 8
            yVel /= 8
        }
        node.position.x = CGFloat(x);
        node.position.y = CGFloat(y);
        node.velocity.x = Double(xVel)
        node.velocity.y = Double(yVel)
        node.stoppable = false;
        node.friction = false
        addChild(node);
        physicsEngine.addNode(node: node);
    }
    
    public func generateEnemy() -> NioNode {
        let width = arc4random_uniform(85) + 10;
        let height = arc4random_uniform(85) + 10;
        let squareType = SquareNode.SquareType()
        let node = SquareNode(size: CGSize(width: CGFloat(width), height: CGFloat(height)), squareType: squareType)
        return node;
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchAnchor = nil;
        player.velocity.x = 0;
        player.velocity.y = 0;
        
        touchCircle.removeFromParent();
    }
    
}
