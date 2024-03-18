//
//  TMdbSource.swift
//  TMdbSource
//
//  Created by Cloy Monis on 11/03/24.
//

import Foundation
import os

public class TMdbDataSource {
    
    private let repository: TmdbRepository
    private let client: TmdbClient
    private let logger = Logger(subsystem: "TMDBSource", category: "DataSource")
    private var apiKey = "da30e822b633d40f53a9e6d8da4e8c99"
    
    public init() {
        repository = TmdbRepositoryImpl()
        client = TmdbClientImpl()
    }
    
    public func set(apiKey: String) {
        self.apiKey = apiKey
    }
    
    public func getEndPoint() -> String {
        return "https://image.tmdb.org/t/p/"
    }
    
    public func getMovies(pageNo: Int, category: Category, completion: @escaping ([TMdbMovie]) -> Void) {
        let movies = repository.fetch(pageNo: pageNo, category: category)
        guard movies.isEmpty else {
            logger.log("From Repository \(category.getApiName()) Page No:\(pageNo) Count:\(movies.count)")
            completion(movies)
            return
        }
        client.set(apiKey: apiKey)
        client.fetchMovies(pageNo: pageNo, category: category) { [weak self] result in
            guard let weakSelf = self else {
                return
            }
            switch result {
            case .success(let movies):
                weakSelf.logger.log("From Client \(category.getApiName()) Page No:\(pageNo) Count:\(movies.count)")
                weakSelf.repository.store(pageNo: pageNo, category: category, movies: movies)
                completion(movies)
            case .failure(let error):
                weakSelf.logger.critical("Error : \(error)")
                let movies = [TMdbMovie]()
                completion(movies)
            }
        }
    }
    
    public func getMovieDetail(id: Int, completion: @escaping (TMdbMovieDetail?) -> Void) {
        client.set(apiKey: apiKey)
        client.fetchMovie(id: id) { [weak self] result in
            guard let weakSelf = self else {
                return
            }
            switch result {
            case .success(let movieDetail):
                completion(movieDetail)
            case .failure(let error):
                weakSelf.logger.critical("Error : \(error)")
                completion(nil)
            }
        }
    }
}
