//
//  AnimatedTransitioning.swift
//  MakingSnapchatNavigation
//
//  Created by Victor Hyde on 26/06/2018.
//  Copyright © 2018 Victor Hyde Code. All rights reserved.
//

import Foundation

/// Animation
class AnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning {

    /// Duration of the transition animation.
    fileprivate var animationDuration: TimeInterval!

    /// Is currently performing an animation
    fileprivate var animationStarted = false

    /// Side which de animation will be performed from.
    var fromLeft = false

    var animation: TransitionAnimation = OverlapTransitionAnimation()

    var propAnimator: UIViewPropertyAnimator?

    /// Init with injectable parameters
    ///
    /// - Parameters:
    ///   - animationDuration: time the transitioning animation takes to complete
    init(animationDuration: TimeInterval = 0.33) {
        super.init()
        self.animationDuration = animationDuration
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return (transitionContext?.isAnimated == true) ? animationDuration : 0
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        // Pre check if there's a previous transition runing and cancel the current one.
        if animationStarted {
            return transitionContext.completeTransition(false)
        }

        guard let fromView = transitionContext.view(forKey: .from),
            let toView = transitionContext.view(forKey: .to)
            else {
                return transitionContext.completeTransition(false)
        }

        animationStarted = true

        let duration = transitionDuration(using: transitionContext)
        fromView.endEditing(true)

        let containerView = transitionContext.containerView
        animation.addTo(containerView: containerView, fromView: fromView, toView: toView, fromLeft: fromLeft)
        toView.frame = containerView.bounds
        animation.prepare(fromView: fromView, toView: toView, fromLeft: fromLeft)

        propAnimator = UIViewPropertyAnimator(duration: duration, curve: .easeOut) {
            self.animation.animation(fromView: fromView, toView: toView, fromLeft: self.fromLeft)
        }
        propAnimator?.addCompletion { (position) in
            self.finishedTransition(fromView: fromView,
                                    toView: toView,
                                    in: transitionContext)

        }
        propAnimator?.startAnimation()

    }

    /// Finished transition
    ///
    /// - Parameters:
    ///   - fromView: view we are transitioning from
    ///   - toView: view we are transitioning to
    ///   - context: transitioning context
    private func finishedTransition(fromView: UIView?,
                                    toView: UIView?,
                                    in context: UIViewControllerContextTransitioning) {
        DispatchQueue.main.async {
            self.animationStarted = false
            if context.transitionWasCancelled {
                toView?.removeFromSuperview()
            } else {
                fromView?.removeFromSuperview()
            }
            self.animation.finalize(completed: !context.transitionWasCancelled,
                                    fromView: fromView, toView: toView, fromLeft: self.fromLeft)
            context.completeTransition(!context.transitionWasCancelled)
        }
    }

    func animationEnded(_ transitionCompleted: Bool) {
        if !transitionCompleted {
            propAnimator?.stopAnimation(false)
            propAnimator?.finishAnimation(at: .start)
        }
    }

}
