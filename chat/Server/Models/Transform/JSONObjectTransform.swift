//
//  JSONObjectTransform.swift
//  XiaoJir
//
//  Created by diao on 2018/11/1.
//  Copyright © 2018年 xionghx. All rights reserved.
//

import ObjectMapper

public class JSONObjectTransform<Element>: TransformType where Element: Mappable {

    public typealias Object = Element
    public typealias JSON = String

    public init() {

    }

    public func transformFromJSON(_ value: Any?) -> Object? {
        if let string = value as? JSON {
            return Mapper<Element>().map(JSONString: string)
        }
        return nil
    }

    public func transformToJSON(_ value: Object?) -> JSON? {
        return value?.toJSONString()
    }

}
