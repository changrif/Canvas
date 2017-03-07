//
//  ViewController.swift
//  Canvas
//
//  Created by Chandler Griffin on 3/6/17.
//  Copyright © 2017 Chandler Griffin. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

    @IBOutlet weak var trayView: UIView!
    @IBOutlet weak var happyEmojiView: UIImageView!
    @IBOutlet weak var winkyEmojiView: UIImageView!
    @IBOutlet weak var openMouthEmojiView: UIImageView!
    @IBOutlet weak var sadEmojiView: UIImageView!
    @IBOutlet weak var openWinkyEmojiView: UIImageView!
    @IBOutlet weak var astonishedEmojiView: UIImageView!
    @IBOutlet weak var arrowImageView: UIImageView!
    
    var originalCenter: CGPoint?
    var trayCenterWhenOpen: CGPoint?
    var trayCenterWhenClosed: CGPoint?
    var frictionalDrag: CGFloat!
    
    var newlyCreatedFace: UIImageView?
    var faceOriginalCenter: CGPoint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        happyEmojiView.image = #imageLiteral(resourceName: "tongue")
        winkyEmojiView.image = #imageLiteral(resourceName: "sad")
        openMouthEmojiView.image = #imageLiteral(resourceName: "wink")
        sadEmojiView.image = #imageLiteral(resourceName: "excited")
        openWinkyEmojiView.image = #imageLiteral(resourceName: "happy")
        astonishedEmojiView.image = #imageLiteral(resourceName: "dead")
        arrowImageView.image = #imageLiteral(resourceName: "down_arrow")
        
        trayCenterWhenOpen = CGPoint(x: 187.5, y: 620)
        trayCenterWhenClosed = CGPoint(x: 187.5, y: 820)
        trayView.center = trayCenterWhenClosed!
        frictionalDrag = 10
        self.flipArrow(angle: M_PI)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func rotateImage(_ sender: UIRotationGestureRecognizer) {
        self.newlyCreatedFace = (sender.view as! UIImageView)
        let rotation = sender.rotation
        self.newlyCreatedFace?.transform = (self.newlyCreatedFace?.transform.rotated(by: rotation))!
        sender.rotation = 0
    }
    
    func pinchImage(_ sender: UIPinchGestureRecognizer)   {
        self.newlyCreatedFace = (sender.view as! UIImageView)
        let scale = sender.scale
        self.newlyCreatedFace?.transform = (self.newlyCreatedFace?.transform.scaledBy(x: scale, y: scale))!
        sender.scale = 1
    }
    
    func continueEditingImage(_ sender: UIPanGestureRecognizer)   {
        let translation = sender.translation(in: self.view)
        
        if sender.state == UIGestureRecognizerState.began {
            self.newlyCreatedFace = (sender.view as! UIImageView)
            faceOriginalCenter = self.newlyCreatedFace?.center
        } else if sender.state == UIGestureRecognizerState.changed {
            var center = faceOriginalCenter
            center?.x += translation.x
            center?.y += translation.y
            self.newlyCreatedFace?.center = center!
        }   else if sender.state == UIGestureRecognizerState.ended  {
        }

    }
    
    func deleteFace(_ sender: UITapGestureRecognizer)   {
        self.newlyCreatedFace = (sender.view as! UIImageView)
        self.newlyCreatedFace?.removeFromSuperview()
    }
    
    @IBAction func onEmojiViewPanGesture(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: self.view)
        
        if sender.state == UIGestureRecognizerState.began {
            let imageView = sender.view as? UIImageView
            
            self.newlyCreatedFace = UIImageView.init(image: imageView?.image)
            
            
            let panGesture = UIPanGestureRecognizer(target: self, action: (#selector(self.continueEditingImage(_:))))
            let pinchGesture = UIPinchGestureRecognizer(target: self, action: (#selector(self.pinchImage(_:))))
            let rotateGesture = UIRotationGestureRecognizer(target: self, action: (#selector(self.rotateImage(_:))))
            let tapGesture = UITapGestureRecognizer(target: self, action: (#selector(self.deleteFace(_:))))
            tapGesture.numberOfTapsRequired = 2
            pinchGesture.delegate = self
            rotateGesture.delegate = self
            self.newlyCreatedFace?.isUserInteractionEnabled = true
            
            self.newlyCreatedFace?.addGestureRecognizer(panGesture)
            self.newlyCreatedFace?.addGestureRecognizer(pinchGesture)
            self.newlyCreatedFace?.addGestureRecognizer(rotateGesture)
            self.newlyCreatedFace?.addGestureRecognizer(tapGesture)
            
            self.view.addSubview(self.newlyCreatedFace!)
            self.newlyCreatedFace?.center = (imageView?.center)!
            
            let newFaceCenter = self.newlyCreatedFace?.center
            self.newlyCreatedFace?.center.y = (newFaceCenter?.y)! + trayView.frame.origin.y
            faceOriginalCenter = self.newlyCreatedFace?.center
            
            UIView.animate(withDuration: 0.2, animations: {
                self.newlyCreatedFace?.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            })
        } else if sender.state == UIGestureRecognizerState.changed {
            var center = faceOriginalCenter
            center?.x += translation.x
            center?.y += translation.y
            self.newlyCreatedFace?.center = center!
        }   else if sender.state == UIGestureRecognizerState.ended  {
            UIView.animate(withDuration: 0.2, animations: {
                self.newlyCreatedFace?.transform = CGAffineTransform(scaleX: 1, y: 1)
                
                if (((self.newlyCreatedFace?.center.y)! + CGFloat(30)) > CGFloat(417)   ){
                    self.newlyCreatedFace?.center.y = (sender.view?.center.y)! + self.trayView.frame.origin.y
                    self.newlyCreatedFace?.center.x = (sender.view?.center.x)!
                }

            }, completion: { (Bool) in
                if (((self.newlyCreatedFace?.center.y)! + CGFloat(30)) > CGFloat(417)){
                    self.newlyCreatedFace?.removeFromSuperview()
                }
            })
        }
    }
    
    func flipArrow(angle: Double)    {
        arrowImageView.transform = CGAffineTransform(rotationAngle: CGFloat(angle))
    }
    
    @IBAction func onTrayTapGesture(_ sender: UITapGestureRecognizer) {
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 2, options: [], animations: {
            if self.trayView.center == self.trayCenterWhenOpen!    {
                self.trayView.center = self.trayCenterWhenClosed!
                self.flipArrow(angle: M_PI)
            }   else if self.trayView.center == self.trayCenterWhenClosed!    {
                self.trayView.center = self.trayCenterWhenOpen!
                self.flipArrow(angle: 0)
            }
        }, completion: nil)
    }
    
    @IBAction func onTrayPanGesture(_ sender: UIPanGestureRecognizer) {
        var translation = sender.translation(in: self.view)
        let velocity = sender.velocity(in: self.view)
        
        if sender.state == UIGestureRecognizerState.began {
            originalCenter = trayView.center
        } else if sender.state == UIGestureRecognizerState.changed {
            if trayView.center.y + translation.y < (trayCenterWhenOpen?.y)!   {
                originalCenter = trayView.center
                sender.setTranslation(CGPoint.zero, in: view)
                translation.y /= frictionalDrag
            }
            trayView.center.y = (originalCenter?.y)! + translation.y
        } else if sender.state == UIGestureRecognizerState.ended {
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 2, options: [], animations: {
                if velocity.y > 0   {
                    self.trayView.center = self.trayCenterWhenClosed!
                    self.flipArrow(angle: M_PI)
                }   else    {
                    self.trayView.center = self.trayCenterWhenOpen!
                    self.flipArrow(angle: 0)
                }
            }, completion: nil)
        }
    }

}

