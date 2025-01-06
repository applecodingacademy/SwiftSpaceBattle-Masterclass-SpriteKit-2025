//
//  GameScene.swift
//  SwiftSpaceBattle
//
//  Created by Julio César Fernández Muñoz on 4/1/25.
//

import SwiftUI
import SpriteKit
import GameplayKit

/// `GameScene` representa la escena principal del juego donde se manejan la nave, enemigos y colisiones.
final class GameScene: SKScene, SKPhysicsContactDelegate {
    /// Distribuidor aleatorio para decidir el tipo de enemigo (1 o 2).
    let type = GKRandomDistribution(forDieWithSideCount: 2)
    
    /// Temporizador encargado de generar enemigos a intervalos regulares.
    var timerEnemies: Timer?
    
    /// Crea una nueva instancia de `GameScene` desde el archivo `.sks`.
    static let newGame: GameScene = {
        guard let game = GameScene(fileNamed: "GameScene.sks") else { fatalError("No se pudo cargar la escena GameScene.sks") }
        game.scaleMode = .aspectFill
        return game
    }()
    
    /// Configuración inicial de la escena.
    /// - Parameter view: La vista que muestra la escena de SpriteKit.
    override func didMove(to view: SKView) {
        /// Configura la física de la escena.
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = .zero // Sin gravedad para un juego espacial.

        /// Configura la nave principal.
        setupShip()
        
        /// Temporizador para generar enemigos de manera aleatoria entre 2 y 4 segundos.
        timerEnemies = Timer.scheduledTimer(withTimeInterval: .random(in: 2...4),
                                            repeats: true) { _ in
            self.spawnEnemy()
        }
        
        /// Nodo contenedor para los enemigos.
        let enemyLayer = SKNode()
        enemyLayer.name = "enemyLayer"
        addChild(enemyLayer)
    }
    
    // MARK: - Configuración de la Nave
    
    /**
     Configura la nave principal del juego.
     
     - Establece restricciones para que la nave no se salga de los límites de la pantalla.
     - Configura el cuerpo físico de la nave para detectar colisiones.
     */
    func setupShip() {
        guard let ship = childNode(withName: "ship") as? SKSpriteNode else { return }
        
        // Límites horizontales y verticales de la nave.
        let xRange = SKRange(lowerLimit: -((frame.width / 2) - ship.frame.width),
                             upperLimit: (frame.width / 2) - ship.frame.width)
        let yRange = SKRange(lowerLimit: -(frame.height / 2) + 100,
                             upperLimit: frame.width / 4)
        let constraint = SKConstraint.positionX(xRange, y: yRange)
        ship.constraints = [constraint]
        
        // Configuración física de la nave.
        ship.physicsBody = SKPhysicsBody(circleOfRadius: ship.size.width / 2)
        ship.physicsBody?.isDynamic = true
        ship.physicsBody?.categoryBitMask = PhysicsCategory.ship
        ship.physicsBody?.collisionBitMask = PhysicsCategory.none
        ship.physicsBody?.contactTestBitMask = PhysicsCategory.enemy
    }
    
    // MARK: - Disparo Láser
    
    /**
     Genera un disparo láser desde la posición actual de la nave.
     
     - Crea un `SKShapeNode` que representa el láser.
     - Configura la física del láser para detectar colisiones con enemigos.
     - Mueve el láser hacia arriba y lo elimina al salir de pantalla.
     */
    func fireLaser() {
        guard let ship = childNode(withName: "ship") as? SKSpriteNode else { return }
        
        let laser = SKShapeNode(rectOf: CGSize(width: 3, height: 30))
        laser.fillColor = .white
        laser.strokeColor = .clear
        laser.blendMode = .add
        laser.zPosition = 4 // Encima de todos los elementos.
        
        laser.position = CGPoint(x: ship.position.x,
                                 y: ship.position.y)
        addChild(laser)
        
        // Configuración física del láser.
        laser.physicsBody = SKPhysicsBody(rectangleOf: laser.frame.size)
        laser.physicsBody?.isDynamic = true
        laser.physicsBody?.categoryBitMask = PhysicsCategory.laser
        laser.physicsBody?.collisionBitMask = PhysicsCategory.none
        laser.physicsBody?.contactTestBitMask = PhysicsCategory.enemy
        
        // Animación del láser hacia arriba.
        let moveAction = SKAction.moveTo(y: frame.height + laser.frame.height, duration: 2)
        let remove = SKAction.removeFromParent()
        let sequence = SKAction.sequence([moveAction, remove])
        
        laser.run(sequence)
    }
    
    // MARK: - Scroll del Fondo
    
    /**
     Mueve las capas de fondo para crear el efecto de scroll infinito.
     
     - Parameters:
       - layer: Índice de la capa de fondo.
       - scrollSpeed: Velocidad de desplazamiento de la capa.
     */
    func moveScroll(layer: Int, scrollSpeed: CGFloat) {
        guard let scroll1 = childNode(withName: "background\(layer)1") as? SKSpriteNode,
              let scroll2 = childNode(withName: "background\(layer)2") as? SKSpriteNode else { return }
        
        let deltaTime = 1 / 60.0 // Aproximadamente 60 FPS.
        scroll1.position.y -= scrollSpeed * CGFloat(deltaTime)
        scroll2.position.y -= scrollSpeed * CGFloat(deltaTime)
        
        // Reposición de las capas de fondo.
        if scroll1.position.y <= -scroll1.size.height {
            scroll1.position.y = scroll2.position.y + scroll2.size.height
        }
        
        if scroll2.position.y <= -scroll2.size.height {
            scroll2.position.y = scroll1.position.y + scroll1.size.height
        }
    }
    
    // MARK: - Generación de Enemigos
    
    /**
     Crea un enemigo en una posición aleatoria en la parte superior de la pantalla.
     
     - El enemigo sigue un patrón ondulado al bajar.
     */
    func spawnEnemy() {
        guard let enemyLayer = childNode(withName: "enemyLayer"),
              let ship = childNode(withName: "ship") as? SKSpriteNode else { return }
        
        let enemyType = type.nextInt() // Tipo de enemigo (1 o 2).
        let enemy = SKSpriteNode(imageNamed: "enemy\(enemyType)")
        enemy.size = ship.size * CGFloat.random(in: 0.5...0.8)
        enemy.zPosition = ship.zPosition
        enemy.position = CGPoint(x: .random(in: -frame.width / 2 ... frame.width / 2),
                                 y: frame.height / 2 + 50)
        enemyLayer.addChild(enemy)
        
        // Configuración física del enemigo.
        enemy.physicsBody = SKPhysicsBody(circleOfRadius: enemy.size.width / 2)
        enemy.physicsBody?.isDynamic = true
        enemy.physicsBody?.categoryBitMask = PhysicsCategory.enemy
        enemy.physicsBody?.collisionBitMask = PhysicsCategory.none
        enemy.physicsBody?.contactTestBitMask = PhysicsCategory.laser | PhysicsCategory.ship
        
        // Movimiento sinusoidal hacia abajo.
        let amplitude: CGFloat = .random(in: 75...125)
        let frequency: CGFloat = .random(in: 2...3)
        let duration: TimeInterval = .random(in: 3...6)
        
        let path = CGMutablePath()
        let startX = enemy.position.x
        let startY = enemy.position.y
        path.move(to: CGPoint(x: startX, y: startY))
        
        for i in 0..<Int(frequency * 100) {
            let x = startX + amplitude * sin(CGFloat(i) * .pi / 50)
            let y = startY - CGFloat(i) * ((frame.height + (enemy.size.height * 2)) / (frequency * 100))
            path.addLine(to: CGPoint(x: x, y: y))
        }
        
        let waveAction = SKAction.follow(path, asOffset: false, orientToPath: false, duration: duration)
        let sequence = SKAction.sequence([waveAction, .removeFromParent()])
        
        enemy.run(sequence)
    }
    
    // MARK: - Manejo de Colisiones
    
    /**
     Detecta colisiones entre el láser y los enemigos o la nave y los enemigos.
     */
    func didBegin(_ contact: SKPhysicsContact) {
        let bodyA = contact.bodyA
        let bodyB = contact.bodyB
        
        // Colisión entre láser y enemigo.
        if bodyA.categoryBitMask == PhysicsCategory.laser && bodyB.categoryBitMask == PhysicsCategory.enemy {
            bodyA.node?.removeFromParent()
            bodyB.node?.removeFromParent()
        }

        // Colisión entre nave y enemigo.
        if bodyA.categoryBitMask == PhysicsCategory.ship && bodyB.categoryBitMask == PhysicsCategory.enemy {
            bodyA.node?.removeFromParent()
            bodyB.node?.removeFromParent()
            NotificationCenter.default.post(name: .gameover, object: nil) // Envío de notificación "GAMEOVER".
        }
    }
}

/**
 Extensión de `CGSize` para permitir operaciones matemáticas con `*` y `*=`.
 
 Esta extensión facilita la multiplicación de los valores de ancho y alto de un `CGSize` por un `CGFloat`, evitando tener que multiplicar cada componente por separado.
 */
extension CGSize {
    /// Multiplica las dimensiones (`width` y `height`) por un valor escalar.
    /// - Parameters:
    ///   - lhs: `CGSize` que se va a modificar.
    ///   - rhs: Escalar de tipo `CGFloat` que multiplica el tamaño.
    static func *= (lhs: inout CGSize, rhs: CGFloat) {
        lhs = CGSize(width: lhs.width * rhs, height: lhs.height * rhs)
    }
    
    /// Retorna un nuevo `CGSize` con las dimensiones multiplicadas por un valor escalar.
    /// - Parameters:
    ///   - lhs: `CGSize` original.
    ///   - rhs: Escalar de tipo `CGFloat` que multiplica el tamaño.
    /// - Returns: Un `CGSize` nuevo con las dimensiones ajustadas.
    static func * (lhs: CGSize, rhs: CGFloat) -> CGSize {
        CGSize(width: lhs.width * rhs, height: lhs.height * rhs)
    }
}

/**
 Estructura que define las categorías de colisión en la escena.
 
 En SpriteKit, las categorías de colisión se definen mediante valores de tipo `UInt32` en formato binario. Esto es necesario para utilizar operaciones de máscara de bits (`&`, `|`, etc.) y detectar múltiples categorías de colisión al mismo tiempo.
 
 - Importante:
   Cada categoría debe ser una potencia de 2 para evitar conflictos al realizar operaciones binarias. Esto asegura que cada categoría represente un único bit en el campo de bits.
 */
struct PhysicsCategory {
    /// Categoría "sin colisión" (0000).
    static let none: UInt32 = 0
    /// Categoría del láser (0001).
    static let laser: UInt32 = 0b1 // 1
    /// Categoría del enemigo (0010).
    static let enemy: UInt32 = 0b10 // 2
    /// Categoría de la nave (0100).
    static let ship: UInt32 = 0b100 // 4
}

/**
 Extensión de `Notification.Name` para definir notificaciones personalizadas.
 
 En este caso, se define la notificación `gameover` para informar cuando la nave colisiona con un enemigo y el juego termina.
 */
extension Notification.Name {
    /// Notificación enviada cuando el jugador pierde la partida.
    static let gameover = Notification.Name("GAMEOVER")
}
