//
//  BoredAPI.swift
//  BoredApp
//
//  Created by Marcelo Carvalho on 13/06/23.
//

import Foundation

enum BoredAPI {

    case activity

    var url: String {
        return "http://www.boredapi.com/api/activity/"
    }
}
