//
//  ViewController.swift
//  UIKitDynamics on Angry Birds
//
//  Created by Johnny Wang on 2018/5/9.
//  Copyright © 2018年 Johnny Wang. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollisionBehaviorDelegate {
    var animator: UIDynamicAnimator?
    var gravity: UIGravityBehavior?
    var collision: UICollisionBehavior?
    var invisibleView = UIView()
    var bird = UIImageView()
    var pig = UIImageView()
    var verticalWood = UIImageView()
    var horizontalWood = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setScence()
        setDynamicBehavior()
    }

    private func setScence() {
        let screen = UIScreen.main.bounds
        let roleSize = CGSize(width: 30.0, height: 30.0)
        let woodSize = CGSize(width: 120.0, height: 20.0)
        
        let backgroundImageView = UIImageView(frame: screen)
        backgroundImageView.image = #imageLiteral(resourceName: "background")
        backgroundImageView.contentMode = .scaleToFill
        view.addSubview(backgroundImageView)

        //invisible View
        let offset: CGFloat = 50.0
        invisibleView.frame = CGRect(x: 0.0, y: 0.0, width: screen.width, height: screen.height - offset)
        view.addSubview(invisibleView)
        
        //bird
        let birdLocation = CGPoint(x: 10.0, y: 285.0)
        bird.frame = CGRect(origin: birdLocation, size: roleSize)
        bird.image = #imageLiteral(resourceName: "bird")
        bird.contentMode = .scaleAspectFit
        bird.tag = 1
        invisibleView.addSubview(bird)
      
        //vertical wood
        let verticalWoodLocation = CGPoint(x: 420.0, y: 245.0)
        verticalWood.frame = CGRect(origin: verticalWoodLocation, size: woodSize)
        verticalWood.image = #imageLiteral(resourceName: "wood")
        verticalWood.contentMode = .scaleAspectFit
        verticalWood.tag = 2
        verticalWood.transform = CGAffineTransform(rotationAngle: CGFloat.pi/2)
        invisibleView.addSubview(verticalWood)
        
        //horizontal wood
        let horizontalWoodLocation = CGPoint(x: 420.0, y: 175.0)
        horizontalWood.frame = CGRect(origin: horizontalWoodLocation, size: woodSize)
        horizontalWood.image = #imageLiteral(resourceName: "wood")
        horizontalWood.contentMode = .scaleAspectFit
        horizontalWood.tag = 2
        invisibleView.addSubview(horizontalWood)
        
        //pig
        let pigLocation = CGPoint(x: 465.0, y: 145.0)
        pig.frame = CGRect(origin: pigLocation, size: roleSize)
        pig.image = #imageLiteral(resourceName: "pig")
        pig.contentMode = .scaleAspectFit
        pig.tag = 3
        invisibleView.addSubview(pig)
    }
    
    private func setDynamicBehavior() {
        animator = UIDynamicAnimator(referenceView: invisibleView)
        
        //UIGravityBehavior
        gravity = UIGravityBehavior(items: [bird, verticalWood, horizontalWood, pig])
        animator?.addBehavior(gravity!)
        
        //UICollisionBehavior
        collision = UICollisionBehavior(items: [bird, verticalWood, horizontalWood, pig])
        collision?.translatesReferenceBoundsIntoBoundary = true
        collision?.collisionDelegate = self
        animator?.addBehavior(collision!)
        
        //UIDynamicItemBehavior
        let itemBehavior = UIDynamicItemBehavior(items: [verticalWood, horizontalWood])
        itemBehavior.elasticity = 0.4
        itemBehavior.friction = 0.2
        itemBehavior.resistance = 0.2
        itemBehavior.allowsRotation = true
        animator?.addBehavior(itemBehavior)
    }
    
    func collisionBehavior(_ behavior: UICollisionBehavior, endedContactFor item1: UIDynamicItem, with item2: UIDynamicItem) {
        let view1 = item1 as! UIView
        let view2 = item2 as! UIView
        
        //twinkling
        if (view1.tag == 1) {
            view2.alpha = 0.5
       
            UIView.animate(withDuration: 0.5, animations: {
                view2.alpha = 1.0
            })
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for anyObject in touches {
            let hitPoint = anyObject.location(in: invisibleView)
            let birdPoint = bird.frame.origin
            let pushBehavior = UIPushBehavior(items: [bird], mode: .instantaneous)
            
            pushBehavior.pushDirection = CGVector(dx: (hitPoint.x - birdPoint.x)*0.003, dy: (hitPoint.y - birdPoint.y)*0.003)
            animator?.addBehavior(pushBehavior)
            
            return
        }
        
    }
    
}

