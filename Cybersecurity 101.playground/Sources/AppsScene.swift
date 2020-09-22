import Foundation
import SpriteKit

public var gateSecurity: SecurityState = .open

public var malwareType: EnemyType = .normal

public class AppsScene: GameScene {
    public override func didMove(to view: SKView) {
        camera?.setScale(2.0)
        camera?.position = CGPoint(x:693.819091796875, y:-160.03265380859375)
        physicsWorld.gravity = CGVector.zero
        physicsWorld.contactDelegate = self
        close(gate: 3, duration: 0)
        if gateSecurity == .closed {
            close(gate: 2, duration: 0)
        } else if gateSecurity == .removed {
            fillWall()
        }
        dispatchEnemy(toGate: 2)
    }
    
    func fillWall() {
        let wallNode = childNode(withName: "WallNode") as! SKSpriteNode
        wallNode.physicsBody = .init(rectangleOf: wallNode.frame.size)
        wallNode.physicsBody?.categoryBitMask = PhysicsCategory.castle
        wallNode.physicsBody?.collisionBitMask = PhysicsCategory.enemy
        wallNode.physicsBody?.contactTestBitMask = PhysicsCategory.enemy
        wallNode.physicsBody?.isDynamic = false
        wallNode.isHidden = false
    }
}

