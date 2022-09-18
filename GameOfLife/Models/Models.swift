//
//  Models.swift
//  GameOfLife
//
//  Created by Philip Twal on 9/14/22.
//

func generateData() -> [Cell] {
    var gameModel = [Cell]()
    for i in 0..<100 {
        gameModel.append(
            Cell(
                id: "\(i)",
                lifeStatus: .dead)
        )
    }
    return gameModel
}


import Foundation

struct Cell {
    var id: String
    var lifeStatus: LifeStatus
}

enum LifeStatus {
    case alive
    case dead
}
