//
//  Codable+Utilities.swift
//  splitty
//
//  Created by Pranjal Satija on 9/2/18.
//  Copyright © 2018 Pranjal Satija. All rights reserved.
//

import Foundation

extension Decodable {
    static func decoded(from jsonData: Data, using decoder: JSONDecoder = JSONDecoder()) throws -> Self {
        return try decoder.decode(Self.self, from: jsonData)
    }
}

extension Encodable {
    func jsonEncoded(using encoder: JSONEncoder = JSONEncoder()) throws -> Data {
        return try encoder.encode(self)
    }
}
