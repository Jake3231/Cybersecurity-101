import Foundation
import SpriteKit

public class FirewallScene: GameScene {
    
    let dispatchOrder = ["💾", "💾", "👾", "💾", "👾", "💾", "💾"]
    
    public override func didMove(to view: SKView) {
        camera?.setScale(2.0)
        camera?.position = CGPoint(x:1581.2857666015625, y: -160.03265380859375)
        physicsWorld.gravity = CGVector.zero
        physicsWorld.contactDelegate = self
        close(gate: 3, duration: 0)
        
        let bridgeNode = childNode(withName: "BridgeNode") as! SKShapeNode
        bridgeNode.physicsBody = .init(rectangleOf: bridgeNode.frame.size)
        bridgeNode.physicsBody?.categoryBitMask = PhysicsCategory.bridge
        bridgeNode.physicsBody?.collisionBitMask = PhysicsCategory.data
        bridgeNode.physicsBody?.contactTestBitMask = PhysicsCategory.data
        bridgeNode.physicsBody?.isDynamic = false
        bridgeNode.isHidden = false
        
        let moteNode = childNode(withName: "Mote_Bridge") as! SKSpriteNode
        moteNode.isHidden = false
        
        for (index, item) in dispatchOrder.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index * 3), execute: {
                if item == "👾" {
                    self.dispatchEnemy(toGate: 4)
                } else {
                    self.dispatchData(throughGate: 4)
                }
            })
        }
    }
    
    func dispatchData(throughGate gateNumber: Int) {
        let gateNode = childNode(withName: "Gate\(gateNumber)") as! SKSpriteNode
        let documentsNode = childNode(withName: "DocumentsFolder\(gateNumber)") as! SKSpriteNode
        let moveAction = SKAction.move(to: documentsNode.position, duration: 5)
        
        let dataNode = SKLabelNode(text: "💾")
        dataNode.fontSize = 144
        
        dataNode.name = "Data"
        dataNode.position = CGPoint(x: gateNode.position.x, y: 700)
        dataNode.zPosition = 0
        dataNode.physicsBody = .init(rectangleOf: dataNode.frame.size)
        dataNode.physicsBody?.categoryBitMask = PhysicsCategory.data
        dataNode.physicsBody?.collisionBitMask = PhysicsCategory.bridge
        dataNode.physicsBody?.contactTestBitMask = PhysicsCategory.bridge
        
        
        addChild(dataNode)
        
        dataNode.run(moveAction)
    }
}
