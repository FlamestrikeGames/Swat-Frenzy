SWBlade
=======

Add a blade effect like fruit ninja for your Sprite Kit (Swift) game.


USAGE

Create a new blade

    var blade:SWBlade = SWBlade(position: CGPoint, target: SKNode, color: UIColor)
    
    // Once a new blade is created you can apply your movement logic in touchesMoved or Update


(Optional) Add Physics Properties

    // a Blade must be created first 

    blade.enablePhysics(categoryBitMask: UInt32, contactTestBitmask: UInt32, collisionBitmask: UInt32)
                           
                           
Implementation with Physics enabled e.g. 

    var blade:SWBlade = SWBlade(position: position, target: self, color: UIColor.whiteColor())
    self.addChild(blade)
        
    blade.enablePhysics(PhysicsCategoryBlade, contactTestBitmask: PhysicsCategoryDummyBox, collisionBitmask: PhysicsCategoryDummyObject)
