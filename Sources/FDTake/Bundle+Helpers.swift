//
//  Bundle+Helpers.swift
//  FDTake
//
//  Created by Yaroslav Zhurakovskiy on 20.11.2019.
//  Copyright © 2019 William Entriken. All rights reserved.
//

import Foundation

extension Bundle {
    static var framework: Bundle {
        return Bundle(for: FDTakeController.self)
    }
    
    static var resources: Bundle? {
        guard let path = Bundle.main.path(forResource: "FDTakeResources", ofType: "bundle") else {
            return nil
        }
        return  Bundle(path: path)
    }
}
