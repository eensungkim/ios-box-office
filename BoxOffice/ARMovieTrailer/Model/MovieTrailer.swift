//
//  MovieTrailer.swift
//  BoxOffice
//
//  Created by LeeSeongYeon on 2024/03/18.
//

import Foundation

struct MovieTrailer {
    static var trailers: [String: MovieTrailer] = [:]
    
    let name: String
    let image: URL?
    let video: URL?
    
    init(name: String, image: String, video: String) {
        self.name = name
        self.image = URL(string: image)
        self.video = URL(string: video)
        
        MovieTrailer.trailers[name] = self
    }
}
