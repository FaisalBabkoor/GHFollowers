//
//  FollowerListVC.swift
//  GHFollowers
//
//  Created by Faisal Babkoor on 2/6/20.
//  Copyright © 2020 Faisal Babkoor. All rights reserved.
//

import UIKit



class FollowerListVC: GFDataLoadingVC {
    
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
    var isSearching = false
    var isLoadingMoreFollowers = false
    
    
    init(username: String) {
        super.init(nibName: nil, bundle: nil)
        name = username
        title = username
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
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
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
    }
    
    
    func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createThreeColumnFlowLayout(in: view))
        view.addSubview(collectionView)
        collectionView.backgroundColor = .systemBackground
        collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.reuseIdentifier)
        collectionView.delegate = self
    }
    
    
    func configureSearchController() {
        let search = UISearchController()
        search.searchResultsUpdater = self
        search.searchBar.placeholder = "Search for a username"
        search.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = search
        navigationItem.hidesSearchBarWhenScrolling = true
    }
    
    
    func getFollowers(username: String, page: Int) {
        showLoadingView()
        isLoadingMoreFollowers = true
        hasMoreFollowers = true
        NetworkManager.shared.getFollowers(for: name, page: page) { [weak self] result in
            guard let self = self else { return }
            self.dismissLoadingView()
            
            switch result {
            case .success(let followers):
                self.updateUI(with: followers)
                
            case .failure(let error):
                self.presentGFAlertOnMainThread(alertTitle: "BAD BAD", message: error.rawValue, buttonTitle: "OK")
            }
            
            self.isLoadingMoreFollowers = false
            self.isSearching = false
        }
    }
    
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { (collectionView, indexPath, follower) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowerCell.reuseIdentifier, for: indexPath) as! FollowerCell
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
    
    
    @objc func addButtonTapped() {
        showLoadingView()
        
        NetworkManager.shared.getUserInfo(for: name) { [weak self] result in
            guard let self = self else { return }
            self.dismissLoadingView()
            
            switch result {
            case .success(let user):
                self.addUserToFavorites(user: user)
                
            case .failure(let error):
                self.presentGFAlertOnMainThread(alertTitle: "Something went wrong", message: error.rawValue, buttonTitle: "OK")
            }
        }
    }
    
    
    func updateUI(with followers: [Follower]) {
        if followers.count < 100 { self.hasMoreFollowers = false }
        self.followers.append(contentsOf: followers)
        
        if followers.isEmpty {
            let message = "This user doesn't have any followers. Go follow them 😄"
            DispatchQueue.main.async {self.showEmptyStateView(for: message, in: self.view)}
        }
        
        self.updateData(on: self.followers)
    }
    
    
    func addUserToFavorites(user: User) {
        let follower = Follower(login: user.login, avatarUrl: user.avatarUrl)
        
        PersistenceManager.updateWith(favorite: follower, actionType: .add) { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                self.presentGFAlertOnMainThread(alertTitle: "Something went wrong", message: error.rawValue, buttonTitle: "OK")
                return
            }
            
            self.presentGFAlertOnMainThread(alertTitle: "Success", message: "You have successfully favorited this user 🎉", buttonTitle: "Hooray!")
        }
    }
}


extension FollowerListVC: UICollectionViewDelegate {
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentSize = scrollView.contentSize.height
        let height = scrollView.frame.height
        
        if offsetY > contentSize - height {
            guard hasMoreFollowers, !isLoadingMoreFollowers else { return }
            page += 1
            getFollowers(username: name, page: page)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let activeArray = isSearching ? filterFollowers : followers
        let follower = activeArray[indexPath.row]
        let userInfoVC = UserInfoVC()
        userInfoVC.username = follower.login
        userInfoVC.delegate = self
        let navigation = UINavigationController(rootViewController: userInfoVC)
        present(navigation, animated: true)
    }
}


extension FollowerListVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text, !filter.isEmpty else {
            isSearching = false
            filterFollowers.removeAll()
            updateData(on: followers)
            return
        }
        filterFollowers = followers.filter{$0.login.lowercased().contains(filter.lowercased())}
        isSearching = true
        updateData(on: filterFollowers)
    }
}

extension FollowerListVC: UserInfoVCDelegate {
    
    func didRequestFollowers(for username: String) {
        self.name = username
        self.followers.removeAll()
        self.filterFollowers.removeAll()
        self.page = 1
        self.title = username
        self.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
        getFollowers(username: username, page: page)
    }
}
