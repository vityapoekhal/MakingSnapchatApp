//
//  SnapchatNavigationController.swift
//  MakingSnapchatNavigation
//
//  Created by Victor Hyde on 28/06/2018.
//  Copyright © 2018 Victor Hyde Code. All rights reserved.
//

import UIKit

open class SnapchatNavigationController: UIViewController {

    // MARK: - Views dimensions

    private let swipeIndicatorViewXShift: CGFloat = 20
    private let swipeIndicatorViewWidth: CGFloat = 4

    // MARK: - View controllers

    private let requiredChildrenAmount = 2

    /// top child view controller
    private var topViewController: UIViewController?

    /// all children view controllers
    private var children: [UIViewController] = []

    // MARK: - Views

    private let backgroundViewContainer = UIView()
    private let backgroundBlurEffectView: UIVisualEffectView = {
        let backgroundBlurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let backgroundBlurEffectView = UIVisualEffectView(effect: backgroundBlurEffect)
        backgroundBlurEffectView.alpha = 0
        return backgroundBlurEffectView
    }()

    /// content view for children
    private let contentViewContainer = UIView()

    private let swipeIndicatorView = UIView()

    // MARK: - Animation and transition

    private let swipeAnimator = AnimatedTransitioning()
    private var swipeInteractor: CustomSwipeInteractor!

    // MARK: - Animation transforms

    private var swipeIndicatorViewTransform: CGAffineTransform {
        get {
            return CGAffineTransform(translationX: -contentViewContainer.bounds.size.width + (swipeIndicatorViewXShift * 2) + swipeIndicatorViewWidth, y: 0)
        }
    }

    // MARK: - Colors

    private var tintColor = UIColor(red: 180/255, green: 100/255, blue: 250/255, alpha: 0.5)

    private var swipeIndicatorViewColor: UIColor = .white

    // MARK: - Controller initialization

    override open func viewDidLoad() {
        super.viewDidLoad()

        swipeAnimator.animation = self
        swipeInteractor = CustomSwipeInteractor(with: swipeAnimator)
        swipeInteractor.delegate = self


        view.addSubview(backgroundViewContainer)
        view.addSubview(backgroundBlurEffectView)
        view.addSubview(contentViewContainer)
        view.addSubview(swipeIndicatorView)

        setupViews()

    }

    private func setupViews() {

        view.removeConstraints(view.constraints)
        contentViewContainer.removeConstraints(contentViewContainer.constraints)
        backgroundViewContainer.removeConstraints(backgroundViewContainer.constraints)
        backgroundBlurEffectView.removeConstraints(backgroundBlurEffectView.constraints)

        // Content container
        contentViewContainer.translatesAutoresizingMaskIntoConstraints = false
        contentViewContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        contentViewContainer.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        contentViewContainer.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        contentViewContainer.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true

        // Indicator view
        swipeIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        swipeIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        swipeIndicatorView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -swipeIndicatorViewXShift).isActive = true
        swipeIndicatorView.widthAnchor.constraint(equalToConstant: swipeIndicatorViewWidth).isActive = true
        swipeIndicatorView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        swipeIndicatorView.backgroundColor = swipeIndicatorViewColor
        swipeIndicatorView.layer.cornerRadius = swipeIndicatorViewWidth/2
        swipeIndicatorView.layer.applySketchShadow(alpha: 0.3, y: 0, blur: 10)
        swipeIndicatorView.isUserInteractionEnabled = false

        // Background container
        backgroundViewContainer.translatesAutoresizingMaskIntoConstraints = false
        backgroundViewContainer.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backgroundViewContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        backgroundViewContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        backgroundViewContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true

        backgroundBlurEffectView.translatesAutoresizingMaskIntoConstraints = false
        backgroundBlurEffectView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backgroundBlurEffectView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        backgroundBlurEffectView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        backgroundBlurEffectView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true

        backgroundBlurEffectView.backgroundColor = tintColor

    }

    // MARK: - Private methods

    private func addChild(vc: UIViewController) {

        addChildViewController(vc)
        contentViewContainer.addSubview(vc.view)
        vc.view.frame = contentViewContainer.bounds
        vc.didMove(toParentViewController: self)
        topViewController = vc

        let goignRight = children.index(of: topViewController!) == 0
        swipeInteractor.wireTo(viewController: topViewController!, edge: goignRight ? .right : .left)

    }

    private func removeChild(vc: UIViewController) {
        vc.willMove(toParentViewController: nil)
        vc.view.removeFromSuperview()
        vc.removeFromParentViewController()
        topViewController = nil
    }

    // MARK: - Public interface

    /// Sets view controllers. Required amount is two.
    /// First one is left, second one is right.
    public func setViewControllers(vcs: [UIViewController]) {

        if vcs.count != requiredChildrenAmount {
            return
        }

        children = vcs
        addChild(vc: children[0])

    }

    /// Sets background view.
    public func setBackground(vc: UIViewController) {

        // Setting background only first time
        if backgroundViewContainer.subviews.count > 0 {
            return
        }

        addChildViewController(vc)
        backgroundViewContainer.addSubview(vc.view)

        vc.view.translatesAutoresizingMaskIntoConstraints = false
        vc.view.topAnchor.constraint(equalTo: backgroundViewContainer.topAnchor).isActive = true
        vc.view.bottomAnchor.constraint(equalTo: backgroundViewContainer.bottomAnchor).isActive = true
        vc.view.leadingAnchor.constraint(equalTo: backgroundViewContainer.leadingAnchor).isActive = true
        vc.view.trailingAnchor.constraint(equalTo: backgroundViewContainer.trailingAnchor).isActive = true

        vc.didMove(toParentViewController: self)

    }

    // MARK: - Swipe interaction

    private func transition(from: UIViewController, to: UIViewController, goingRight: Bool, interactive: Bool) {
        let ctx = CustomControllerContext(fromViewController: from,
                                          toViewController: to,
                                          containerView: contentViewContainer,
                                          goingRight: goingRight)
        ctx.isAnimated = true
        ctx.isInteractive = interactive

        ctx.completionBlock = {
            (didComplete: Bool) in
            if didComplete {
                self.removeChild(vc: from)
                self.addChild(vc: to)
            }
        };

        swipeAnimator.fromLeft = !goingRight

        if interactive {
            // Animate with interaction
            swipeInteractor.startInteractiveTransition(ctx)
        } else {
            // Animate without interaction
            swipeAnimator.animateTransition(using: ctx)

        }

    }

}

extension SnapchatNavigationController: CustomSwipeInteractorDelegate {

    func panGestureDidStart(rightToLeftSwipe: Bool) -> Bool {
        guard let topViewController = topViewController,
            let fromIndex = children.index(of: topViewController) else {
                return false
        }
        let newIndex = rightToLeftSwipe ? 1 : 0
        if newIndex > -1 && newIndex < children.count && newIndex != fromIndex {
            transition(from: children[fromIndex], to: children[newIndex], goingRight: rightToLeftSwipe, interactive: true)
            return true
        }
        return false
    }

}

// MARK: - Animation

extension SnapchatNavigationController: TransitionAnimation {

    public func addTo(containerView: UIView, fromView: UIView, toView: UIView, fromLeft: Bool) {
        if !fromLeft {
            containerView.addSubview(fromView)
            containerView.addSubview(toView)
        } else {
            containerView.addSubview(toView)
            containerView.addSubview(fromView)
        }
    }

    public func prepare(fromView from: UIView?, toView to: UIView?, fromLeft: Bool) {
        let screenWidth = UIScreen.main.bounds.size.width
        if !fromLeft {
            to?.frame.origin.x = fromLeft ? -screenWidth : screenWidth
            backgroundBlurEffectView.alpha = 0
            swipeIndicatorView.transform = .identity
            swipeIndicatorView.backgroundColor = swipeIndicatorViewColor
        } else {
            backgroundBlurEffectView.alpha = 1
            swipeIndicatorView.transform = swipeIndicatorViewTransform
            swipeIndicatorView.backgroundColor = tintColor.withAlphaComponent(1)
        }
    }

    public func animation(fromView from: UIView?, toView to: UIView?, fromLeft: Bool) {
        let screenWidth = UIScreen.main.bounds.size.width
        if !fromLeft {
            to?.frame.origin.x = 0
            backgroundBlurEffectView.alpha = 1
            swipeIndicatorView.transform = swipeIndicatorViewTransform
            swipeIndicatorView.backgroundColor = tintColor.withAlphaComponent(1)
        } else {
            from?.frame.origin.x = fromLeft ? screenWidth : -screenWidth
            backgroundBlurEffectView.alpha = 0
            swipeIndicatorView.transform = .identity
            swipeIndicatorView.backgroundColor = swipeIndicatorViewColor
        }
    }

    public func finalize(completed: Bool, fromView from: UIView?, toView to: UIView?, fromLeft: Bool) {
        if !completed {
            if fromLeft {
                from?.frame.origin.x = 0
                backgroundBlurEffectView.alpha = 1
                swipeIndicatorView.transform = swipeIndicatorViewTransform
                swipeIndicatorView.backgroundColor = tintColor.withAlphaComponent(1)
            } else {
                backgroundBlurEffectView.alpha = 0
                swipeIndicatorView.transform = .identity
                swipeIndicatorView.backgroundColor = swipeIndicatorViewColor
            }
        }
    }

}
