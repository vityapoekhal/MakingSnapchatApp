//
//  SwipeInteractor.swift
//  MakingSnapchatNavigation
//
//  Created by Victor Hyde on 26/06/2018.
//  Copyright © 2018 Victor Hyde Code. All rights reserved.
//

import Foundation

// MARK: - Interactor Delegate

protocol CustomSwipeInteractorDelegate {
    func panGestureDidStart(rightToLeftSwipe: Bool) -> Bool
}

// MARK: - Interactor

class CustomSwipeInteractor: PercentDrivenInteractiveTransition {

    // MARK: - Interaction constants

    private let xVelocityForComplete: CGFloat = 200.0

    // MARK: - Variables

    private var panRecognizer: UIScreenEdgePanGestureRecognizer?

    private var interactionInProgress = false
    private var shouldCompleteTransition = false
    private var rightToLeftSwipe = false

    // MARK: - Interface

    var delegate: CustomSwipeInteractorDelegate?

    public func wireTo(viewController: UIViewController, edge: UIRectEdge) {

        if let panRecognizer = panRecognizer {
            panRecognizer.view?.removeGestureRecognizer(panRecognizer)
        }

        panRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        panRecognizer!.edges = edge
        viewController.view.addGestureRecognizer(panRecognizer!)

    }

    // MARK: - Private

    /// Handles the swiping with progress
    ///
    /// - Parameter recognizer: `UIPanGestureRecognizer` in the current tab controller's view.
    @objc private func handlePan(_ recognizer: UIPanGestureRecognizer) {

        let velocity = recognizer.velocity(in: recognizer.view)

        switch recognizer.state {
        case .began:

            rightToLeftSwipe = velocity.x < 0

            // Starting gesture if allowed
            if delegate?.panGestureDidStart(rightToLeftSwipe: rightToLeftSwipe) ?? false {
                interactionInProgress = true
            } else {
                interactionInProgress = false
            }

        case .changed:
            if interactionInProgress {

                let translation = recognizer.translation(in: recognizer.view?.superview)
                let translationValue = translation.x/UIScreen.main.bounds.size.width

                var fraction = fabs(translationValue)
                fraction = min(max(fraction, 0.0), 0.99)
                shouldCompleteTransition = (fraction > 0.5);

                updateInteractiveTransition(percentComplete: fraction)
            }

        case .ended, .cancelled:
            if interactionInProgress {
                interactionInProgress = false

                if !shouldCompleteTransition {
                    if (rightToLeftSwipe && velocity.x < -xVelocityForComplete) {
                        shouldCompleteTransition = true
                    } else if (!rightToLeftSwipe && velocity.x > xVelocityForComplete) {
                        shouldCompleteTransition = true
                    }
                }

                if !shouldCompleteTransition || recognizer.state == .cancelled {
                    cancelInteractiveTransition()
                } else {
                    // Avoid launching a new transaction while the previous one is finishing.
                    panRecognizer?.isEnabled = false
                    finishInteractiveTransition()
                }
            }

        default:
            break

        }

    }

}
