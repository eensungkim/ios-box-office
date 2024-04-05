//
//  KakaoAPI.swift
//  BoxOffice
//
//  Created by Kim EenSung on 3/11/24.
//

import Foundation

enum KakaoAPI {
    case image(query: String)
}

// MARK: - Private Properties
extension KakaoAPI {
    // TODO: baseURL 에서 path 분리하기
    private var baseURL: String {
        return "https://dapi.kakao.com/v2/search/image"
    }
    
    private var apiKey: String {
        guard let apiKey = Bundle.main.infoDictionary?["KAKAO_API_KEY"] as? String else { return "" }
        
        return "KakaoAK \(apiKey)"
    }
}

// MARK: - URLRequestConvertible
extension KakaoAPI: URLRequestConvertible {
    var urlRequest: URLRequest? {
        switch self {
        case .image(let query):
            return URLRequestBuilder(headers: ["Authorization": apiKey])
                .baseURL(baseURL)
                .parameters([["query": "\(query) 영화 포스터"], ["size": "1"]])
                .createURLRequest()
        }
    }
}
