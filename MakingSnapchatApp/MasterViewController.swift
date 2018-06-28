//
//  MasterViewController.swift
//  MakingSnapchatApp
//
//  Created by Victor Hyde on 27/06/2018.
//  Copyright © 2018 Victor Hyde Code. All rights reserved.
//

import MakingSnapchatNavigation

class MasterViewController: SnapchatNavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let camera = CameraViewController()
        setBackground(vc: camera)

        var vcs: [UIViewController] = []

        // First empty view
        var stub = UIViewController()
        stub.view.backgroundColor = .clear
        vcs.append(stub)

        // Second view with scroll on it
        stub = UIViewController()
        stub.view.backgroundColor = .clear

        // Scroll view content size
        let topInset: CGFloat = 60
        let sideInset: CGFloat = 8
        let contentHeight = UIScreen.main.bounds.size.height * 2
        let contentWidth = UIScreen.main.bounds.size.width - (sideInset * 2)


        // Configure scroll view
        let scroll = UIScrollView()
        scroll.backgroundColor = .clear
        scroll.contentSize.height = contentHeight
        scroll.contentSize.width = contentWidth
        scroll.contentInset = UIEdgeInsetsMake(topInset, sideInset, 0, sideInset)
        scroll.contentOffset = CGPoint(x: 0, y: -topInset)
        stub.view.addSubview(scroll)
        // Scroll view constraints
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.topAnchor.constraint(equalTo: stub.view.topAnchor).isActive = true
        scroll.bottomAnchor.constraint(equalTo: stub.view.bottomAnchor).isActive = true
        scroll.leftAnchor.constraint(equalTo: stub.view.leftAnchor).isActive = true
        scroll.rightAnchor.constraint(equalTo: stub.view.rightAnchor).isActive = true

        // Configure content view
        let content = GradientView()
        content.backgroundColor = .white
        content.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        content.layer.cornerRadius = 20
        content.layer.masksToBounds = true
        content.layer.applySketchShadow(alpha: 0.3, y: 0, blur: 10)
        scroll.addSubview(content)
        // Content view constraints
        content.translatesAutoresizingMaskIntoConstraints = false
        content.heightAnchor.constraint(equalToConstant: contentHeight * 1.5).isActive = true
        content.widthAnchor.constraint(equalToConstant: contentWidth).isActive = true

        vcs.append(stub)

        setViewControllers(vcs: vcs)

    }

}
