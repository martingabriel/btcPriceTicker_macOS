//
//  BtwPriceProvider.swift
//  MacOSbtcTicker
//
//  Created by Martin Gabriel on 31/02/2020.
//  Copyright © 2020 Martin Gabriel. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class BtcPriceProvider {
    
    func getCurrentBtcPrice(completion: @escaping (BtcPriceInfo?) -> ()) {
        let requestUrl = "https://api.coingecko.com/api/v3/simple/price?ids=bitcoin&vs_currencies=usd"
        
        Alamofire.request(requestUrl).responseJSON { response in
            if let data = response.data {
                let json = JSON(data)
                let price = json["bitcoin"]["usd"].doubleValue
                                
                completion(BtcPriceInfo(price: price))
            } else {
                completion(nil)
            }
        }
    }
}
