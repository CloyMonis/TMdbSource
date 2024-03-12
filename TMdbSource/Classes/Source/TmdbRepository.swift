//
//  TmdbRepository.swift
//  TMdbSource
//
//  Created by Cloy Monis on 12/03/24.
//

import Foundation

protocol TmdbRepository {
    func fetch(pageNo: Int, category: Category) -> [TMdbMovie]
    func store(pageNo: Int, category: Category, movies: [TMdbMovie])
}

class TmdbRepositoryImpl: TmdbRepository {
    
    private var latest = [Int: [TMdbMovie]]()
    private var popular = [Int: [TMdbMovie]]()
    
    func fetch(pageNo: Int, category: Category) -> [TMdbMovie] {
        switch category {
        case .latest:
            guard let movies = latest[pageNo] else {
                return [TMdbMovie]()
            }
            return movies
        case .popular:
            guard let movies = popular[pageNo] else {
                return [TMdbMovie]()
            }
            return movies
        }
    }
    
    func store(pageNo: Int, category: Category, movies: [TMdbMovie]) {
        switch category {
        case .latest:
            latest[pageNo] = movies
        case .popular:
            popular[pageNo] = movies
        }
    }
}
