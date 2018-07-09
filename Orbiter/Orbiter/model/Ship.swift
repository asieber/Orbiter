//
//  Ship.swift
//  Orbiter
//
//  Created by Alex Sieber on 7/5/18.
//  Copyright © 2018 Charles Griffin. All rights reserved.
//

import Foundation
import SpriteKit

public class Ship: SKShapeNode {
    
    public var mass: CGFloat
    public var size: CGFloat
    public var velocity : CGVector
    
    //required by Swift for implementation
    public override init() {
        self.mass = 1
        self.size = 1
        self.velocity = CGVector(dx: 0, dy: 0)
        super.init()
        self.position = CGPoint(x: 0, y: 0)
        self.fillColor = .brown
    }
    //the desired contructor for initializing a new Ship object with size relative to the screen
    public convenience init(size: CGFloat) {
        self.init(rectOf: CGSize.init(width: size, height: size), cornerRadius: size * 0.3)
        self.mass = 1
        self.size = size
        //self.velocity = CGVector(dx: -100, dy: -100)
        self.velocity = CGVector(dx: 0, dy: 0)
        self.position = CGPoint(x: 0, y: 0)
        self.fillColor = .brown
    }
    //required by Swift
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
