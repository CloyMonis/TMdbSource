//
//  TMdbMovie.swift
//  TMdbSource
//
//  Created by Cloy Monis on 11/03/24.
//

import Foundation

public enum Category {
    case latest
    case popular
    func getApiName() -> String {
        switch self {
        case .latest:
            return "top_rated"
        case .popular:
            return "popular"
        }
    }
}

public struct TMdbMovieResult: Codable {
    var page: Int?
    var results: [TMdbMovie]?
}

public struct TMdbMovie: Codable {
    public var title: String?
    public var overview: String?
    public var poster_path: String?
    public var backdrop_path: String?
    public var release_date: String?
    public var id: Int?
    public var popularity: Float?
    public var vote_average: Float?
    public var vote_count: Int?
}

public struct TMdbMovieDetail: Codable {
    public var genres: [Genre]?
    public var overview: String?
    public var release_date: String?
    public var title: String?
    public var vote_average: Float?
    public var revenue: Int?
    public var poster_path: String?
}

public struct Genre: Codable {
    public var name: String?
}
