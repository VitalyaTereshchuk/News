//
//  ApiManager.swift
//  NewsApp
//
//  Created by Vitaly on 11.12.2023.
//

import Foundation

final class ApiManager {
    
    private static let apiKey = "66fc7d75289e4e579c16bb588dc49579"
    private static let baseUrl  = "https://newsapi.org/v2/"
    private static let path = "everything"
    
    //MARK: - Create url path and make request
   static func getNews(completion: @escaping (Result<[ArticleResponceObject], Error>) -> ()) {
       let stringUrl = baseUrl + path + "?sources=abc-news-au&language=en" + "&apiKey=\(apiKey)"
       
       guard let url = URL(string: stringUrl) else { return }
       
       let session = URLSession.shared.dataTask(with: url) { data, _, error in
           handleResponse(data: data,
                          error: error,
                          completion: completion)
       }
       
       session.resume()
    }
    //MARK: - BusinessGetNews url
    static func businessGetNews(completion: @escaping (Result<[ArticleResponceObject], Error>) -> ()) {
        let stringUrl = baseUrl + path + "?sources=business-insider&language=en" + "&apiKey=\(apiKey)"
        
        guard let url = URL(string: stringUrl) else { return }
        
        let session = URLSession.shared.dataTask(with: url) { data, _, error in
            handleResponse(data: data,
                           error: error,
                           completion: completion)
        }
        
        session.resume()
     }
    //MARK: - TechnologyGetNews url
    static func technologyGetNews(completion: @escaping (Result<[ArticleResponceObject], Error>) -> ()) {
        let stringUrl = baseUrl + path + "?sources=the-verge&language=en" + "&apiKey=\(apiKey)"
        
        guard let url = URL(string: stringUrl) else { return }
        
        let session = URLSession.shared.dataTask(with: url) { data, _, error in
            handleResponse(data: data,
                           error: error,
                           completion: completion)
        }
        
        session.resume()
     }
    
    static func getImageData(url: String, completion: @escaping (Result<Data, Error>) -> ()) {
        guard let url = URL(string: url) else { return }
        
        let session = URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data {
                completion(.success(data))
            }
            
            if let error = error {
                completion(.failure(error))
            }
        }
        
        session.resume()
    }
    
    //MARK: - Handle responce
    private static func handleResponse(data: Data?,
                                       error: Error?,
                                       completion: @escaping (Result<[ArticleResponceObject], Error>) -> ()) {
        if let error = error {
            completion(.failure(NetworkingError.networkingError(error)))
        } else if let data = data {
            do {
                let model = try JSONDecoder().decode(NewsResponseObject.self, 
                                                     from: data)
                completion(.success(model.articles))
            } 
            catch let decodeError{
                completion(.failure(decodeError))
            }
        } else {
            completion(.failure(NetworkingError.unknown))
        }
    }
}
