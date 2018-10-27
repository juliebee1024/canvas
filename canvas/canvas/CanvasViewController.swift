//
//  CanvasViewController.swift
//  canvas
//
//  Created by Julie Bao on 10/26/18.
//  Copyright © 2018 Julie Bao. All rights reserved.
//

import UIKit

class CanvasViewController: UIViewController {
    @IBOutlet weak var trayView: UIView!
    var trayOriginalCenter: CGPoint!
    var trayDownOffset: CGFloat!
    var trayUp: CGPoint!
    var trayDown: CGPoint!
    
    var newlyCreatedFace: UIImageView!
    var newlyCreatedFaceOriginalCenter: CGPoint! // Create another view controller property to capture the initial center of the new face.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //The trayDownOffset will dictate how much the tray moves down. 160 worked for my tray, but you will likely have to adjust this value to accommodate the specific size of your tray.
        trayDownOffset = 160
        trayUp = trayView.center // The initial position of the tray
        trayDown = CGPoint(x: trayView.center.x ,y: trayView.center.y + trayDownOffset) // The position of the tray transposed down
        
    }
    @IBAction func didPanTray(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        
        if sender.state == .began
        {
            print("at begin")
            //store the tray's center into the trayOriginalCenter variable
            trayOriginalCenter = trayView.center
        }
        else if sender.state == .changed
        {
            print("at changed")
            //change the trayView.center by the translation. Note: we ignore the x translation because we only want the tray to move up and down
            trayView.center = CGPoint(x: trayOriginalCenter.x, y: trayOriginalCenter.y + translation.y)
        }
        else if sender.state == .ended
        {
            print("at ended")
            //Upon release (.ended), the tray should either snap to the open or closed position, depending on the velocity. In other words, if the tray was moving up, animate it to the open position position. If it was moving down, animate it to the closed position
            //1. Get the velocity of the pan gesture recognizer:
            var velocity = sender.velocity(in: view)
            //2. Create two view controller properties to store the tray's position when it's "up" and "down" as well as the offset amount that the tray will move down.
            //trayUp & trayDown
            //3. Assign values to the trayDownOffset, trayUp and trayDown variables in viewDidLoad()
            //4. For the gesture state, .ended, create a conditional statement to check the y component of the velocity.
            //If the velocity.y is greater than 0, it's moving down. Otherwise, it's moving up.
            if(velocity.y > 0) //tray is moving down
            {
                print("tray is moving down, move tray down")
                //animate the tray position to the trayDown point
                UIView.animate(withDuration: 0.5) {
                    self.trayView.center = self.trayDown
                }
                
            }
            else //tray is moving up
            {
                print("tray is moving up, move tray up")
                //animate it towards the trayUp point
                UIView.animate(withDuration: 0.5) {
                    self.trayView.center = self.trayUp
                }
            }
        }
    }
    
    @IBAction func didPanFace(_ sender: UIPanGestureRecognizer) {
        if sender.state == .began
        {
            //create a new image view that contains the same image as the view that was panned on
            var imageView = sender.view as! UIImageView //imageView now refers to the face that you panned on.
            newlyCreatedFace = UIImageView(image: imageView.image) //Create a new image view that has the same image as the one you're currently panning.
            view.addSubview(newlyCreatedFace) //Add the new face to the main view.
            newlyCreatedFace.center = imageView.center //Initialize the position of the new face.
            newlyCreatedFace.center.y += trayView.frame.origin.y //Since the original face is in the tray, but the new face is in the main view, you have to offset the coordinates.
            
            //Now that the new face has been created, we want to actually pan it's position
            newlyCreatedFaceOriginalCenter = newlyCreatedFace.center //
        }
        else if sender.state == .changed
        {
            let translation = sender.translation(in: view)
            //we want to pan the position of the newlyCreatedFace
            newlyCreatedFace.center = CGPoint(x: newlyCreatedFaceOriginalCenter.x + translation.x, y: newlyCreatedFaceOriginalCenter.y + translation.y)
        }
        else if sender.state == .ended
        {
            print("ended state hm")
            
        }
    }
    
}
