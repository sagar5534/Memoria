//
//  File.swift
//  
//
//  Created by Sagar R Patel on 2022-05-03.
//

import Foundation

extension URLCache {
    static let imageCache = URLCache(memoryCapacity: 512 * 1000 * 1000, diskCapacity: 10 * 1000 * 1000 * 1000)
}

