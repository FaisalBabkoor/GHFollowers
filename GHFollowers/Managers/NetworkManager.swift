//
//  NetworkManager.swift
//  GHFollowers
//
//  Created by Faisal Babkoor on 2/8/20.
//  Copyright © 2020 Faisal Babkoor. All rights reserved.
//

import UIKit.UIImageView

class NetworkManager {
    
    static let shared = NetworkManager()
    private let baseUrl = "https://api.github.com/users/"
    let cache = NSCache<NSString, UIImage>()
    
    private init() {}
    
    
    func getFollowers(for username: String, page: Int, completion: @escaping (Result<[Follower], GFError>) -> ()) {
        let urlString = baseUrl + "\(username)/followers?per_page=100&page=\(page)"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidUsername))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error {
                completion(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            
            do {
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                
                let followersData =  try jsonDecoder.decode([Follower].self, from: data)
                completion(.success(followersData))
            } catch {
                completion(.failure(.invalidData))
                return
            }
            
        }.resume()
    }
    
    
    func downloadImage(from urlString: String, completion: @escaping (UIImage?) -> ()){
        let cacheKey = NSString(string: urlString)
        completion(nil)
        
        if let cacheImage = cache.object(forKey: cacheKey) {
            completion(cacheImage)
            return
        }
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else { return }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { return }
            guard let data = data else { return }
            
            guard let image = UIImage(data: data) else { return }
            self.cache.setObject(image, forKey: cacheKey)
            DispatchQueue.main.async {
                completion(image)
            }
            
        }.resume()
    }
    
    
    func getUserInfo(for username: String, completion: @escaping (Result<User, GFError>) -> ()) {
        let urlString = baseUrl + "\(username)"
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidUsername))
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error {
                completion(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            
            do {
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                jsonDecoder.dateDecodingStrategy = .iso8601
                let user =  try jsonDecoder.decode(User.self, from: data)
                completion(.success(user))
            } catch {
                completion(.failure(.invalidData))
                return
            }
            
        }.resume()
    }
    
}

// Generic function
/*
 func sendRequest(to endpoint: String, model: T.Type, queryItems: [String: Any]?, completion: @escaping(Result)->Void) {
 
 
 var innerUrl = urlComponents
 innerUrl.path = endpoint
 
 if let queryItems = queryItems {
 var urlQueryItem = [URLQueryItem]()
 
 for (key, data) in queryItems {
 urlQueryItem.append(URLQueryItem(name:key, value: data as? String))
 }
 
 innerUrl.queryItems = urlQueryItem
 }
 
 
 guard let url = innerUrl.url else {
 completion(.failure(.InvalidURL))
 
 return
 }
 
 URLSession.shared.dataTask(with: url) { (data, response, error) in
 
 if let _ = error {
 completion(.failure(.InvalidData))
 
 return
 }
 
 guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
 completion(.failure(.InvalidResponse))
 
 return
 }
 
 guard let data = data else {
 completion(.failure(.InvalidData))
 
 return
 }
 
 do {
 let response = try JSONDecoder().decode(T.self, from: data)
 completion(.success(response))
 
 } catch  {
 //printing error allows to identify json failure
 //print(error)
 completion(.failure(.InvalidData))
 }
 
 }.resume()
 }
 */
