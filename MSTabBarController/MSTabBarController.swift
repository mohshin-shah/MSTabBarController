//
//  MSTabBarController.swift
//
//
//  Created by Mohshin Shah on 06/11/2016.
//  Copyright © 2016 Mohshin Shah. All rights reserved.
//

import Foundation
import UIKit

/**
 You use the MSTabarControllerDelegate protocol when you want to
 trace the behavior of a tab bar selection while animating.
 */
public protocol MSTabBarControllerDelegate: NSObjectProtocol {
    
    /**
     This is used for informing the conforming class before performing the switching to the destination controller with animation
     
     - parameter sourceController: Currently selected view controller.
     - parameter destinationController: Destination view controller.
     */
    func willSelectViewController(_ sourceController: UIViewController, destinationController: UIViewController)
    
    /**
     This is used for informing the conforming class after performing the switching to the destination controller with animation
     
     - parameter destinationController: Currently selected view controller.
     */
    func didSelectedViewController(_ destinationController: UIViewController)
}

/**
 @class MSTabBarController
 
 @brief Creates pretty animation while selecting or panning the view
 @superclass SuperClass: UITabBarController\n
 */
open class MSTabBarController: UITabBarController {
    
    ///MSTabBarControllerDelegate delegate
    public var ms_delegate: MSTabBarControllerDelegate?
    
    //Check whether it is interactive animation
    var isInteractive = false
    
    ///Pan gesture direction
    var panDirectionRight = false
    
    /// Main Non Interactive transition instance (MSAnimator)
    var transition = MSTabAnimator()
    
    /// Pan gesture recognizer
    var panGestureRecognizer: UIPanGestureRecognizer?
    
    override open func viewDidLoad() {
        
        super.viewDidLoad()
        self.setUp()
    }
    
    ///Setting up configuration
    func setUp() {
        
        //Creating pan gesture
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector (handlePan(sender:)))
        panGestureRecognizer?.delegate = self
        delegate = self
        view.addGestureRecognizer(panGestureRecognizer!)
    }
    
    ///Handles the pan gesture
    func handlePan(sender: UIPanGestureRecognizer) {
        
        //Translation
        let translation = sender.translation(in: sender.view)
        
        //Ratio
        var ratio = translation.x / (sender.view?.bounds.width)!
        if !panDirectionRight {
            ratio *= -1
        }
        
        //Checking the gesture state
        switch sender.state {
            
        case .began:
            var newSelectedIndex = selectedIndex
            newSelectedIndex += panDirectionRight ? -1 : +1
            isInteractive = true
            self.selectedIndex = newSelectedIndex
            return
            
        case .changed:
            transition.update(ratio)
            return
            
        case .ended,.cancelled:
            transition.finish()
            isInteractive = false
            return
            
        default: break
            
        }
    }
}

extension MSTabBarController : UIGestureRecognizerDelegate {
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        //Velocity
        let velocity: CGPoint = (panGestureRecognizer?.velocity(in: gestureRecognizer.view))!
        
        // accept only horizontal gestures
        if (fabs(velocity.x) < fabs(velocity.y)) {
            return false
        }
        
        //Detecting the pan direction
        panDirectionRight = velocity.x > 0
        
        if (panDirectionRight
            && selectedIndex == 0) {
            return false
        }
        
        if (!panDirectionRight && selectedIndex == (viewControllers?.count)! - 1) {
            return false
        }
        
        return true
    }
    
}

extension MSTabBarController : UITabBarControllerDelegate {
    
    public func tabBarController(_ tabBarController: UITabBarController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        
        return isInteractive ? transition : nil
    }
    
    
    public func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        let fromIndex = viewControllers?.index(of: fromVC)
        let toIndex = viewControllers?.index(of: toVC)
        transition.isPresenting = (fromIndex! < toIndex!)
        
        //Delegate call back before animating
        ms_delegate?.willSelectViewController(fromVC, destinationController: toVC)
        return transition
    }
    
    
    public func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        return !transition.isAnimating
    }
}
