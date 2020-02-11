//
//  FollowerListVC.swift
//  GHFollowers
//
//  Created by Faisal Babkoor on 2/6/20.
//  Copyright © 2020 Faisal Babkoor. All rights reserved.
//

import UIKit

class FollowerListVC: UIViewController {
    
    enum Sections {
        case main
    }
    
    var name: String!
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Sections,Follower>!
    var followers = [Follower]()
    var page = 1
    var hasMoreFollowers = true
    var filterFollowers = [Follower]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureCollectionView()
        configureSearchController()
        getFollowers(username: name, page: page)
        configureDataSource()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    
    func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.creatThreeColumnFolowLayout(in: view))
        view.addSubview(collectionView)
        collectionView.backgroundColor = .systemBackground
        collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.reuseIdentifire)
        collectionView.delegate = self
    }
    
    
    func configureSearchController() {
        let search = UISearchController()
        search.searchResultsUpdater = self
        search.searchBar.delegate = self
        search.searchBar.placeholder = "Search for a username"
        //        search.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = search
        navigationItem.hidesSearchBarWhenScrolling = true
    }
    
    
    func getFollowers(username: String, page: Int) {
        showLoadingView()
        NetworkManager.shared.getFollowers(for: name, page: page) { [weak self] result in
            guard let self = self else { return }
            self.dismissLoadingView()
            switch result {
            case .success(let followers):
                if followers.count < 100 { self.hasMoreFollowers = false }
                self.followers.append(contentsOf: followers)
                
                if followers.isEmpty {
                    let message = "This user doesn't have any followers. Go follow them 😄"
                    DispatchQueue.main.async {self.showEmptyStateView(for: message, in: self.view)}
                }
                
                self.updateData(on: self.followers)
            case .failure(let error):
                self.presentGFAlertOnMainThrid(alertTitle: "BAD BAD", message: error.rawValue, buttonTitle: "OK")
            }
        }
    }
    
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { (collectionView, indexPath, follower) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowerCell.reuseIdentifire, for: indexPath) as! FollowerCell
            cell.set(follower: follower)
            return cell
        })
    }
    
    
    func updateData(on followers: [Follower]) {
        var snapshot = NSDiffableDataSourceSnapshot<Sections, Follower>()
        snapshot.appendSections([.main])
        snapshot.appendItems(followers)
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }
        
    }
}


extension FollowerListVC: UICollectionViewDelegate {
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentSize = scrollView.contentSize.height
        let height = scrollView.frame.height
        
        if offsetY > contentSize - height {
            guard hasMoreFollowers else { return }
            page += 1
            getFollowers(username: name, page: page)
        }
    }
}


extension FollowerListVC: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text, !filter.isEmpty else { return }
        filterFollowers = followers.filter{$0.login.lowercased().contains(filter.lowercased())}
        updateData(on: filterFollowers)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        filterFollowers.removeAll()
        updateData(on: followers)
    }
}
