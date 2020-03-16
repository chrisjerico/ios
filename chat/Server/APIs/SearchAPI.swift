//
//  SearchAPI.swift
//  XiaoJir
//
//  Created by xionghx on 2019/8/30.
//  Copyright © 2019 xionghx. All rights reserved.
//

import Foundation
import Moya

let SearchAPI = MoyaProvider<SearchTarget>(plugins: [APILogger.default])
//let SearchAPI = MoyaProvider<SearchTarget>(endpointClosure: { MoyaProvider.defaultEndpointMapping(for: $0) }, requestClosure: { (endpoint: Endpoint, closure: MoyaProvider.RequestResultClosure) in
//	if var request = try? endpoint.urlRequest() {
//		request.timeoutInterval = appEnv.timeout
//		closure(.success(request))
//	}
//}, plugins: [APILogger.default])

enum SearchTarget {
	case query(String)
}

extension SearchTarget: TargetType {
	var baseURL: URL {
		return appEnv.baseUrl

	}
	
	var path: String {
		switch self {
		case .query:
			return "v1/search"
		}
	}
	
	var method: Moya.Method {
		return .get
	}
	
	var sampleData: Data {
		return Data()
	}
	
	var task: Moya.Task {
		
		var urlParameters = [String: Any]()
		if case let .query(text) = self {
			urlParameters["query"] = text
		}
		return Task.requestParameters(parameters: urlParameters, encoding: URLEncoding.default)
//		return Task.requestCompositeParameters(bodyParameters: [:], bodyEncoding: JSONEncoding.default, urlParameters: urlParameters)
	}
	
	var headers: [String : String]? {
		return ["token": App.user.token]
	}
	
	
}
