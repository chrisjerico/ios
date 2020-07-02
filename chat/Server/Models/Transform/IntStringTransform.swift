//
//  IntStringTransform.swift
//  XiaoJir
//
//  Created by xionghx on 2018/12/18.
//  Copyright © 2018 xionghx. All rights reserved.
//
import ObjectMapper

public let stringTransform = TransformOf<String, Any>(fromJSON: { (value: Any?) -> String? in
	
	if let value = value as? Int {
		return "\(value)"
	} else if let value = value as? String {
		return value
	} else if let value = value as? NSNumber {
		return "\(value)"
	}
	return nil
	
}, toJSON: { (value: String?) -> String? in
	return value
})

public let intTransform = TransformOf<Int, Any>(fromJSON: { (value: Any?) -> Int? in
	
	if let value = value as? Int {
		return value
	} else if let value = value as? String {
		return Int(value)
	}
	return nil
	
}, toJSON: { (value: Int?) -> Int? in
	
	if let value = value {
		return value
	} else {
		return nil
	}
})

public let doubleTransform = TransformOf<Double, Any>(fromJSON: { (value: Any?) -> Double? in
	
	if let value = value as? Double {
		return value
	} else if let value = value as? String {
		return Double(value)
	}
	return nil
	
}, toJSON: { (value: Double?) -> Double? in
	
	if let value = value {
		return value
	} else {
		return nil
	}
})
