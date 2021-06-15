//
//  Date + CurrentDay.swift
//  MMFTimeTable
//
//  Created by mac on 27.05.21.
//

import UIKit

extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[ index] : nil
    }
}
