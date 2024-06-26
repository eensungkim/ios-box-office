//
//  MovieImageDocument.swift
//  BoxOffice
//
//  Created by Kim EenSung on 3/11/24.
//

import Foundation

struct MovieImageDocument: Decodable {
    let meta: Meta
    let documentResults: [DocumentResults]
    
    enum CodingKeys: String, CodingKey {
        case meta
        case documentResults = "documents"
    }
    
    struct Meta: Decodable {
        let totalCount, pageableCount: Int
        let isEnd: Bool
        
        enum CodingKeys: String, CodingKey {
            case totalCount = "total_count"
            case pageableCount = "pageable_count"
            case isEnd = "is_end"
        }
    }
    
}

struct DocumentResults: Decodable {
    let collection: String
    let thumbnailURL: String
    let imageURL: String
    let width, height: Int
    let displaySitename: String
    let docURL: String
    let datetime: String
    
    enum CodingKeys: String, CodingKey {
        case collection
        case thumbnailURL = "thumbnail_url"
        case imageURL = "image_url"
        case width, height
        case displaySitename = "display_sitename"
        case docURL = "doc_url"
        case datetime
    }
}

