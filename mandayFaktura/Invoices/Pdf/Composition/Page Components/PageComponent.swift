//
//  PageComponent.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 06.02.2019.
//  Copyright © 2019 Wojciech Kicior. All rights reserved.
//

import Foundation

protocol PageComponent {
    var height: CGFloat { get }
    var xPosition: CGFloat { get }
    var yPosition: CGFloat { get }
    
    func draw()
}
