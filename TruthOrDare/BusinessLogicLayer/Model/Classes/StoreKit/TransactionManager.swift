//
//  PurchaseManager.swift
//  TruthOrDare
//
//  Created by Imran Hajiyev on 14.08.23.
//

import Foundation
import StoreKit

class TransactionManager {
    static let shared = TransactionManager()
    
    private let productIds: [String] = ["truthGPTMonthlySubscription"]
    
    var purchasedProductIds: Set<String> = Set<String>()
    var products: [Product] = []
    var isPremium: Bool {
        !self.purchasedProductIds.isEmpty
    }
    
    func fetchProducts() async throws {
        do {
            self.products = try await Product.products(for: productIds)
        } catch {
            print("Error occured while trying to fetch products: \(error)")
        }
        
    }
    
    func purchase(_ product: Product) async throws {
        let result = try await product.purchase()
        
        switch result {
        case .pending:
            print("Transaction is pending")
        case .success(let verificationResult):
            switch verificationResult {
            case .unverified(_, let verificationError):
                print("Tranaction was successful but could not verified due to: \(verificationError)")
            case .verified(let signedType):
                print("Tranaction was successful and verified: \(signedType)")
                await signedType.finish()
                await self.refreshPurchasedProducts()
            }
        case .userCancelled:
            print("Transaction is user cancelled")
        default:
            print("Unknown error during purchase.")
        }
    }
    
    func refreshPurchasedProducts() async {
        // Iterate through the user's purchased products.
        for await verificationResult in Transaction.currentEntitlements {
            switch verificationResult {
            case .verified(let transaction):
                // Check the type of product for the transaction
                // and provide access to the content as appropriate.
                if transaction.revocationDate == nil {
                    self.purchasedProductIds.insert(transaction.productID)
                } else {
                    self.purchasedProductIds.remove(transaction.productID)
                }
            case .unverified(let unverifiedTransaction, let verificationError):
                // Handle unverified transactions based on your
                // business model.
                print(unverifiedTransaction)
                print(verificationError)
            }
        }
    }
    
    func restorePurchases() async throws {
        do {
            try await AppStore.sync()
        } catch {
            print("Error occured while trying to restore purchases: \(error)")
        }
    }
}
