;; Title: YieldStack Protocol
;; SUMMARY
;; YieldStack is a decentralized yield aggregation protocol built for Bitcoin DeFi
;; on the Stacks Layer 2 ecosystem. It enables efficient capital allocation across 
;; multiple yield-generating strategies while maintaining Bitcoin-grade security.
;; 
;; DESCRIPTION
;; This protocol allows users to deposit SIP-010 tokens into various 
;; Bitcoin-native yield strategies. The contract manages allocations, tracks 
;; user deposits, and distributes yield based on time-weighted contributions.
;; Features include protocol whitelisting, dynamic APY management, emergency 
;; shutdown mechanisms, and flexible yield distribution strategies.

;; CONSTANTS
(define-constant contract-owner tx-sender)

;; Error codes
(define-constant ERR-NOT-AUTHORIZED (err u1000))
(define-constant ERR-INVALID-AMOUNT (err u1001))
(define-constant ERR-INSUFFICIENT-BALANCE (err u1002))
(define-constant ERR-PROTOCOL-NOT-WHITELISTED (err u1003))
(define-constant ERR-STRATEGY-DISABLED (err u1004))
(define-constant ERR-MAX-DEPOSIT-REACHED (err u1005))
(define-constant ERR-MIN-DEPOSIT-NOT-MET (err u1006))
(define-constant ERR-INVALID-PROTOCOL-ID (err u1007))
(define-constant ERR-PROTOCOL-EXISTS (err u1008))
(define-constant ERR-INVALID-APY (err u1009))
(define-constant ERR-INVALID-NAME (err u1010))
(define-constant ERR-INVALID-TOKEN (err u1011))
(define-constant ERR-TOKEN-NOT-WHITELISTED (err u1012))

;; Protocol status constants
(define-constant PROTOCOL-ACTIVE true)
(define-constant PROTOCOL-INACTIVE false)

;; Protocol constraints
(define-constant MAX-PROTOCOL-ID u100)
(define-constant MAX-APY u10000) ;; 100% APY in basis points
(define-constant MIN-APY u0)

;; DATA VARIABLES
(define-data-var total-tvl uint u0)
(define-data-var platform-fee-rate uint u100) ;; 1% (base 10000)
(define-data-var min-deposit uint u100000) ;; Minimum deposit in sats
(define-data-var max-deposit uint u1000000000) ;; Maximum deposit in sats
(define-data-var emergency-shutdown bool false)

;; DATA MAPS
(define-map user-deposits 
    { user: principal } 
    { amount: uint, last-deposit-block: uint })

(define-map user-rewards 
    { user: principal } 
    { pending: uint, claimed: uint })

(define-map protocols 
    { protocol-id: uint } 
    { name: (string-ascii 64), active: bool, apy: uint })

(define-map strategy-allocations 
    { protocol-id: uint } 
    { allocation: uint }) ;; allocation in basis points (100 = 1%)

(define-map whitelisted-tokens 
    { token: principal } 
    { approved: bool })

;; TRAITS
(define-trait sip-010-trait
    (
        (transfer (uint principal principal (optional (buff 34))) (response bool uint))
        (get-balance (principal) (response uint uint))
        (get-decimals () (response uint uint))
        (get-name () (response (string-ascii 32) uint))
        (get-symbol () (response (string-ascii 32) uint))
        (get-total-supply () (response uint uint))
    )
)
