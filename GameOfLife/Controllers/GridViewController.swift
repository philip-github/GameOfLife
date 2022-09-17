//
//  ViewController.swift
//  GameOfLife
//
//  Created by Philip Twal on 9/14/22.
//

import UIKit

final class GridViewController: UIViewController {
    
    private var collectionView: UICollectionView?
    private var gameModel = [GameModel]()
    
    private let button: UIButton = {
        let button = UIButton()
        button.layer.masksToBounds = true
        button.backgroundColor = .link
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Game Of Life"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(didTapBarButton))
        navigationItem.rightBarButtonItem?.tintColor = .label
        gameModel = generateData()
        configureCollectionView()
        view.addSubview(button)
        button.addTarget(self, action: #selector(didTapPlayButton), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews(){
        super.viewDidLayoutSubviews()
        guard let collectionView = collectionView else { return }
        //MARK: Grid Collection View Frame
        collectionView.frame = CGRect(x: view.left,
                                      y: view.safeAreaInsets.top + 10,
                                      width: view.width,
                                      height: view.height/1.5)
        
        //MARK: Play Button Frame
        button.frame = CGRect(x: (view.width/2) - (view.width/1.5)/2,
                              y: collectionView.bottom,
                              width: view.width/1.5,
                              height: 70)
        button.setTitle("Play", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        button.setTitleColor(.white, for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.secondaryLabel.cgColor
        button.layer.cornerRadius = 5.0
    }
    
    //MARK: Collection View Flow Layout Configuration
    private func configureCollectionView(){
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0.7
        layout.minimumInteritemSpacing = 0.7
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: (view.width - 7)/10,
                                 height: (view.width - 7)/10)
        
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        guard let collectionView = collectionView else { return }
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(GridCollectionViewCell.self,
                                forCellWithReuseIdentifier: GridCollectionViewCell.identifier)
    }
    
    
    @objc private func didTapPlayButton(){
        guard gameModel.count > 0 else { return }
        if let newModel = GOLViewModel().play(with: gameModel) {
            DispatchQueue.main.async { [weak self] in
                self?.gameModel = newModel
                self?.collectionView?.reloadData()
            }
        }
    }
    
    @objc private func didTapBarButton(){
        self.gameModel = generateData()
        self.collectionView?.reloadData()
    }
}

// MARK: Grid Collection Delegates
extension GridViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gameModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard gameModel.count > 0 else { return GridCollectionViewCell() }
        let data = gameModel[indexPath.row]
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GridCollectionViewCell.identifier, for: indexPath) as? GridCollectionViewCell else { return GridCollectionViewCell() }
        cell.configure(with: data)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? GridCollectionViewCell else { return }
        DispatchQueue.main.async {
            if cell.contentView.backgroundColor != .link {
                cell.contentView.backgroundColor = .link
                self.gameModel[indexPath.row].lifeStatus = .alive
            }else{
                cell.contentView.backgroundColor = .secondaryLabel
                self.gameModel[indexPath.row].lifeStatus = .dead
            }
        }
    }
}
