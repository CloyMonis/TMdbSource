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
    
    
    public init() {
        repository = TmdbRepositoryImpl()
        client = TmdbClientImpl()
    }
    
    public func getMovies(pageNo: Int, category: Category, completion: @escaping ([TMdbMovie]) -> Void) {
        let movies = repository.fetch(pageNo: pageNo, category: category)
        guard movies.isEmpty else {
            logger.log("From Repository \(category.getApiName()) Page No:\(pageNo) Count:\(movies.count)")
            completion(movies)
            return
        }
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
}
