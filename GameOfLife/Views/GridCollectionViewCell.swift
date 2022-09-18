//
//  GridCollectionViewCell.swift
//  GameOfLife
//
//  Created by Philip Twal on 9/14/22.
//

import UIKit

class GridCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "GridCollectionViewCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.clipsToBounds = true
        contentView.backgroundColor = .secondaryLabel
        contentView.layer.cornerRadius = 2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with model: Cell) {
        switch model.lifeStatus {
        case .alive:
            contentView.backgroundColor = .link
        case .dead:
            contentView.backgroundColor = .secondaryLabel
        }
    }
}
