//
//  Document.swift
//  mandayFaktura
//
//  Created by Wojciech Kicior on 23.02.2019.
//  Copyright © 2019 Wojciech Kicior. All rights reserved.
//

import Foundation

protocol Document {
    var number: String { get }
    var issueDate: Date { get }
    var seller: Counterparty { get }
    var buyer: Counterparty { get }
    var totalGrossValue: Decimal  { get }
    var totalNetValue: Decimal  { get }
    var totalVatValue: Decimal { get }
}
