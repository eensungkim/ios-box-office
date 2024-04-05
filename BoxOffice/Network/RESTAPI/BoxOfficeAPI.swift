//
//  KoreanFilmCouncilURLEnumeration.swift
//  BoxOffice
//
//  Created by Kim EenSung on 2/15/24.
//

import Foundation

enum BoxOfficeAPI {
    case dailyBoxOffice(targetDate: String)
    case movieDetailInformation(movieCode: String)
}

// MARK: - Private Properties
extension BoxOfficeAPI {
    // TODO: baseURL 에서 path 분리하기
    private var baseURL: String {
        return "https://kobis.or.kr/kobisopenapi/webservice/rest/"
    }
    
    private var apiKey: String {
        guard let apiKey = Bundle.main.infoDictionary?["BOXOFFICE_API_KEY"] as? String else { return "" }
        
        return apiKey
    }
}

// MARK: - URLRequestConvertible
extension BoxOfficeAPI: URLRequestConvertible {
    var urlRequest: URLRequest? {
        switch self {
        case .dailyBoxOffice(let targetDate):
            return URLRequestBuilder()
                .baseURL(baseURL)
                .path("boxoffice/searchDailyBoxOfficeList.json")
                .parameters([["key": apiKey], ["targetDt": targetDate]])
                .createURLRequest()
        
        case .movieDetailInformation(let movieCode):
            return URLRequestBuilder()
                .baseURL(baseURL)
                .path("movie/searchMovieInfo.json")
                .parameters([["key": apiKey, "movieCd": movieCode]])
                .createURLRequest()
        }
    }
}
