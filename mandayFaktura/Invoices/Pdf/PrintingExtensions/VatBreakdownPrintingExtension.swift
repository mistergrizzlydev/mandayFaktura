//
//  VatBreakoutPrintingExtension.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 04.02.2018.
//  Copyright © 2018 Wojciech Kicior. All rights reserved.
//

import Foundation

internal extension BreakdownEntry {
    var propertiesForDisplay: [String] {
        get {
            return [self.netValue.formatAmount(), "\(self.vatRateInPercent.description)%", self.vatValue.formatAmount(), self.grossValue.formatAmount()]
        }
    }
}
