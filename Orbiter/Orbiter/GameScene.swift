//
//  GameScene.swift
//  Orbiter
//
//  Created by Alex Sieber on 7/7/18.
//  Copyright © 2018 Alex Sieber. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    //    private var label : SKLabelNode?
    //    private var spinnyNode : SKShapeNode?
    
    private var ship : Ship?
    private var slingShot : SlingShot?
    private var slinging : Bool?
    
    private var previousTime : TimeInterval?
    
    override func didMove(to view: SKView) {
        
        // Get label node from scene and store it for use later
        //        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
        //        if let label = self.label {
        //            label.alpha = 0.0
        //            label.run(SKAction.fadeIn(withDuration: 2.0))
        //        }
        
        // Create shape node to use during mouse interaction
        //        let w = (self.size.width + self.size.height) * 0.05
        //        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
        //
        //        if let spinnyNode = self.spinnyNode {
        //            spinnyNode.lineWidth = 2.5
        //
        //            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
        //            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
        //                                              SKAction.fadeOut(withDuration: 0.5),
        //                                              SKAction.removeFromParent()]))
        //        }
        
        let screenSize = (self.size.width + self.size.height) * 0.05
        
        self.ship = Ship(size: screenSize)
        self.slingShot = SlingShot()
        self.slinging = false
        
        self.addChild(self.ship!)
        
        self.previousTime = -1
        
        print("STARTING APP")
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        //        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
        //            n.position = pos
        //            n.strokeColor = SKColor.green
        //            self.addChild(n)
        //        }
        
        self.ship?.position = pos
        self.ship?.velocity.dx = 0
        self.ship?.velocity.dy = 0
        self.slinging = false
        self.slingShot = SlingShot()
        self.slingShot?.attachToInitPos(initPos: pos)
        self.addChild(self.slingShot!)
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        //        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
        //            n.position = pos
        //            n.strokeColor = SKColor.blue
        //            self.addChild(n)
        //        }
        
        self.ship?.position = pos
        self.slingShot?.stretchFromInitPosToShip(ship: self.ship!)
    }
    
    func touchUp(atPoint pos : CGPoint) {
        //        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
        //            n.position = pos
        //            n.strokeColor = SKColor.red
        //            self.addChild(n)
        //        }
        
        if(self.slingShot?.radius.isLess(than: CGFloat(100)))! {
            self.slinging = false
        } else {
            self.slinging = true
        }
        
        if(!self.slinging!) {
            self.slingShot?.removeFromParent() //self.slingshot still has persistent data after this?
        }
        
        //print(self.slingShot?.radius, self.slingShot?.theta)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //        if let label = self.label {
        //            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        //        }
        
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        if(previousTime == -1) {
            self.previousTime = currentTime
            print("INITIALIZING PREVIOUS TIME")
            return
        }
        let dt = CGFloat(currentTime - self.previousTime!)
        
//        if(self.slingShot?.radius.isLess(than: 0))! {
//            self.slinging = false
//        }
        
        if(self.slinging!) {
            self.slingShot?.slingShip(ship: self.ship!, forTime: dt)
            self.slingShot?.stretchFromInitPosToShip(ship: self.ship!)
        } else {
            //self.slingShot?.removeFromParent()
        }
        
//        if(self.slinging!) {
//
//            self.slingShot?.slingShip(ship: self.ship!, forTime: dt)
//
//        } else {
//
//            let vx = self.ship?.velocity.dx
//            let vy = self.ship?.velocity.dy
//
//            self.ship?.position.x += vx! * dt
//            self.ship?.position.y += vy! * dt
//        }
        
//        let vx = self.ship?.velocity.dx
//        let vy = self.ship?.velocity.dy
//
//        self.ship?.position.x += vx! * dt
//        self.ship?.position.y += vy! * dt
        
        self.previousTime = currentTime
        
        //print(self.ship?.position)
        //print(dt)
        
        //        //ideally want something like this:
        //        if(self.slingShot != nil && self.slingShot.isAttchedToShip) {
        //
        //            let vx = self.ship?.velocity.dx
        //            let vy = self.ship?.velocity.dy
        //
        //            let dt = CGFloat(currentTime - self.previousTime!)
        //
        //            self.ship?.position.x += vx! * dt
        //            self.ship?.position.y += vy! * dt
        //
        //            let x = self.slingShot?.length
        //            let k = self.slingShot?.k
        //            let f = -k * x
        //            let a = f / self.ship?.mass
        //
        //            let ax = a * cos(self.slingShot.theta)
        //            let ay = a * sin(self.slingShot.theta)
        //
        //            let dvx = ax * dt
        //            let dvy = ay * dt
        //
        //            self.ship?.velocity.dx += dvx
        //            self.ship?.velocity.dy += dvy
        //        }
    }
}
