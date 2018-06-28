//
//  GradientView.swift
//  MakingSnapchatApp
//
//  Created by Victor Hyde on 28/06/2018.
//  Copyright © 2018 Victor Hyde Code. All rights reserved.
//

import UIKit

class GradientView: UIView {

    let gradientLayer = CAGradientLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        gradientLayer.colors = [UIColor.white.cgColor,
                                UIColor(red: 109/255, green: 213/255, blue: 250/255, alpha: 1).cgColor,
                                UIColor(red: 41/255,  green: 128/255, blue: 185/255, alpha: 1).cgColor]
        layer.addSublayer(gradientLayer)
    }

    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        gradientLayer.frame = bounds
    }

}
