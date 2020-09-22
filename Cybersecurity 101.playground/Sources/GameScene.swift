import Foundation
import SpriteKit

public class GameScene: SKScene {
    private let cameraSpeed = 1.0
    
    var gatesClosed = [false,false,false,false]
    var bridgeState = true
    
    public override func didMove(to view: SKView) {
        camera?.setScale(2.0)
        physicsWorld.gravity = CGVector.zero
        physicsWorld.contactDelegate = self
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            self.dispatchEnemy(toGate: 1)
        })
    }
    
    public func dispatchEnemy(toGate gateNumber: Int) {
        let gateNode = childNode(withName: "Gate\(gateNumber)") as! SKSpriteNode
        let documentsNode = childNode(withName: "DocumentsFolder\(gateNumber)") as! SKSpriteNode
        
        let moveAction = SKAction.move(to: documentsNode.position, duration: 5)
        var enemyNode: SKNode!
        
        if malwareType == .normal {
            let tempEnemyNode = SKLabelNode(text: "👾")
            tempEnemyNode.fontSize = 144
            enemyNode = tempEnemyNode
        } else if malwareType == .zeroDay {
            let tempEnemyNode = SKSpriteNode(imageNamed: "0DayMalware")
            tempEnemyNode.size = CGSize(width: 147, height: 147)
            enemyNode = tempEnemyNode
        }
        
        enemyNode.name = "Malware"
        enemyNode.position = CGPoint(x: gateNode.position.x, y: 700)
        enemyNode.zPosition = 0
        enemyNode.physicsBody = .init(rectangleOf: enemyNode.frame.size)
        enemyNode.physicsBody?.categoryBitMask = PhysicsCategory.enemy
        enemyNode.physicsBody?.collisionBitMask = PhysicsCategory.gate
        enemyNode.physicsBody?.contactTestBitMask = PhysicsCategory.gate
        
        addChild(enemyNode)
        
        enemyNode.run(moveAction)
        
    }
    
    func prepareGatePhysics() {
        var sceneGates: [SKSpriteNode] = []
        sceneGates.append(childNode(withName: "Gate1") as! SKSpriteNode)
        sceneGates.append(childNode(withName: "Gate2") as! SKSpriteNode)
        
        for gate in sceneGates {
            gate.physicsBody = .init(rectangleOf: CGSize(width: gate.size.width, height: 10), center: CGPoint(x: 0, y: -gate.size.height/2))
            gate.physicsBody?.categoryBitMask = PhysicsCategory.gate
            gate.physicsBody?.isDynamic = false
        }
    }
    
    func toggle(gate gateNumber: Int) {
        if gatesClosed[gateNumber-1] {
            open(gate: gateNumber)
        } else {
            close(gate: gateNumber)
        }
    }
    
    public func close(gate gateNumber: Int, duration: TimeInterval? = 1) {
        if !gatesClosed[gateNumber-1] {
            let gateNode = childNode(withName: "Gate\(gateNumber)") as! SKSpriteNode
            let moveAction = SKAction.moveBy(x: 0, y: -(gateNode.size.height * 0.68), duration: duration ?? 1)
            gateNode.run(moveAction)
            gatesClosed[gateNumber-1] = true
            gateNode.physicsBody = .init(rectangleOf: CGSize(width: gateNode.size.width, height: 10), center: CGPoint(x: 0, y: -gateNode.size.height/2))
            gateNode.physicsBody?.categoryBitMask = PhysicsCategory.gate
            gateNode.physicsBody?.isDynamic = false
        }
    }
    
    public func open(gate gateNumber: Int) {
        if gatesClosed[gateNumber-1] {
            let gateNode = childNode(withName: "Gate\(gateNumber)") as! SKSpriteNode
            let moveAction = SKAction.moveBy(x: 0, y: (gateNode.size.height * 0.68), duration: 1)
            gateNode.run(moveAction)
            gatesClosed[gateNumber-1] = false
            gateNode.physicsBody = nil
        }
    }
    
    func toggleBridge(bridge: SKShapeNode) {
        if !bridgeState {
            bridge.fillColor = .orange
            bridgeState = true
        } else {
            bridge.fillColor = .clear
            bridgeState = false
        }
        print("set bridge to \(bridgeState)")
    }
    
    func touchDown(atPoint pos : CGPoint) {
        
    }
    
    
    func touchUp(atPoint pos : CGPoint) {
        let clickedGate = (scene!.nodes(at: pos)).first(where: {($0.name ?? "").hasPrefix("Gate")})
        if clickedGate != nil {
            switch clickedGate!.name! {
            case "Gate1":
                toggle(gate: 1)
            case "Gate2":
                toggle(gate: 2)
            default: break
            }
        }
        
        let bridgeNode = (scene!.nodes(at: pos)).first(where: {($0.name ?? "") == ("BridgeNode")}) as? SKShapeNode
        if bridgeNode != nil {
            toggleBridge(bridge: bridgeNode!)
        }
    }
    
    public override func mouseDown(with event: NSEvent) {
        touchDown(atPoint: event.location(in: self))
    }
    
    public override func mouseUp(with event: NSEvent) {
        touchUp(atPoint: event.location(in: self))
    }
    
    public override func keyDown(with event: NSEvent) {
        /*switch (event.keyCode) {
        case 0:
            startMovingCamera(inDirection: .left)
        case 2:
            startMovingCamera(inDirection: .right)
        default:
            break
        }*/
    }
    
    public override func keyUp(with event: NSEvent) {
        /*switch (event.keyCode) {
        case 0:
            stopMovingCamera(inDirection: .left)
        case 2:
            stopMovingCamera(inDirection: .right)
        default:
            break
        }*/
    }
    
    func startMovingCamera(inDirection moveDirection: Direction) {
        let moveUp = SKAction.moveBy(x: 0, y: 20,duration: (0.05/cameraSpeed))
        let moveRight = SKAction.moveBy(x: 20, y: 0 , duration: (0.05/cameraSpeed))
        let moveLeft = SKAction.moveBy(x: -20, y: 0 , duration: (0.05/cameraSpeed))
        let moveDown = SKAction.moveBy(x: 0, y: -20 , duration: (0.05/cameraSpeed))
        
        switch moveDirection {
        case .right:
            stopMovingCamera(inDirection: .left)
            camera?.run(SKAction.repeatForever(moveRight), withKey:  "moveRight")
        case .left:
            stopMovingCamera(inDirection: .right)
            camera?.run(SKAction.repeatForever(moveLeft), withKey:  "moveLeft")
        case .up:
            stopMovingCamera(inDirection: .down)
            camera?.run(SKAction.repeatForever(moveUp), withKey:  "moveUp")
        case .down:
            stopMovingCamera(inDirection: .up)
            camera?.run(SKAction.repeatForever(moveDown), withKey:  "moveDown")
        }
    }
    
    func stopMovingCamera(inDirection stopDirection: Direction) {
        
        switch stopDirection {
        case .right:
            camera?.removeAction(forKey: "moveRight")
        case .left:
            camera?.removeAction(forKey: "moveLeft")
        case .up:
            camera?.removeAction(forKey: "moveUp")
        case .down:
            camera?.removeAction(forKey: "moveDown")
        }
    }
    
    func stopMovingPlayer() {
        camera?.removeAction(forKey: "moveRight") //Right
        camera?.removeAction(forKey: "moveLeft") //Left
        camera?.removeAction(forKey: "moveUp") //Up
        camera?.removeAction(forKey: "moveDown") //Down
    }
    
    struct PhysicsCategory {
        static let bridge    : UInt32 = 0
        static let data      : UInt32 = UInt32.max
        static let enemy     : UInt32 = 0b1
        static let gate      : UInt32 = 0b10
        static let castle    : UInt32 = 0b11
    }
    
    @objc public static override var supportsSecureCoding: Bool {
        get {
            return true
        }
    }
    
}

extension GameScene: SKPhysicsContactDelegate {
    public func didBegin(_ contact: SKPhysicsContact) {
        
        var firstNode: SKNode
        var secondNode: SKNode
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstNode = (contact.bodyA.node!)
            secondNode = (contact.bodyB.node!)
        } else {
            firstNode = (contact.bodyB.node!)
            secondNode = (contact.bodyA.node!)
        }
        
        if (firstNode.name ?? "") == "Malware" && (secondNode.name ?? "").hasPrefix("Gate") {
            if malwareType == .normal {
                let moveAction = SKAction.move(to: CGPoint(x: firstNode.position.x, y: 1000), duration: 4)
                firstNode.removeAllActions()
                firstNode.run(moveAction)
            } else {
                if (secondNode.name ?? "") == "Gate1" {
                    open(gate: 1)
                } else if (secondNode.name ?? "") == "Gate2" {
                    open(gate: 2)
                } else if (secondNode.name ?? "") == "Gate3" {
                    open(gate:3)
                }
            }
        }
        
        if (firstNode.name ?? "") == "Malware" && (secondNode.name ?? "").hasPrefix("DocumentsFolder") { // Game Over
            let newJoint = SKPhysicsJointFixed.joint(withBodyA: firstNode.physicsBody!, bodyB: secondNode.physicsBody!, anchor: CGPoint(x: firstNode.frame.maxX, y: secondNode.frame.minY))
            physicsWorld.add(newJoint)
            
            let moveAction = SKAction.move(to: CGPoint(x: firstNode.position.x, y: 1000), duration: 4) //Move offscreen
    
            secondNode.physicsBody?.isDynamic = true
            firstNode.run(moveAction)
        }
        
        if (firstNode.name ?? "") == "Data" && (secondNode.name ?? "").hasPrefix("DocumentsFolder") {
            firstNode.removeFromParent()
        }
        
        if (firstNode.name ?? "") == "BridgeNode" && (secondNode.name ?? "") == "Data" {
            if !bridgeState {
                secondNode.removeFromParent()
            }
        }
        
        if (firstNode.name ?? "") == "BridgeNode" && (secondNode.name ?? "") == "Malware" {
            if !bridgeState {
                secondNode.removeFromParent()
            }
        }
        
        if (firstNode.name ?? "") == "Malware" && (secondNode.name ?? "") == "WallNode" {
            let moveAction = SKAction.move(to: CGPoint(x: firstNode.position.x, y: 1000), duration: 4)
            firstNode.removeAllActions()
            firstNode.run(moveAction)
        }
    }
}


public enum Direction {
    case up
    case down
    case left
    case right
}

public enum EnemyType {
    case normal
    case zeroDay
}

