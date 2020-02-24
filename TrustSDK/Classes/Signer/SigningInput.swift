//  Copyright © 2018 Trust.
//
//	This file is part of TrustSDK. The full TrustSDK copyright notice, including
//	terms governing use, modification, and redistribution, is contained in the
//	file LICENSE at the root of the source code distribution tree.
	

import Foundation
import TrustWalletCore

public protocol SigningInput {
    func encode() throws -> Data
}

extension EthereumSigningInput: SigningInput {
    public func encode() throws -> Data {
        return try self.serializedData()
    }
}
