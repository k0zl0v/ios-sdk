//
//  Coupon.swift
//  Mindbox
//
//  Created by Mikhail Plotnikov on 06.05.2021.
//  Copyright © 2021 Mikhail Barilov. All rights reserved.
//

import Foundation

// MARK: - Coupon
public class Coupon: Codable {
    public var ids: IDS?
    public var pool: Pool?

    public init(ids: IDS?, pool: Pool?) {
        self.ids = ids
        self.pool = pool
    }
    
    // MARK: - IDS
    public class IDS: Codable {
        public var code: String?

        public init(code: String?) {
            self.code = code
        }
    }
}
