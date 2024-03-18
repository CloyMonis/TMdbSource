//
//  HttpClient.swift
//  TMdbSource
//
//  Created by Cloy Monis on 12/03/24.
//

import Foundation
import os

class HttpClient: NSObject {
    
    private let TAG = "HttpClient"
    private let logger = Logger(subsystem: "TMDBSource", category: "HttpClient")
    
    func fetch(model: HttpClientModel, completionHandler: @escaping (Result<HttpClientResponse, HttpClientError>) -> Void) {
        guard let url = URL(string: model.endpoint) else {
            completionHandler(.failure(.badURL))
            return
        }
        var request = URLRequest(url: url)
        if #available(iOS 14.5, tvOS 14.5, *) {
            request.assumesHTTP3Capable = true
        }
        request.httpMethod = model.method.rawValue
        request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        request.timeoutInterval = Double(model.timeout)
        if let headers = model.headers {
            for eachHeader in headers {
                request.addValue(eachHeader.value, forHTTPHeaderField: eachHeader.key)
            }
        }
        let session = URLSession.shared
        let urlSessionDataTask = session.dataTask(with: request) { [weak self] data, urlResponse, error in
            guard let weakSelf = self else {
                return
            }
            // weakSelf.logger("\(weakSelf.TAG) urlResponse:\(String(describing: urlResponse)) error:\(String(describing: error)) data:\(String(describing: data))")
            guard error == nil else {
                weakSelf.logger.log("\(weakSelf.TAG) failure unknownError")
                completionHandler(.failure(.unknownError))
                return
            }
            guard let httpResponse = urlResponse as? HTTPURLResponse else {
                weakSelf.logger.log("\(weakSelf.TAG) failure errorHttpResponse")
                completionHandler(.failure(.errorHttpResponse))
                return
            }
            if httpResponse.statusCode == 404 {
                weakSelf.logger.log("\(weakSelf.TAG) failure notFound")
                completionHandler(.failure(.notFound))
                return
            }
            if httpResponse.statusCode != 200 {
                weakSelf.logger.log("\(weakSelf.TAG) failure unknownResponseCode")
                completionHandler(.failure(.unknownResponseCode))
                return
            }
            guard let data = data else {
                weakSelf.logger.log("\(weakSelf.TAG) failure invalidData")
                completionHandler(.failure(.invalidData))
                return
            }
            weakSelf.logger.log("\(weakSelf.TAG) completionHandler success ")
            var httpClientResponse = HttpClientResponse(data: data)
            httpClientResponse.headers = httpResponse.allHeaderFields as? [String: Any]
            completionHandler(.success(httpClientResponse))
        }
        urlSessionDataTask.resume()
    }
    
}
