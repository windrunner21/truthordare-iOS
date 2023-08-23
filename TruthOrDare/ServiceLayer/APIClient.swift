//
//  APIClient.swift
//  TruthOrDare
//
//  Created by Imran Hajiyev on 16.08.23.
//

import Foundation

class APIClient {
    private let session: URLSession
    private let baseURL: String
    private let apiKey = ServiceConfig.testKey
    
    init(baseURL: String) {
        self.baseURL = baseURL
        
        let configuration = URLSessionConfiguration.default
        self.session = URLSession(configuration: configuration)
    }
    
    func sendRequest(
        path: String,
        method: HTTPMethod,
        body: Data? = nil,
        headers: [String: String]? = nil,
        parameters: [URLQueryItem]? = nil,
        completion: @escaping (Data?, URLResponse?, Error?) -> Void ) {
            // Setup main url ( base and path).
            var url = URL(string: baseURL + path)!
            
            // Check whether url should contain extra parameters.
            if let parameters = parameters {
                var urlComponents = URLComponents(string: url.absoluteString)
                urlComponents?.queryItems = parameters
                
                if let updatedUrl = urlComponents?.url {
                    url = updatedUrl
                }
            }
            
            // Setup request with resulted url.
            var request = URLRequest(url: url)
            
            // Setup method.
            request.httpMethod = method.rawValue
            
            // Setup headers.
            request.allHTTPHeaderFields = headers
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
            
            request.httpBody = body
            
            let task = self.session.dataTask(with: request) { data, response, error in
                completion(data, response, error)
            }
            
            task.resume()
    }
}
