//
//  ViewModel.swift
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

class GOLViewModel {
    
    private struct Constants {
        static let upperBound = [0,1,2,3,4,5,6,7,8,9]
        static let lowerBound = [90,91,92,93,94,95,96,97,98,99]
        static let leftBound = [0,10,20,30,40,50,60,70,80,90]
        static let rightBound = [9,19,29,39,49,59,69,79,89,99]
    }
    
    func play(with model: [GameModel]) -> [GameModel]? {
        var myModel = model
        let aliveCells = model.filter({ return $0.lifeStatus == .alive }) // O(n)
        if aliveCells.count <= 2{
            for cell in aliveCells {  // O(n)
                if let position = Int(cell.id) {
                    myModel[position].lifeStatus = .dead
                }
            }
            return myModel
        }
        var tempModel = [[GameModel]]()
        for cell in aliveCells {
            let neighbors = configureNeighborsForCell(cell: cell)
            let (aliveNeighborsForChosenCell, deadNeighborsForChosenCell) = checkNeighborCellsLifeStatus(model: myModel, neighbors: neighbors, cell: cell)
            if aliveNeighborsForChosenCell.count < 2{
                var myCell = cell
                myCell.lifeStatus = .dead
                tempModel.append([myCell])
                continue
            }else if aliveNeighborsForChosenCell.count > 3 {
                var myCell = cell
                myCell.lifeStatus = .dead
                tempModel.append([myCell])
                continue
            }
            let deadNeighborCells = deadNeighborsForChosenCell.map({ return myModel[$0] })
            let rebornCells = checkDeadNeighborsForReborn(deadCells: deadNeighborCells, model: myModel)
            if rebornCells.count > 0 {
                tempModel.append(rebornCells)
            }
        }
        let flatModel = tempModel.flatMap({ return $0 })
        for i in flatModel {
            if let value = Int(i.id){
                myModel[value] = i
            }
        }
        return myModel
    }
    
    func configureNeighborsForCell(cell: GameModel) -> [Int] {
        var neighborsCells = [Int]()
        guard let aliveCellPosition = Int(cell.id) else { return [] }
        
        let topNeighbor = aliveCellPosition - 10
        let topLeftNeighbor = aliveCellPosition - 11
        let topRightNeighbor = aliveCellPosition - 9
        
        let centerLeftNeighbor = aliveCellPosition - 1
        let centerRightNeighbor = aliveCellPosition + 1
        
        let bottomNeighbor = aliveCellPosition + 10
        let bottomLeftNeighbor = aliveCellPosition + 9
        let bottomRightNeighbor = aliveCellPosition + 11
        
        if aliveCellPosition == 0{
            neighborsCells = [centerRightNeighbor,bottomRightNeighbor,bottomNeighbor]
        }else if aliveCellPosition == 9{
            neighborsCells = [centerLeftNeighbor,bottomLeftNeighbor,bottomNeighbor]
        }else if aliveCellPosition == 90{
            neighborsCells = [centerRightNeighbor,topRightNeighbor,topNeighbor]
        }else if aliveCellPosition == 99{
            neighborsCells = [centerLeftNeighbor,topLeftNeighbor,topNeighbor]
        }else if Constants.upperBound.contains(aliveCellPosition){
            neighborsCells = [centerLeftNeighbor,bottomLeftNeighbor,bottomNeighbor,bottomRightNeighbor,centerRightNeighbor]
        }else if Constants.leftBound.contains(aliveCellPosition){
            neighborsCells = [topNeighbor,topRightNeighbor,centerRightNeighbor,bottomRightNeighbor,bottomNeighbor]
        }else if Constants.lowerBound.contains(aliveCellPosition){
            neighborsCells = [centerLeftNeighbor,topLeftNeighbor,topNeighbor,topRightNeighbor,centerRightNeighbor]
        }else if Constants.rightBound.contains(aliveCellPosition){
            neighborsCells = [bottomNeighbor,bottomLeftNeighbor,centerLeftNeighbor,topLeftNeighbor,topNeighbor]
        }
        else{
            neighborsCells =
            [
                centerLeftNeighbor,topLeftNeighbor,topNeighbor,
                topRightNeighbor,centerRightNeighbor,bottomRightNeighbor,
                bottomNeighbor,bottomLeftNeighbor
            ]
        }
        return neighborsCells
    }
    
    func checkNeighborCellsLifeStatus(model: [GameModel], neighbors: [Int], cell: GameModel) -> (alive: [Int], dead: [Int]) {
        let aliveNeighbors = neighbors.filter({ return model[$0].lifeStatus == .alive })
        let deadNeighbors = neighbors.filter({ return model[$0].lifeStatus == .dead })
        return (aliveNeighbors,deadNeighbors)
    }
    
    func checkDeadNeighborsForReborn(deadCells: [GameModel], model: [GameModel]) -> [GameModel] {
        var rebornCells = [GameModel]()
        for cell in deadCells{
            let cellNeighbors = configureNeighborsForCell(cell: cell)
            let (aliveNeighbors, _) = checkNeighborCellsLifeStatus(model: model, neighbors: cellNeighbors, cell: cell)
//            let aliveNeighborCells = aliveNeighbors.map({ return model[$0] })
            if aliveNeighbors.count == 3 {
                var rebornedCell = cell
                rebornedCell.lifeStatus = .alive
                rebornCells.append(rebornedCell)
            }
        }
        return rebornCells
    }
}
