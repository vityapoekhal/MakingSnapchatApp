//
//  PercentDrivenInteractiveTransition.swift
//  MakingSnapchatNavigation
//
//  Created by Victor Hyde on 26/06/2018.
//  Copyright © 2018 Victor Hyde Code. All rights reserved.
//

import Foundation

class PercentDrivenInteractiveTransition: NSObject, UIViewControllerInteractiveTransitioning {

    /// Actual animation
    private let animator: UIViewControllerAnimatedTransitioning

    private var duration: TimeInterval {
        return transitionContext != nil ? animator.transitionDuration(using: transitionContext!) : 0
    }

    private var transitionContext: UIViewControllerContextTransitioning?
    private var displayLink: CADisplayLink?

    // MARK: - UIViewControllerInteractiveTransitioning

    var completionSpeed: CGFloat = 1
    let animationCurve: UIViewAnimationCurve = .linear

    // MARK: - Init

    init(with animator: UIViewControllerAnimatedTransitioning) {
        self.animator = animator
    }

    // MARK: - Public

    func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        self.transitionContext = transitionContext
        transitionContext.containerView.superview?.layer.speed = 0
        animator.animateTransition(using: transitionContext)
    }

    func updateInteractiveTransition(percentComplete: CGFloat) {
        setPercentComplete(percentComplete: (CGFloat(fmaxf(fminf(Float(percentComplete), 1), 0))))
    }

    func cancelInteractiveTransition() {
        transitionContext?.cancelInteractiveTransition()
        completeTransition()
    }
    func finishInteractiveTransition() {
        transitionContext?.finishInteractiveTransition()
        completeTransition()
    }

    // MARK: - Private

    private func setPercentComplete(percentComplete: CGFloat) {
        setTimeOffset(timeOffset: TimeInterval(percentComplete) * duration)
        transitionContext?.updateInteractiveTransition(percentComplete)
    }

    private func setTimeOffset(timeOffset: TimeInterval) {
        transitionContext?.containerView.superview?.layer.timeOffset = timeOffset
    }

    private func completeTransition() {
        displayLink = CADisplayLink(target: self, selector: #selector(tickAnimation))
        displayLink!.add(to: .main, forMode: .commonModes)
    }

    @objc private func tickAnimation() {

        var timeOffset = self.timeOffset()
        let tick = (displayLink?.duration ?? 0) * TimeInterval(completionSpeed)
        timeOffset += (transitionContext?.transitionWasCancelled ?? false) ? -tick : tick;

        if (timeOffset < 0 || timeOffset > duration) {
            transitionFinished()
        } else {
            setTimeOffset(timeOffset: timeOffset)
        }
    }

    private func timeOffset() -> TimeInterval {
        return transitionContext?.containerView.superview?.layer.timeOffset ?? 0
    }

    private func transitionFinished() {
        displayLink?.invalidate()

        guard let layer = transitionContext?.containerView.superview?.layer else {
            return
        }
        layer.speed = 1;

        let wasNotCanceled = !(transitionContext?.transitionWasCancelled ?? false)
        if (wasNotCanceled) {
            let pausedTime = layer.timeOffset
            layer.timeOffset = 0.0;
            let timeSincePause = layer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
            layer.beginTime = timeSincePause
        }

        animator.animationEnded?(wasNotCanceled)
    }

}
