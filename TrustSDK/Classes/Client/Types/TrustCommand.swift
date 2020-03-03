// Copyright DApps Platform Inc. All rights reserved.
//
// This file is part of TrustSDK. The full TrustSDK copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import Foundation
import TrustWalletCore

enum CommandName: String {
    case getAccounts = "sdk_get_accounts"
    case sign = "sdk_sign"
}

public extension TrustSDK {
    enum Command {
        case sign(coin: CoinType, input: Data)
        case getAccounts(coins: [CoinType])

        public var name: String {
            let name = { () -> CommandName in
                switch self {
                case .getAccounts:
                    return .getAccounts
                case .sign:
                    return .sign
                }
            }()

            return name.rawValue
        }

        public var params: [String: String] {
            switch self {
            case .getAccounts(let coins):
                return [
                    "coins": String(coins: coins),
                ]
            case .sign(let coin, let input):
                return [
                    "coin": coin.rawValue.description,
                    "data": input.base64UrlEncodedString(),
                ]
            }
        }

        public init?(name: String, params: [String: String]) {
            switch CommandName(rawValue: name) {
            case .getAccounts:
                guard let coinsParam = params["coins"] else {
                    return nil
                }

                self = .getAccounts(coins: coinsParam.toCoinArray())
            case .sign:
                guard
                    let coinParam = params["coin"],
                    let dataParam = params["data"],
                    let coin = coinParam.toCoin(),
                    let data = dataParam.toBase64Data()
                else {
                    return nil
                }

                self = .sign(coin: coin, input: data)
            default: return nil
            }
        }

        public init?(components: URLComponents) {
            guard let name = components.host else { return nil }
            self.init(name: name, params: components.queryItemsDictionary())
        }
    }
}

extension TrustSDK.Command: Equatable {}
