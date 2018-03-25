//
//  SubscriptionService.swift
//  VenEcon2
//
//  Created by Girish Gupta on 22/10/2017.
//  Copyright © 2017 Girish Gupta. All rights reserved.
//

import Foundation
import StoreKit

import DTFoundation
import Kvitto

class SubscriptionService : NSObject, SKProductsRequestDelegate, SKPaymentTransactionObserver, ENSideMenuDelegate
{
    
    
    static let shared = SubscriptionService() // this makes it a singleton. static means that rther than belonging to a specific instance of a class, it belongs to the class itself.
    
    
    
    var PriceAsString : String = ""
    
    
    
    
    
    
    
    func receipt() -> Receipt? {
        guard let receiptURL = Bundle.main.appStoreReceiptURL else {
            return nil
        }
        
        return Receipt(contentsOfURL: receiptURL)
    }
    
    func isSubscriptionValid() -> Bool {
        // If they don't have a receipt, they did not subscribe!
        guard let receipt = receipt() else {
            return false
        }
        
        // If the receipt doesn't have any IAPs, they did not subscribe!
        guard let inAppPurchases = receipt.inAppPurchaseReceipts else {
            return false
        }
        
        // Look through all IAPs for a subscription that hasn't expired
        let now = Date()
        for inAppPurchase in inAppPurchases {
            guard let expirationDate = inAppPurchase.subscriptionExpirationDate else {
                // Skip to the next IAP if this one doesn't have an expiration data
                continue
            }
            
            if expirationDate > now {
                // This subscription expires in the future, so it is currently valid!
                return true
            }
        }
        
        // If we reached here, we couldn't find a subscription with an expiration date in the future
        return false
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        DispatchQueue.main.async { //need to make sure notifiacciton posted in main thread as we're doing UI work with the table view

        for transaction in transactions
        {
            switch transaction.transactionState{
            case .purchased,.restored:
                //got $$$ unlock all features
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UserUpgraded"), object: nil)
                SKPaymentQueue.default().finishTransaction(transaction)
                
                
                break
            case .failed:
                //cancelled, credit card didn't work, whatever. Nothing for me to do to
                break
            case .deferred:
                //they haven't even been asked yet
                break
            case .purchasing:
                //I'm waiting to find out if they go ahead
                break
            }
        }
    }
    }
    



    
    var product : SKProduct? = nil
    
    var request : SKProductsRequest?
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
       product = response.products.first // because we only have one
        print((product?.localizedTitle)! + " will cost you ")
        print(product?.price)
        //Access All Indicators will cost you Optional(3.49)
        
        //https://stackoverflow.com/questions/2894321/how-to-access-the-price-of-a-product-in-skpayment
        let formatter = NumberFormatter() // On 20171023 when playing with UI
        formatter.formatterBehavior = .behavior10_4
        formatter.numberStyle = .currency
        formatter.locale = product?.priceLocale
        PriceAsString = formatter.string(from: (product?.price)!)! as String
        print(PriceAsString)

    }
    
    func LoadSubscription()
    {
        let ProductIDs : Set = Set(["com.girish.venezuelaecon.allaccess"])
        
        let request = SKProductsRequest(productIdentifiers: ProductIDs)
        
        request.delegate = self
        request.start()
        
        self.request = request
    }
    
    func PurchaseSubscription()
    {
        guard let product = product else { return } // saying if product is nil then just return
        //everything now will only run if we have a product
        //now we need to make a payment object with this product
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
        //Now need to register ourselves as observer of above
    }
    
    func Restore()
    {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    override init() {
        super.init()
        SKPaymentQueue.default().add(self)
    }
    
    //https://www.raywenderlich.com/154737/app-purchases-auto-renewable-subscriptions-tutorial
    private func loadReceipt() -> Data? {
        guard let url = Bundle.main.appStoreReceiptURL else {
            return nil
        }
        
        do {
            let data = try Data(contentsOf: url)
            return data
        } catch {
            print("Error loading receipt data: \(error.localizedDescription)")
            return nil
        }
    }
    
    var IsSubscriber: Bool {
        return loadReceipt() != nil // What if the user has another product? And what if they have a receipt from 9 months ago but cancelled <9months ago?
    }
}
