//
//  WKLNFlickManagerViewController.swift
//  Pods
//
//  Created by Charles Vinette on 2016-03-28.
//
//

import UIKit


class FlickManager: UIViewController, UIGestureRecognizerDelegate {
	
	// MARK:Constants
	let throwingThreshold: CGFloat = 1000
	let throwingVelocityPadding: CGFloat = 10
	
	//MARK Variables
	var leftButtonSize: Int = 120
	var rightButtonSize: Int = 120
	
	var tap: UIGestureRecognizer!
	var receivedView: UIView!
	var animator: UIDynamicAnimator!
	var originalBounds: CGRect!
	var originalCenter: CGPoint!
	var attachmentBehavior: UIAttachmentBehavior!
	var push: UIPushBehavior!
	var itemBehavior: UIDynamicItemBehavior!
	var popupMovedVertically:Bool!
	var leftButton:UIButton!
	var rightButton:UIButton!
	var didDragToLeft = false
	var didDragToRight = false
	var viewToAddFlick: UIView!
	
	//MARK: Initialization
	
	init(backgroundView:UIView, viewToAddFlick: UIView){
		super.init(nibName: nil, bundle: nil)
		self.view = backgroundView
		self.viewToAddFlick = viewToAddFlick
		self.createWithView(viewToAddFlick)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func createWithView(view:UIView){
		
		//Right and Left Button
		
		let leftButton = UIButton()
		self.leftButton = leftButton
		leftButton.alpha = 0
		self.view.addSubview(leftButton)
		
		let rightButton = UIButton()
		self.rightButton = rightButton
		self.view.addSubview(rightButton)
		
		//Adds the ViewToAddFlick
		self.view.addSubview(view)
		
		let animator = UIDynamicAnimator(referenceView: self.view)
		self.animator = animator
		self.originalBounds = view.bounds
		self.originalCenter = self.view.center
		
		let panGesture = UIPanGestureRecognizer()
		panGesture.addTarget(self, action: #selector(FlickManager.handleAttachmentGesture))
		self.view.addGestureRecognizer(panGesture)

	}
	
	
	func handleAttachmentGesture(panGesture: UIPanGestureRecognizer) {
		let location = panGesture.locationInView(self.view)
		let boxLocation = panGesture.locationInView(self.viewToAddFlick)
		
		let initialMidX = CGRectGetMidX(self.viewToAddFlick.bounds)
		
		if panGesture.state == .Began {
			
			self.animator.removeAllBehaviors()
			let centerOffset = UIOffsetMake(boxLocation.x - CGRectGetMidX(self.viewToAddFlick.bounds), boxLocation.y - CGRectGetMidY(self.viewToAddFlick.bounds))
			self.attachmentBehavior = UIAttachmentBehavior(item: self.viewToAddFlick, offsetFromCenter: centerOffset, attachedToAnchor: location)
			self.animator.addBehavior(attachmentBehavior)
		}
		
		if panGesture.state == .Changed{
			
			if self.viewToAddFlick.frame.midX > initialMidX + 150{
				//Right
				self.leftButton.alpha = (self.view.frame.midX - (initialMidX + 150)) * 0.03
				if self.leftButton.alpha >= 1{
					self.leftButton.alpha = 1
					self.didDragToRight = true
				}
			}else if self.viewToAddFlick.frame.midX < initialMidX - 150{
				//Left
				self.rightButton.alpha = ((initialMidX - 150) - self.view.frame.midX) * 0.03
				if self.rightButton.alpha >= 1{
					self.rightButton.alpha = 1
					self.didDragToLeft = true
				}
			}
		}
		
		if panGesture.state == .Ended {
			
			if self.viewToAddFlick.frame.midX > initialMidX + 100{
				//Right
				popupMovedVertically = false
				
			}else if self.viewToAddFlick.frame.midX < initialMidX - 100{
				//Left
				popupMovedVertically = false
			}else{
				popupMovedVertically = true
			}
			
			
			UIView.animateWithDuration(0.3, animations: {
				self.leftButton.alpha = 0
				self.rightButton.alpha = 0
			})
			self.animator.removeAllBehaviors()
			
			let velocity = panGesture.velocityInView(self.view)
			let magnitude: CGFloat = sqrt((CGFloat(velocity.x * velocity.x) + CGFloat(velocity.y * velocity.y)))
			
			if magnitude > throwingThreshold && popupMovedVertically  {
				let push = UIPushBehavior(items: [self.view], mode: .Instantaneous)
				push.pushDirection = CGVectorMake((velocity.x / 10), (velocity.y / 10))
				push.magnitude = magnitude / throwingVelocityPadding
				self.push = push
				self.animator.addBehavior(push)
				//				self.performSelector("recenterView", withObject: nil, afterDelay: 0.4)
				
				self.dismissViewControllerAnimated(true, completion: nil)
			} else {
				//				AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
				self.recenterView()
				if didDragToLeft{
					didDragToLeft = false
					rightButton.sendActionsForControlEvents(.TouchUpInside)
				}
				if didDragToRight{
					didDragToRight = false
					leftButton.sendActionsForControlEvents(.TouchUpInside)
				}
			}
		} else {
			self.attachmentBehavior.anchorPoint = panGesture.locationInView(self.view)
		}
	}
	
	func recenterView() {
		self.animator.removeAllBehaviors()
		UIView.animateWithDuration(0.5) { () -> Void in
			
			self.view.bounds = self.view.bounds
			self.view.center = self.view.center
			self.view.transform = CGAffineTransformIdentity
		}
	}
}