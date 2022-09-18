//
//  Models.swift
//  GameOfLife
//
//  Created by Philip Twal on 9/14/22.
//


import Foundation

struct Cell {
    var id: Int
    var lifeStatus: LifeStatus
}

enum LifeStatus {
    case alive
    case dead
}

func generateData() -> [Cell] {
    var gameModel = [Cell]()
    for i in 0..<100 {
        gameModel.append(
            Cell(
                id: i,
                lifeStatus: .dead)
        )
    }
    return gameModel
}
