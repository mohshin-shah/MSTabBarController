//
//  MSTabAnimator.swift
//
//
//  Created by Mohshin Shah on 06/11/2016.
//  Copyright © 2016 Mohshin Shah. All rights reserved.
//

import Foundation
import UIKit

///Default animation duration
let kAnimationDuration: TimeInterval = 0.1

public class MSTabAnimator: UIPercentDrivenInteractiveTransition, UIViewControllerAnimatedTransitioning {
    
    //Check whether it is animating
    var isAnimating = false
    
    //Check whether it is presenting
    var isPresenting = true
    
    
    //---------------------------------------
    // MARK: - UIViewControllerAnimatedTransitioning
    //---------------------------------------
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        
        return kAnimationDuration
    }
    
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let fromViewController = transitionContext.viewController(forKey: .from)
        let toViewController = transitionContext.viewController(forKey: .to)
        
        let endFrame = transitionContext.containerView.bounds
        
        //Check if presenting
        if (self.isPresenting) {
            transitionContext.containerView.insertSubview((toViewController?.view)!, belowSubview: (fromViewController?.view)!)
            
            var startFrame = endFrame
            startFrame.origin.x += transitionContext.containerView.bounds.width
            
            toViewController?.view.frame = startFrame
            
            var endFrameFromView = endFrame
            endFrameFromView.origin.x -= transitionContext.containerView.bounds.width
            
            UIView.animate(withDuration: self.transitionDuration(using: transitionContext), delay: 0.0, options: .curveLinear, animations: {
                
                toViewController?.view.frame = endFrame
                fromViewController?.view.frame = endFrameFromView
                
                }, completion: { (finished) in
                    let didComplete = !transitionContext.transitionWasCancelled
                    transitionContext .completeTransition(didComplete)
            })
        } else {
            
            transitionContext.containerView.insertSubview((toViewController?.view)!, aboveSubview: (fromViewController?.view)!)
            
            var startFrameToView = endFrame
            startFrameToView.origin.x -= transitionContext.containerView.bounds.width
            toViewController?.view.frame = startFrameToView
            
            var endFrameFromView = endFrame
            endFrameFromView.origin.x += transitionContext.containerView.bounds.width
            
            UIView.animate(withDuration: self.transitionDuration(using: transitionContext), delay: 0.0, options: .curveLinear, animations: {
                
                fromViewController?.view.frame = endFrameFromView
                toViewController?.view.frame = endFrame
                
                }, completion: { (finished) in
                    let didComplete = !transitionContext.transitionWasCancelled
                    transitionContext .completeTransition(didComplete)
            })
        }
        
        //Setting animation flag true
        isAnimating = true
    }
    
    public func animationEnded(_ transitionCompleted: Bool) {
        
        //Setting animation flag to false
        isAnimating = false
    }
    
    
}
