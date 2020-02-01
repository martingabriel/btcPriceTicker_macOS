//
//  AppDelegate.swift
//  MacOSbtcTicker
//
//  Created by Martin Gabriel on 31/01/2020.
//  Copyright © 2020 Martin Gabriel. All rights reserved.
//

import Cocoa
import SwiftUI

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    let btcPriceProvider = BtcPriceProvider()
    var statusBarItem: NSStatusItem!
    let updateTimeout : UInt32 = 30
    let updateQueue = DispatchQueue(label: "priceUpdateThread")
    var updateActive = true

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        // Create the status button
        self.statusBarItem = NSStatusBar.system.statusItem(withLength: CGFloat(NSStatusItem.variableLength))
        
        if let button = self.statusBarItem.button {
            button.title = "₿"
            button.action = #selector(updatePrice(_:))
        }
                
        // start background updating thread
        updateQueue.async {
            while (self.updateActive) {
                self.btcPriceProvider.getCurrentBtcPrice(completion: { newBtcPrice in
                    if let newBtcPriceInfo = newBtcPrice {
                        // update UI
                        DispatchQueue.main.async {
                            if let button = self.statusBarItem.button {
                                button.title = "₿ = \(newBtcPriceInfo.usd)$"
                            }
                        }
                    }
                })
                sleep(self.updateTimeout)
            }
        }
            
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
        updateActive = false
    }

    @objc func updatePrice(_ sender: AnyObject?) {
        if let button = self.statusBarItem.button {
            btcPriceProvider.getCurrentBtcPrice(completion: { newBtcPrice in
                if let newBtcPriceInfo = newBtcPrice {
                    button.title = "₿=\(newBtcPriceInfo.usd)$"
                    //print(newBtcPriceInfo.usd)
                }
            })
        }
    }
    
}

