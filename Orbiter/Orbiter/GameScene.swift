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
    
    private var ship : Ship?
    private var slingShot : SlingShot?
    //previousTime used for calculating change in time (dt) between each frame (usually ~1/60 seconds)
    private var previousTime : TimeInterval?
    
    override func didMove(to view: SKView) {
        //initialize instance variables when sthe controller switches to this view
        let screenSize = (self.size.width + self.size.height) * 0.05
        self.ship = Ship(size: screenSize)
        self.slingShot = SlingShot()
        self.addChild(self.ship!)
        self.previousTime = -1
        print("STARTING APP")
    }
    
    //when you place your finger on the screen
    func touchDown(atPoint pos : CGPoint) {
        //place the ship at the position
        self.ship?.position = pos
        self.ship?.velocity.dx = 0
        self.ship?.velocity.dy = 0
        //anchor the slingshot to the point you touched
        self.slingShot = SlingShot()
        self.slingShot?.attachToInitPos(initPos: pos)
        //add the slingshot to the scene
        self.addChild(self.slingShot!)
    }
    
    //when you touch a point on the screen
    func touchMoved(toPoint pos : CGPoint) {
        //update the ship's position
        self.ship?.position = pos
        //redraw the slingshot
        self.slingShot?.stretchFromInitPosToShip(ship: self.ship!)
    }
    
    //when you lift your finger off the screen
    func touchUp(atPoint pos : CGPoint) {
        //don't sling the ship unless you drag it greater than 100 pixels from its initial position
        if(self.slingShot?.radius.isLess(than: CGFloat(100)))! {
            self.slingShot?.isSlinging = false
        } else {
            self.slingShot?.isSlinging = true
        }
        //get rid of the slingshot from the scene if it isn't currently slinging
        if(!(self.slingShot?.isSlinging)!) {
            self.slingShot?.removeFromParent()
        }
    }
    
    //the below 4 methods were not added by Alex
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
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
    
    //update the model data and redraw the scene at the beginning of each new frame (every 1/60 of a second)
    override func update(_ currentTime: TimeInterval) {
        //use previous time for calculating change in time (dt) between each frame (usually ~1/60 seconds)
        if(previousTime == -1) {
            self.previousTime = currentTime
            print("INITIALIZING PREVIOUS TIME")
            return
        }
        let dt = CGFloat(currentTime - self.previousTime!)
        
        if(self.slingShot?.isSlinging)! { //animate the ship when it's slinging (accelerating)
            
            self.slingShot?.slingShip(ship: self.ship!, forTime: dt) //this method changes the ships position accordingly
            
        } else { //animate the ship when it's not slinging (constant velocity)
            
            let vx = self.ship?.velocity.dx //straightforward kinematic equations
            let vy = self.ship?.velocity.dy
            
            self.ship?.position.x -= vx! * dt
            self.ship?.position.y -= vy! * dt
        }
        self.previousTime = currentTime
    }
}
