//
//  Reachability.swift
//  ug
//
//  Created by xionghx on 2019/10/21.
//  Copyright © 2019 ug. All rights reserved.
//

import RxCocoa
import Alamofire

public final class Reachability {

    public static let shared = Reachability()

    public let status: BehaviorRelay<NetworkReachabilityManager.NetworkReachabilityStatus> = BehaviorRelay(value: .unknown)

    private let reachability = NetworkReachabilityManager()

    public func startNotifier() {
		let listener = { status in
            Reachability.shared.status.accept(status)
        }
		
		guard let isSuccess = reachability?.startListening(onUpdatePerforming: listener), isSuccess else {
			logger.debug("Reachability start listening failure.");
            return
        }

    }

    public func stopNotifier() {
        reachability?.stopListening()
        Reachability.shared.status.accept(.unknown)
    }

}


