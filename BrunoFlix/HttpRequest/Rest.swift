//
//  Rest.swift
//  BrunoFlix
//
//  Created by Bruno Garcia on 24/11/18.
//  Copyright © 2018 Bruno Garcia. All rights reserved.
//

import Foundation

enum UrlError {
    case invalidJSON
    case url
    case noResponse
    case noData
    case httpError(code: Int)
}

class Rest {
    
    static let basePath = "https://itunes.apple.com/search?media=movie&entity=movie&term="
    
    static let configuration: URLSessionConfiguration = {
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = ["Content-Type": "application/json"]
        // timeout de 10 segundos
        config.timeoutIntervalForResource = 10
        // wi-fi apenas
        config.allowsCellularAccess = false
        config.httpMaximumConnectionsPerHost = 5
        return config
    }()
    
    static let session = URLSession(configuration: configuration)
    
    class func load(movieName: String, completion: @escaping (URL?, UrlError?) -> Void) {
        let newMovieName = movieName.replacingOccurrences(of: " ", with: "").lowercased()
        guard let url = URL(string: basePath + newMovieName) else {
            return completion(nil, .url)
        }
        
        let task = session.dataTask(with: url) { (data, response, error) in
            if error != nil {
                return completion(nil, .noResponse)
            } else {
                guard let response = response as? HTTPURLResponse else {
                    return completion(nil, .noResponse)
                }
                switch response.statusCode {
                case 200...299:
                    guard let data = data else {
                        return completion(nil, .noData)
                    }
                    do {
                        let result = try JSONDecoder().decode(ItunesApi.self, from: data)
                        
                        guard let urlString = result.results.first?.previewUrl else {
                            return completion(nil, .invalidJSON)
                        }
                        
                        guard let url = URL(string: urlString) else {
                            return completion(nil, .invalidJSON)
                        }
                        
                        completion(url, nil)
                    } catch {
                        return completion(nil, .invalidJSON)
                    }
                default:
                    return completion(nil, .httpError(code: response.statusCode))
                }
            }
        }
        task.resume()
    }
    
}
