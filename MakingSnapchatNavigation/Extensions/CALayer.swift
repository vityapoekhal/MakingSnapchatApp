//
//  CALayer.swift
//  MakingSnapchatNavigation
//
//  Created by Victor Hyde on 26/06/2018.
//  Copyright © 2018 Victor Hyde Code. All rights reserved.
//

import Foundation

extension CALayer {

    /// Applies shadow in a Sketch manner.
    /// Through the courtesy of Senseful.
    /// https://stackoverflow.com/a/48489506
    public func applySketchShadow(
        color:  UIColor = .black,
        alpha:    Float = 0.5,
        x:      CGFloat = 0,
        y:      CGFloat = 2,
        blur:   CGFloat = 4,
        spread: CGFloat = 0)
    {
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur / 2.0
        if spread == 0 {
            shadowPath = nil
        } else {
            let dx = -spread
            let rect = bounds.insetBy(dx: dx, dy: dx)
            shadowPath = UIBezierPath(rect: rect).cgPath
        }
    }

}
