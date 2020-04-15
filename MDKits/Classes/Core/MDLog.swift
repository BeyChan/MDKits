//
//  MDLog.swift
//  MDKits
//
//  Created by Marvin on 4/15/20.
//

import Foundation

func MDLog<T>(_ message: T,
              file: String = #file,
              method: String = #function,
              line: Int = #line) {
    debugPrint("\((file as NSString).lastPathComponent)[\(line)], \(method): \(message)")
}
