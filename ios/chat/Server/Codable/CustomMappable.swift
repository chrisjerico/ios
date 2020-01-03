//
//  CustomMappable.swift
//  XiaoJir
//
//  Created by xionghuanxin on 2018/9/29.
//  Copyright © 2018年 xionghx. All rights reserved.
//

import ObjectMapper

public protocol CustomMappable { }

extension Int: CustomMappable { }
extension Bool: CustomMappable { }
extension String: CustomMappable { }
extension NSArray: CustomMappable { }
extension NSDictionary: CustomMappable { }
