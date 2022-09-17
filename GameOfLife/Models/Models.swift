//
//  Models.swift
//  GameOfLife
//
//  Created by Philip Twal on 9/14/22.
//

func generateData() -> [GameModel] {
    var gameModel = [GameModel]()
    for i in 0..<100 {
        gameModel.append(
            GameModel(
                id: "\(i)",
                lifeStatus: .dead)
        )
    }
    return gameModel
}


import Foundation

struct GameModel {
    var id: String
    var lifeStatus: LifeStatus
}

enum LifeStatus {
    case alive
    case dead
}
