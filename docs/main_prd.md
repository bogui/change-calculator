# Product Requirements Document (PRD): Global Currency Assistant App - Initial & Phase 2 Updates

**Document Version:** 1.0
**Date:** 2023-10-27
**Product Owner:** [Your Name/Role]
**Author:** AI Assistant

---

## 1. Introduction

This PRD outlines the requirements for the immediate upcoming updates to the Global Currency Assistant mobile application, encompassing Phase 1 (Initial Update) and Phase 2 (Global Expansion & User Engagement). The goal is to evolve the app from a localized BGN/EUR transition tool into a globally relevant financial utility, fostering user engagement and laying the groundwork for future monetization.

## 2. Goals & Objectives

*   **Expand User Base:** Transition from a Bulgaria-specific tool to an app with global appeal.
*   **Increase Engagement:** Introduce interactive features to encourage regular app usage.
*   **Improve Utility:** Provide robust, universally applicable financial tools.
*   **Foundation for Monetization:** Establish core infrastructure (user accounts, cloud sync hooks) to support future premium offerings.
*   **Organic Marketing:** Leverage sharing features to promote app discovery.

## 3. Scope of this PRD

This document covers functionalities to be implemented in **Phase 1 (Initial Update)** and **Phase 2 (Immediate Follow-up to Initial Update)**. Subsequent phases will be covered in separate PRDs or extensions.

---

## 4. Phase 1: Initial Update - Financial Fluency Games

**Objective:** Introduce engaging, educational mini-games to boost user interaction and make currency understanding fun, leveraging the existing BGN/EUR context and preparing for global expansion.

### 4.1. Feature: Financial Fluency Games Module

**Description:** A new section within the app dedicated to interactive mini-games designed to improve mental calculation and currency conversion skills.

**Requirements:**

*   **GAMES-1.1: Number of Games:** Implement 3-4 distinct mini-games.
*   **GAMES-1.2: Initial Focus (BGN/EUR):** Games will initially focus on BGN/EUR conversion and calculations, reflecting the app's current primary user base.
*   **GAMES-1.3: Game Types (Examples):**
    *   **Quick Conversion Challenge:** Users are presented with an amount in one currency and must quickly select/input its equivalent in the other (BGN/EUR).
    *   **Mental Tip Calculator:** Users practice calculating tips and final bill amounts in a foreign currency context (e.g., simulating dining out in a Eurozone country from a Bulgarian perspective).
    *   *(Further game ideas will be detailed in a dedicated mini-games PRD appendix).*
*   **GAMES-1.4: Scoring System:** Each game must have a clear scoring mechanism.
*   **GAMES-1.5: Feedback:** Provide immediate feedback on correctness and performance.
*   **GAMES-1.6: Accessibility:** Games should be intuitive and easy to understand for all users.

---

## 5. Phase 2: Global Expansion & User Engagement

**Objective:** Transform the app into a globally useful tool by expanding core functionality, enabling user personalization, and establishing a cloud-ready architecture.

### 5.1. Feature: Advanced Multi-Currency Converter

**Description:** Expand the existing currency converter to support a broad range of global currencies dynamically, using an external API.

**Requirements:**

*   **CONV-2.1: Currency Coverage:** Support for a limited number of the most commonly used global currencies initially. (e.g., USD, EUR, GBP, JPY, CHF, CAD, AUD, BGN, etc. - exact list TBD based on API capabilities and user demand).
*   **CONV-2.2: Dynamic Exchange Rates:** Integrate with a reliable, free-tier currency exchange rate API to fetch daily/hourly updated rates for all supported currency pairs.
*   **CONV-2.3: User Interface:** Maintain the current intuitive interface for inputting amounts and selecting currencies, extended to include the expanded currency list.
*   **CONV-2.4: Conversion Direction:** Allow seamless conversion in both directions (Currency A to Currency B, and vice-versa).

### 5.2. Feature: Global Expense Logger (Basic)

**Description:** A standalone module allowing users to log personal expenses in any currency, categorize them, and view basic reports.

**Requirements:**

*   **EXP-2.1: Expense Entry:** Users can input:
    *   Amount
    *   Currency of expense
    *   Date/Time (auto-fillable with override)
    *   Description/Note
    *   **User-Managed Categories:** Users can create, edit, and delete their own local categories. No predefined global categories will be forced.
*   **EXP-2.2: Reporting (Local):** Display basic aggregated reports based on locally stored data:
    *   Total spending by currency.
    *   Total spending converted to a user-selected home currency (see `USER-2.4`).
    *   Basic breakdown by user-defined category (e.g., list or simple chart).
*   **EXP-2.3: Local Storage:** All expense data will be stored locally on the user's device in this phase.
*   **EXP-2.4: No Tags:** Tags are explicitly out of scope for this initial version.

### 5.3. Feature: User Login, Profile, & Account Management

**Description:** Implement a secure user account system to enable personalization, data persistence, and future premium feature access.

**Requirements:**

*   **USER-2.1: Authentication:** Support Google Sign-in as the primary authentication method.
*   **USER-2.2: User Profile:** Store essential user information:
    *   Display Name (editable)
    *   Email (retrieved from Google Sign-in, non-editable)
    *   Preferred Country (user-selectable from a list)
    *   Preferred Home Currency (user-selectable from the list of supported currencies, for expense logging reports).
*   **USER-2.3: Account Creation/Management:** Provide clear UI for user sign-up, sign-in, and basic profile editing.
*   **USER-2.4: Cloud Sync (Monetization Hook):**
    *   Offer cloud synchronization for expense logger data as an *initial paid feature preview*.
    *   Users get a free trial of `X` months (e.g., 3 months) for cloud sync upon account creation. After the trial, it becomes a paid subscription feature.
    *   Ensure clear communication regarding the trial period and future monetization.

### 5.4. Feature: Basic Sharing

**Description:** Enable users to share app-generated content to social networks, fostering organic growth.

**Requirements:**

*   **SHARE-2.1: Shareable Content:**
    *   Game scores from the Financial Fluency Games module.
    *   Budget tracking results (e.g., a "badge" if a user completes a trip within budget - *Note: Trip Budget Planner is in a later phase, so this will be for future implementation or adapted to a 'daily budget achievement' if a simpler budget feature is introduced earlier*).
*   **SHARE-2.2: Sharing Mechanism:** Utilize the native OS share sheet for text-based sharing to various social networks and messaging apps.
*   **SHARE-2.3: App Link Integration:** All shared content must include a clear link back to the app's store listing.
*   **SHARE-2.4: Social Network Specifics:** Design shared messages to be engaging and suitable for common platforms (e.g., Twitter, Facebook, WhatsApp).

---

## 6. Future Considerations (Out of Scope for this PRD)

*   Advanced Exchange Rate Alerts (real-time, push notifications)
*   Smart Tip Calculator (standalone and integrated)
*   Comprehensive Travel Budget Planner (multi-user, detailed budgets)
*   Receipt Scanner (OCR)
*   Further Authentication Methods (Apple Sign-in, Email/Password)
*   Ad-free premium tiers
*   Expanded Financial Fluency Games
*   Cryptocurrency support

---

## 7. Technical Considerations (High-Level)

*   **Mobile Platforms:** Android (primary focus for Google Play).
*   **Backend:** A lightweight backend will be required for user account management and potential cloud sync.
*   **API Integration:** Integration with a third-party currency exchange rate API.
*   **Privacy & Security:** Adhere to GDPR and other relevant data protection regulations, especially with user accounts and cloud data.

---

## 8. Success Metrics

*   **Phase 1:** Increased app engagement (e.g., daily active users, time spent in app on games), positive feedback on games.
*   **Phase 2:** Growth in global user base, number of registered users, adoption of expense logging feature, initial trial conversions for cloud sync.
*   **General:** App Store ratings and reviews.
