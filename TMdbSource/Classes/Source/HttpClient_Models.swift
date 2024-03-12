//
//  HttpClient_Models.swift
//  TMdbSource
//
//  Created by Cloy Monis on 12/03/24.
//

import Foundation

enum HttpMethod: String {
    case get
    case post
}

struct HttpClientModel {
    let endpoint: String
    var timeout: Int = 20
    var method: HttpMethod
    var headers: [String: String]?
    init(endpoint: String, timeout: Int = 20) {
        self.endpoint = endpoint
        self.method = .get
        self.timeout = timeout
    }
    init(endpoint: String, method: HttpMethod, headers: [String: String]? = nil, timeout: Int = 20) {
        self.endpoint = endpoint
        self.method = method
        self.headers = headers
        self.timeout = timeout
    }
}

enum HttpClientError: Error {
    case emptyClientModel
    case badURL
    case unknownError
    case errorHttpResponse
    case notFound
    case unknownResponseCode
    case invalidData
    case responseCountZero
    case serverError
    case requestTimeout
    case encodingFailed
    case decodingFailed
}

struct HttpClientResponse {
    let data: Data
    var headers: [String: Any]?
}
