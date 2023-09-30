//
//  Utilities.swift
//  SampleApp
//
//  Created by Nana Bonsu on 6/26/23.
//

import Foundation
import UIKit


/// Defines utility functions used to fetch  and upload data from the server

class Utilities {
    
    ///Singleton of the utilties class
    static let shared = Utilities()
    
    /// Fetches data from the server
    /// - Parameters:
    ///   - url: The URL where the data is to be retrieved at
    ///   - completion: The result value that represents a sucessful retrieval or a failed one. a successful retrieval will contain some data
    /// - Returns: A data task that can be used by the function calling it
    func fetchData(from url:URL, completion: @escaping (Result<Data,Error>) -> Void) -> URLSessionDataTask {
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
               if let error = error {
                   completion(.failure(error))
                   return
               }
               
               guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                   let error = NSError(domain: "HTTPError", code: 0, userInfo: nil)
                   completion(.failure(error))
                   return
               }
               
               guard let data = data else {
                   let error = NSError(domain: "InvalidDataError", code: 0, userInfo: nil)
                   completion(.failure(error))
                   return
               }
               
               completion(.success(data))
           }
           
           task.resume()
           return task
    }
    
    /// uploads data from the server
    /// - Parameters:
    ///   - urlRequest: The URLRequest where the data is to be uploaded to at
    ///   - completion: The result value that represents a sucessful upload or a failed one. a successful retrieval will contain som result data
    /// - Returns: A data task that can be used by the function calling it
    func uploadData(from urlRequest:URLRequest, completion: @escaping (Result<Data,Error>) -> Void) -> URLSessionDataTask {
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
               if let error = error {
                   completion(.failure(error))
                   return
               }
               
               guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                   let error = NSError(domain: "HTTPError", code: 0, userInfo: nil)
                   completion(.failure(error))
                   return
               }
               
               guard let data = data else {
                   let error = NSError(domain: "InvalidDataError", code: 0, userInfo: nil)
                   completion(.failure(error))
                   return
               }
               
               completion(.success(data))
           }
           
           task.resume()
           return task
    }
    
    
}
