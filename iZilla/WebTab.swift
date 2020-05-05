//
//  WebTab.swift
//  iZilla
//
//  Created by Stanislav on 05.05.2020.
//  Copyright © 2020 OrbitalMan. All rights reserved.
//

import Foundation

struct WebTab: Codable {
    let title: String
    let urlStack: [URL]
}
