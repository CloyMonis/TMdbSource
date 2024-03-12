//
//  TMdbMovie.swift
//  TMdbSource
//
//  Created by Cloy Monis on 11/03/24.
//

import Foundation

public struct TMdbMovieResult: Codable {
    var page: Int?
    var results: [TMdbMovie]?
}

public struct TMdbMovie: Codable {
    var title: String?
    var overview: String?
    var poster_path: String?
    var backdrop_path: String?
}
