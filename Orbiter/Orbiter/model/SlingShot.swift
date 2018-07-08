//
//  Slingshot.swift
//  Orbiter
//
//  Created by Alex Sieber on 7/5/18.
//  Copyright © 2018 Charles Griffin. All rights reserved.
//

import Foundation
import SpriteKit

public class SlingShot: SKShapeNode {
    
    public var k: CGFloat
    public var initPos: CGPoint
    public var finalPos: CGPoint
    public var theta: CGFloat
    public var radius: CGFloat
    //public var ship: Ship
    
    public override init() {
        self.k = 5
        self.initPos = CGPoint(x: 0, y: 0)
        self.finalPos = CGPoint(x: 0, y: 0)
        self.theta = 0
        self.radius = 0
        super.init()
        self.strokeColor = .yellow
        self.path = CGMutablePath()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func attachToInitPos(initPos: CGPoint) {
        
        let path = self.path as! CGMutablePath
        self.initPos = initPos
        path.move(to: self.initPos)
        self.path = path
    }
    
    public func stretchFromInitPosToShip(ship: Ship) {
        
        var path = self.path as! CGMutablePath
        path = CGMutablePath()
        path.move(to: self.initPos)
        self.finalPos = ship.position
        path.addLine(to: self.finalPos)
        self.path = path
        let slingX = self.initPos.x - self.finalPos.x
        let slingY = self.initPos.y - self.finalPos.y
        
        if(slingX >= 0 && slingY >= 0) {
            self.theta = atan( slingY / slingX )
        } else if(slingX <= 0 && slingY >= 0) {
            self.theta = .pi + atan( slingY / slingX )
        } else if(slingX <= 0 && slingY <= 0) {
            self.theta = .pi + atan( slingY / slingX )
        } else {
            self.theta = .pi * 2 + atan( slingY / slingX )
        }
        
        let slingDist = sqrt(slingX * slingX + slingY * slingY)
        self.radius = slingDist
        
        self.lineWidth = ship.size * (0.2 / (1 + (slingDist / ship.size)))
    }
    
    public func slingShip(ship: Ship, forTime: CGFloat) {
        
        let t = forTime
        let m = ship.mass
        let w = sqrt(self.k/m)
        let r = self.radius
        let x0 = ship.position.x
        let y0 = ship.position.y
        let vx0 = ship.velocity.dx
        let vy0 = ship.velocity.dy
        
        print("time: ", t)
        print("mass: ", m)
        print("freq: ", w)
        print("radi: ", r)
        print("theta", self.theta)
        print("(x0,y0): ", x0, y0)
        print("(vx0,vy0): ", vx0, vy0)
        
        //let p0 = sqrt( x0 * x0 + y0 * y0 )
        let p0 = r
        let v0 = sqrt( vx0 * vx0 + vy0 * vy0 )
        
        print("(p0, v0): ", p0, v0)

        let pos =  p0 * cos(w * t) + v0 * sin(w * t) / w
        let vel = -w * p0 * sin(w * t) + v0 * cos(w * t)

        print("(pos, vel): ", pos, vel)
        //print(self.radius, self.theta)
        print("")
        
        ship.position.x -= p0 * cos(self.theta) - pos * cos(self.theta)
        ship.position.y -= p0 * sin(self.theta) - pos * sin(self.theta)

        ship.velocity.dx -= v0 * cos(self.theta) - vel * cos(self.theta)
        ship.velocity.dy -= v0 * sin(self.theta) - vel * sin(self.theta)

        self.radius = pos //wtf

        
        self.stretchFromInitPosToShip(ship: ship)
    }
    
    //just for troubleshooting
    public func printSlingDistance() {
        
        let slingX = self.finalPos.x - self.initPos.x
        let slingY = self.finalPos.y - self.initPos.y
        let slingDist = sqrt(slingX * slingX + slingY * slingY)
        
        print("Sling Distance: ", slingDist)
    }
    
}
