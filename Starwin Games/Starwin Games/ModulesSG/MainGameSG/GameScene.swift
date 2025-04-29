//
//  PhysicsCategory.swift
//  Starwin Games
//
//  Created by Dias Atudinov on 29.04.2025.
//


import SpriteKit

// Тип движения корабля
enum MovementType: Int {
    case straight = 0
    case turnLeft = 1
    case turnRight = 2
    case uTurn = 3
}

struct ShipConfig {
    let name: String
    let initialPosition: CGPoint
    let direction: CGVector
    let movement: MovementType
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    var levelIndex: Int = 0
    private var lastTappedShip: SKSpriteNode?
    private var shipArrows: [SKSpriteNode: SKSpriteNode] = [:]
    private var bigArrows: [SKSpriteNode: SKSpriteNode] = [:]

    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        backgroundColor = .black
        setupLevel(levelIndex)
    }

    private func setupLevel(_ index: Int) {
        let w = size.width
        let h = size.height
        let fieldHeight = h / 2
        let fieldCenterY = h / 2
        var roadConfigs: [(position: CGPoint, size: CGSize)] = []
        var shipConfigs: [ShipConfig] = []

        switch index {
        case 0:
            roadConfigs = [
                (CGPoint(x: w/2, y: fieldCenterY), CGSize(width: w, height: 100)),
                (CGPoint(x: w/2, y: fieldCenterY), CGSize(width: 100, height: fieldHeight))
            ]
            shipConfigs = [
                ShipConfig(name: "ship0", initialPosition: CGPoint(x: w/2, y: fieldCenterY + fieldHeight/2 - 50), direction: CGVector(dx: 0, dy: -1), movement: .straight),
                ShipConfig(name: "ship1", initialPosition: CGPoint(x: w/2 - fieldHeight/2 + 50, y: fieldCenterY), direction: CGVector(dx: 1, dy: 0), movement: .turnLeft),
                ShipConfig(name: "ship2", initialPosition: CGPoint(x: w/2, y: fieldCenterY - fieldHeight/2 + 50), direction: CGVector(dx: 0, dy: 1), movement: .turnRight),
                ShipConfig(name: "ship3", initialPosition: CGPoint(x: w/2 + fieldHeight/2 - 80, y: fieldCenterY), direction: CGVector(dx: 1, dy: 0), movement: .straight)
            ]
        default:
            break
        }

        for config in roadConfigs {
            let road = SKSpriteNode(color: .darkGray, size: config.size)
            road.position = config.position
            addChild(road)
        }

        for shipConfig in shipConfigs {
                   let ship = SKSpriteNode(imageNamed: "shipSG")
                   ship.size = CGSize(width: 60, height: 60)
                   ship.position = shipConfig.initialPosition
                   ship.name = shipConfig.name
                   ship.zRotation = atan2(shipConfig.direction.dy, shipConfig.direction.dx)
                   ship.userData = [
                       "initialPosition": NSValue(cgPoint: shipConfig.initialPosition),
                       "direction": NSValue(cgVector: shipConfig.direction),
                       "movementType": shipConfig.movement.rawValue
                   ]
                   ship.physicsBody = SKPhysicsBody(circleOfRadius: 20)
                   ship.physicsBody?.categoryBitMask = 0x1 << 0
                   ship.physicsBody?.contactTestBitMask = 0x1 << 0
                   ship.physicsBody?.collisionBitMask = 0
                   ship.physicsBody?.affectedByGravity = false
                   addChild(ship)

            let arrowTextureName: String
            switch shipConfig.movement {
            case .straight:
                arrowTextureName = "arrow"
            case .turnLeft:
                arrowTextureName = "arrowLeft"
            case .turnRight:
                arrowTextureName = "arrowRight"
            case .uTurn:
                arrowTextureName = "arrowBack"
            }
            
            let arrow = SKSpriteNode(imageNamed: arrowTextureName)
                   arrow.size = CGSize(width: 20, height: 40)
            arrow.position = CGPoint(x: 20, y: 0)
                   arrow.zRotation = -(.pi/2)
                   ship.addChild(arrow)
                   shipArrows[ship] = arrow

                   let bigArrow = SKSpriteNode(imageNamed: "arrow")
                   bigArrow.size = CGSize(width: 60, height: 30)
                   bigArrow.position = CGPoint(x: shipConfig.initialPosition.x, y: shipConfig.initialPosition.y + 50)
                   bigArrow.zRotation = ship.zRotation - .pi/2
                   //addChild(bigArrow)
                   bigArrows[ship] = bigArrow
               }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        for node in nodes(at: location) {
            if let ship = node as? SKSpriteNode,
               ship.physicsBody?.categoryBitMask == (0x1 << 0) {
                startMovement(for: ship)
                break
            }
        }
    }

    private func startMovement(for ship: SKSpriteNode) {
        guard ship.action(forKey: "moving") == nil else { return }
        lastTappedShip = ship

        if let arrow = shipArrows[ship] {
            arrow.removeFromParent()
        }
        if let bigArrow = bigArrows[ship] {
            bigArrow.removeFromParent()
        }

        guard
            let dirValue = ship.userData?["direction"] as? NSValue,
            let typeValue = ship.userData?["movementType"] as? NSNumber
        else { return }

        let dir = dirValue.cgVectorValue
        let movementType = MovementType(rawValue: typeValue.intValue) ?? .straight
        let maxDist = max(size.width, size.height)
        let fullDuration: TimeInterval = 3.0
        let finish = SKAction.run { [weak ship] in
            ship?.removeAllActions()
            ship?.removeFromParent()
        }

        switch movementType {
        case .straight:
            let dest = CGPoint(x: ship.position.x + dir.dx * maxDist,
                               y: ship.position.y + dir.dy * maxDist)
            let move = SKAction.move(to: dest, duration: fullDuration)
            ship.run(.sequence([move, finish]), withKey: "moving")

        case .uTurn:
            let dest = CGPoint(x: ship.position.x - dir.dx * maxDist,
                               y: ship.position.y - dir.dy * maxDist)
            let move = SKAction.move(to: dest, duration: fullDuration)
            ship.run(.sequence([move, finish]), withKey: "moving")

        case .turnLeft, .turnRight:
            let center = CGPoint(x: size.width/2, y: size.height/2)
            let halfDuration = fullDuration / 2
            let move1 = SKAction.move(to: center, duration: halfDuration)
            let angle: CGFloat = (movementType == .turnLeft) ? .pi/2 : -.pi/2
            let rotate = SKAction.rotate(byAngle: angle, duration: 0)
            let newDir = CGVector(dx: dir.dx * cos(angle) - dir.dy * sin(angle),
                                  dy: dir.dx * sin(angle) + dir.dy * cos(angle))
            let dest2 = CGPoint(x: center.x + newDir.dx * maxDist,
                                y: center.y + newDir.dy * maxDist)
            let move2 = SKAction.move(to: dest2, duration: halfDuration)
            ship.run(.sequence([move1, rotate, move2, finish]), withKey: "moving")
        }
    }

    func didBegin(_ contact: SKPhysicsContact) {
        guard let ship = lastTappedShip else { return }
        if contact.bodyA.node == ship || contact.bodyB.node == ship {
            ship.removeAllActions()
            if let initVal = ship.userData?["initialPosition"] as? NSValue {
                let initPos = initVal.cgPointValue
                ship.run(SKAction.move(to: initPos, duration: 0.5))
            }
            lastTappedShip = nil
        }
    }
}
