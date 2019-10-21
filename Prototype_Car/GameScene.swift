//
//  GameScene.swift
//  Prototype_Car
//
//  Created by MarcoMak on 15/10/2019.
//  Copyright © 2019 MarcoMak. All rights reserved.
//

import SpriteKit
import GameplayKit

class Car : SKSpriteNode {
    
}
enum Location {
    case veryLeft
    case midLeft
    case midRight
    case veryRight
}

var CurrentLocation : Location = Location.midLeft;

class GameScene: SKScene {
    
    var leftCar = Car()
    
    var canMove = false
    var moveToRight = false
    var moveToLeft = false
    
    var veryLeft = false
    var veryRight = false
    var midLeft = true
    var midRight = true
    var centerPoint : CGFloat!
    
    var leftCarMinX = -280
    var leftCarMaxX = 280
    
    override func didMove(to view: SKView) {
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        setUp()
        createRoadStrip()
        //createQuestion()
        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(GameScene.createRoadStrip), userInfo: nil, repeats: true)
        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(GameScene.removeItems), userInfo: nil, repeats: true)
        Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(GameScene.createQuestion), userInfo: nil, repeats: true)
    }
    
    override func update(_ currentTime: TimeInterval) {
        if canMove{
            move(leftside: moveToLeft)
        }
        showRoadStrip()
        print(leftCar.position.x)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let touchlocation = touch.location(in: self)
            if touchlocation.x > centerPoint {
                moveToRight = true
                moveToLeft = false
            } else {
                moveToLeft = true
                moveToRight = false
            }
            canMove = true
        }
    }
    
    func setUp() {
        leftCar = (self.childNode(withName: "leftCar") as! SKSpriteNode) as! Car
        centerPoint = self.frame.size.width / self.frame.size.height
    }
    @objc func createQuestion(){
        let Container = SKShapeNode(rectOf : CGSize(width: 500, height: 300))
        Container.fillColor = SKColor.white
        Container.position = CGPoint(x: frame.midX, y: frame.midY)
        let winner = SKLabelNode(fontNamed: "Chalkduster")
        winner.text = "You Win!"
        winner.fontSize = 65
        winner.fontColor = SKColor.green
        winner.position = CGPoint(x: 0, y: 0)
        Container.addChild(winner)
        addChild(Container)
    }
    @objc func createRoadStrip(){
        let leftRoadStrip = SKShapeNode(rectOf : CGSize(width: 10, height: 40))
        leftRoadStrip.strokeColor = SKColor.white
        leftRoadStrip.fillColor = SKColor.white
        leftRoadStrip.alpha = 0.4
        leftRoadStrip.name = "leftRoadStrip"
        leftRoadStrip.zPosition = 10
        leftRoadStrip.position.x = -187.5
        leftRoadStrip.position.y = 700
        addChild(leftRoadStrip)
        
        let rightRoadStrip = SKShapeNode(rectOf : CGSize(width: 10, height: 40))
        rightRoadStrip.strokeColor = SKColor.white
        rightRoadStrip.fillColor = SKColor.white
        rightRoadStrip.alpha = 0.4
        rightRoadStrip.name = "rightRoadStrip"
        rightRoadStrip.zPosition = 10
        rightRoadStrip.position.x = 187.5
        rightRoadStrip.position.y = 700
        addChild(rightRoadStrip)
    }
    
    func showRoadStrip(){
        enumerateChildNodes(withName: "leftRoadStrip", using: { (roadStrip, stop) in
            let strip = roadStrip as! SKShapeNode
            strip.position.y -= 30
        })
        
        enumerateChildNodes(withName: "rightRoadStrip", using: { (roadStrip, stop) in
            let strip = roadStrip as! SKShapeNode
            strip.position.y -= 30
        })
    }
    
    @objc func removeItems(){
        for child in children {
            if child.position.y < -self.size.height - 100 {
                child.removeFromParent()
            }
        }
    }
    func move(leftside:Bool){
        if leftside {
            leftCar.position.x -= 10
            if leftCar.position.x == CGFloat(-100){
                canMove = false
                CurrentLocation = Location.midLeft
            }
            
            if leftCar.position.x == CGFloat(100){
                canMove = false
                CurrentLocation = Location.midRight
            }
            if leftCar.position.x < CGFloat(leftCarMinX){
                leftCar.position.x = CGFloat(leftCarMinX)
                canMove = false
                CurrentLocation = Location.veryLeft
            }
        } else {
            leftCar.position.x += 10
            if leftCar.position.x == CGFloat(-100){
                canMove = false
                CurrentLocation = Location.midLeft
                
            }
            
            if leftCar.position.x == CGFloat(100){
                canMove = false
                CurrentLocation = Location.midRight
            }
            if leftCar.position.x > CGFloat(leftCarMaxX){
                leftCar.position.x = CGFloat(leftCarMaxX)
                canMove = false
                CurrentLocation = Location.veryRight
            }
        }
    }
    
}

