//
//  Closure.swift
//  MDFooBox
//
//  Created by cloud.huang on 2019/10/17.
//  Copyright © 2019  MarvinChan. All rights reserved.
//

import Foundation
typealias VoidCallback = (()->())
typealias BoolCallback = ((Bool)->())
typealias StringCallback = ((String?)->())
typealias AssignedCallback<T> = ((T?)->())
