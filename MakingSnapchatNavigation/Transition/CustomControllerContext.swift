//
//  NavigationControllerContext.swift
//  MakingSnapchatNavigation
//
//  Created by Victor Hyde on 26/06/2018.
//  Copyright © 2018 Victor Hyde Code. All rights reserved.
//

import Foundation

class CustomControllerContext: NSObject, UIViewControllerContextTransitioning {

    typealias completionBlockType = (Bool) -> Void

    private var viewControllers: [UITransitionContextViewControllerKey: UIViewController]
    private var views: [UITransitionContextViewKey: UIView]
    private var disappearingFromRect: CGRect
    private var appearingFromRect: CGRect
    private var disappearingToRect: CGRect
    private var appearingToRect: CGRect

    var completionBlock: completionBlockType?

    var containerView: UIView
    var isAnimated: Bool = true
    var isInteractive: Bool = false
    var transitionWasCancelled: Bool = false
    var presentationStyle: UIModalPresentationStyle

    init(fromViewController: UIViewController,
         toViewController: UIViewController,
         containerView: UIView,
         goingRight: Bool) {
        self.containerView = containerView
        presentationStyle = .custom
        viewControllers = [.from: fromViewController, .to: toViewController]
        views = [.from: fromViewController.view, .to: toViewController.view]
        let travelDistance = (goingRight ? -containerView.bounds.size.width : containerView.bounds.size.width)
        disappearingFromRect = containerView.bounds
        appearingToRect = containerView.bounds
        disappearingToRect = containerView.bounds.offsetBy(dx: travelDistance, dy: 0)
        appearingFromRect = containerView.bounds.offsetBy(dx: -travelDistance, dy: 0)
    }

    func updateInteractiveTransition(_ percentComplete: CGFloat) {
        // not using
    }

    func finishInteractiveTransition() {
        transitionWasCancelled = false
    }

    func cancelInteractiveTransition() {
        transitionWasCancelled = true
    }

    func pauseInteractiveTransition() {
        // not using
    }

    func completeTransition(_ didComplete: Bool) {
        completionBlock?(didComplete)
    }

    func viewController(forKey key: UITransitionContextViewControllerKey) -> UIViewController? {
        if viewControllers.keys.contains(key) {
            return viewControllers[key]
        }
        return nil
    }

    func view(forKey key: UITransitionContextViewKey) -> UIView? {
        if views.keys.contains(key) {
            return views[key]
        }
        return nil
    }

    var targetTransform: CGAffineTransform = .identity

    func initialFrame(for vc: UIViewController) -> CGRect {
        if vc == viewController(forKey: .from) {
            return disappearingFromRect
        } else {
            return appearingFromRect
        }
    }

    func finalFrame(for vc: UIViewController) -> CGRect {
        if vc == viewController(forKey: .from) {
            return disappearingToRect
        } else {
            return appearingToRect
        }
    }

}
