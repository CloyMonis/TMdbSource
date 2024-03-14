//
//  TmdbClient.swift
//  TMdbSource
//
//  Created by Cloy Monis on 12/03/24.
//

import Foundation

protocol TmdbClient {
    func set(apiKey: String)
    func fetchMovies(pageNo: Int, category: Category, completion: @escaping (Result<[TMdbMovie], HttpClientError>) -> Void)
    func fetchMovie(id: Int, completion: @escaping (Result<TMdbMovieDetail, HttpClientError>) -> Void)
}

class TmdbClientImpl: TmdbClient {
    
    var client: HttpClient?
    var apiKey: String?
    
    func set(apiKey: String) {
        self.apiKey = apiKey
    }
    
    func fetchMovies(pageNo: Int, category: Category, completion: @escaping (Result<[TMdbMovie],HttpClientError>) -> Void) {
        guard let apiKey = apiKey, pageNo > 0 else {
            let error = HttpClientError.invalidData
            completion(.failure(error))
            return
        }
        let headers = ["accept": "application/json"]
        let clientModel = HttpClientModel(endpoint: "https://api.themoviedb.org/3/movie/\(category.getApiName())?language=en-US&page=\(pageNo)&api_key=\(apiKey)", method: .get, headers: headers)
        let httpClient = HttpClient()
        self.client = httpClient
        httpClient.fetch(model: clientModel) { result in
            switch result {
            case .success(let clientResponse):
                let jsonDecoder = JSONDecoder()
                let error = HttpClientError.decodingFailed
                guard let result: TMdbMovieResult = try? jsonDecoder.decode(TMdbMovieResult.self, from: clientResponse.data) else {
                    completion(.failure(error))
                    return
                }
                guard let movies = result.results else {
                    completion(.failure(error))
                    return
                }
                completion(.success(movies))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchMovie(id: Int, completion: @escaping (Result<TMdbMovieDetail, HttpClientError>) -> Void) {
        guard let apiKey = apiKey, id > 0 else {
            let error = HttpClientError.invalidData
            completion(.failure(error))
            return
        }
        let headers = ["accept": "application/json"]
        let clientModel = HttpClientModel(endpoint: "https://api.themoviedb.org/3/movie/\(id)?api_key=\(apiKey)", method: .get, headers: headers)
        let httpClient = HttpClient()
        self.client = httpClient
        httpClient.fetch(model: clientModel) { result in
            switch result {
            case .success(let clientResponse):
                let jsonDecoder = JSONDecoder()
                let error = HttpClientError.decodingFailed
                guard let result: TMdbMovieDetail = try? jsonDecoder.decode(TMdbMovieDetail.self, from: clientResponse.data) else {
                    completion(.failure(error))
                    return
                }
                completion(.success(result))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
