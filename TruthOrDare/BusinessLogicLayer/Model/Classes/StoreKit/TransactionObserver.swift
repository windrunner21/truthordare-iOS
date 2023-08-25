//
//  TransactionObserver.swift
//  TruthOrDare
//
//  Created by Imran Hajiyev on 14.08.23.
//

import Foundation
import StoreKit

class TransactionObserver {
    private var updates: Task<Void, Never>?
    
    init() {
        print("init TransactionObserver.")
        self.updates = self.newTransactionListenerTask()
    }
    
    deinit {
        // Cancel the update handling task.
        print("deinit TransactionObserver.")
        updates?.cancel()
    }
    
    private func newTransactionListenerTask() -> Task<Void, Never> {
        Task(priority: .background) {
            for await verificationResult in Transaction.updates {
                await self.handle(updatedTransaction: verificationResult)
            }
        }
    }
    
    private func handle(updatedTransaction verificationResult: VerificationResult<Transaction>) async {
        guard case .verified(let transaction) = verificationResult else {
            // Ignore unverified transactions.
            return
        }
        
        print("From TransactionObserver: \(transaction)")
        
        if transaction.revocationDate != nil {
            // Remove access to the product identified by transaction.productID.
            // Transaction.revocationReason provides details about
            // the revoked transaction.
            TransactionManager.shared.purchasedProductIds.remove(transaction.productID)
            Settings.revokeTruthAIPlusAccess()
        } else if let expirationDate = transaction.expirationDate, expirationDate < Date() {
            // Do nothing, this subscription is expired.
            await transaction.finish()
            return
        } else if transaction.isUpgraded {
            // Do nothing, there is an active transaction
            // for a higher level of service.
            return
        } else {
            // Provide access to the product identified by
            // transaction.productID.
            await transaction.finish()
            TransactionManager.shared.purchasedProductIds.insert(transaction.productID)
        }
        
        NotificationCenter.default.post(name: NSNotification.Name("CheckAccess"), object: nil)
    }
}
