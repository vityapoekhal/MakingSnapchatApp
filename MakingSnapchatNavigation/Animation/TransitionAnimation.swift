//
//  TransitionAnimation.swift
//  MakingSnapchatNavigation
//
//  Created by Victor Hyde on 26/06/2018.
//  Copyright © 2018 Victor Hyde Code. All rights reserved.
//

import Foundation

public protocol TransitionAnimation {

    /// Setup the views hirearchy for animation.
    func addTo(containerView: UIView, fromView: UIView, toView: UIView, fromLeft: Bool)

    /// Setup the views position prior to the animation start.
    func prepare(fromView from: UIView?, toView to: UIView?, fromLeft: Bool)

    /// The animation.
    func animation(fromView from: UIView?, toView to: UIView?, fromLeft: Bool)

    /// Cleanup the views position after the animation ended.
    func finalize(completed: Bool, fromView from: UIView?, toView to: UIView?, fromLeft: Bool)

}

/// Default interactive animation.
public class OverlapTransitionAnimation: TransitionAnimation {

    /// Setup the views hirearchy for animation.
    public func addTo(containerView: UIView, fromView: UIView, toView: UIView, fromLeft: Bool) {
        if !fromLeft {
            containerView.addSubview(fromView)
            containerView.addSubview(toView)
        } else {
            containerView.addSubview(toView)
            containerView.addSubview(fromView)
        }
    }

    /// Setup the views position prior to the animation start.
    public func prepare(fromView from: UIView?, toView to: UIView?, fromLeft: Bool) {
        let screenWidth = UIScreen.main.bounds.size.width
        if !fromLeft {
            to?.frame.origin.x = fromLeft ? -screenWidth : screenWidth
        }
    }

    /// The animation.
    public func animation(fromView from: UIView?, toView to: UIView?, fromLeft: Bool) {
        let screenWidth = UIScreen.main.bounds.size.width
        if !fromLeft {
            to?.frame.origin.x = 0
        } else {
            from?.frame.origin.x = fromLeft ? screenWidth : -screenWidth
        }
    }

    /// Cleanup the views position after the animation ended.
    public func finalize(completed: Bool, fromView from: UIView?, toView to: UIView?, fromLeft: Bool) {
        if !completed {
            if fromLeft {
                from?.frame.origin.x = 0
            }
        }
    }

}
