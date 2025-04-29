//
//  PhysicsCategory.swift
//  Starwin Games
//
//  Created by Dias Atudinov on 29.04.2025.
//


import SpriteKit

enum MovementType: Int {
    case straight = 0      // прямо
    case turnLeft = 1      // поворот налево
    case turnRight = 2     // поворот направо
    case uTurn = 3         // разворот на 180°
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

    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        backgroundColor = .black
        setupLevel(levelIndex)
    }

    private func setupLevel(_ index: Int) {
        let w = size.width
        let h = size.height
        var roadConfigs: [(position: CGPoint, size: CGSize)] = []
        var shipConfigs: [ShipConfig] = []

        switch index {
        case 0:
            roadConfigs = [
                (CGPoint(x: w/2, y: h/2), CGSize(width: w, height: 100)),
                (CGPoint(x: w/2, y: h/2), CGSize(width: 100, height: h))
            ]
            shipConfigs = [
                ShipConfig(name: "ship0", initialPosition: CGPoint(x: w/2, y: h - 50), direction: CGVector(dx: 0, dy: -1), movement: .straight),
                ShipConfig(name: "ship1", initialPosition: CGPoint(x: 50, y: h/2), direction: CGVector(dx: 1, dy: 0), movement: .turnLeft),
                ShipConfig(name: "ship2", initialPosition: CGPoint(x: w/2, y: 50), direction: CGVector(dx: 0, dy: 1), movement: .turnRight),
                ShipConfig(name: "ship3", initialPosition: CGPoint(x: w - 50, y: h/2), direction: CGVector(dx: -1, dy: 0), movement: .uTurn)
            ]
        default:
            break
        }

        // Отрисовка дорог
        for config in roadConfigs {
            let road = SKSpriteNode(color: .darkGray, size: config.size)
            road.position = config.position
            addChild(road)
        }

        // Настройка кораблей
        for shipConfig in shipConfigs {
            let ship = SKSpriteNode(imageNamed: "ship")
            ship.size = CGSize(width: 40, height: 40)
            ship.position = shipConfig.initialPosition
            ship.name = shipConfig.name
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

            // Стрелка у корабля
            let arrow = SKSpriteNode(imageNamed: "arrow")
            arrow.size = CGSize(width: 30, height: 30)
            arrow.position = .zero
            arrow.zRotation = atan2(shipConfig.direction.dy, shipConfig.direction.dx) - .pi/2
            ship.addChild(arrow)

            // Отдельная большая стрелка на карте
            let bigArrow = SKSpriteNode(imageNamed: "arrow")
            bigArrow.size = CGSize(width: 60, height: 60)
            bigArrow.position = CGPoint(x: shipConfig.initialPosition.x, y: shipConfig.initialPosition.y + 50)
            bigArrow.zRotation = arrow.zRotation
            addChild(bigArrow)
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
