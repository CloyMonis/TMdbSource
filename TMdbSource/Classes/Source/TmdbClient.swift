//
//  TmdbClient.swift
//  TMdbSource
//
//  Created by Cloy Monis on 12/03/24.
//

import Foundation

protocol TmdbClient {
    func fetchMovies(pageNo: Int, completion: @escaping (Result<[TMdbMovie],HttpClientError>) -> Void )
}

class TmdbClientImpl: TmdbClient {
    
    var client: HttpClient?
    
    func fetchMovies(pageNo: Int, completion: @escaping (Result<[TMdbMovie],HttpClientError>) -> Void) {
        let headers = ["accept": "application/json"]
        let clientModel = HttpClientModel(endpoint: "https://api.themoviedb.org/3/movie/popular?language=en-US&page=3&api_key=da30e822b633d40f53a9e6d8da4e8c99", method: .get, headers: headers)
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
}

