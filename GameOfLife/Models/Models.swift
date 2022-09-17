//
//  Models.swift
//  GameOfLife
//
//  Created by Philip Twal on 9/14/22.
//

import Foundation

struct GameModel {
    var id: String
    var lifeStatus: LifeStatus
}

enum LifeStatus {
    case alive
    case dead
}
