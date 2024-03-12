//
//  TmdbRepository.swift
//  TMdbSource
//
//  Created by Cloy Monis on 12/03/24.
//

import Foundation

protocol TmdbRepository {
    func fetch(pageNo: Int) -> [TMdbMovie]
    func store(pageNo: Int, movies: [TMdbMovie])
}

class TmdbRepositoryImpl: TmdbRepository {
    
    private var hashMap = [Int: [TMdbMovie]]()
    
    func fetch(pageNo: Int) -> [TMdbMovie] {
        guard let movies = hashMap[pageNo] else {
            return [TMdbMovie]()
        }
        return movies
    }
    
    func store(pageNo: Int, movies: [TMdbMovie]) {
        hashMap[pageNo] = movies
    }
}
