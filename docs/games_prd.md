# Product Requirements Document (PRD): Financial Fluency Games Module - Phase 1

**Document Version:** 1.0
**Date:** 2023-10-27
**Parent PRD:** Global Currency Assistant App - Initial & Phase 2 Updates (Version 1.0)
**Product Owner:** [Your Name/Role]
**Author:** AI Assistant

---

## 1. Introduction

This document details the requirements for the four mini-games to be implemented in Phase 1 of the Global Currency Assistant app. These games are designed to enhance users' financial fluency, mental math skills, and familiarity with BGN/EUR currency conversion through engaging and replayable challenges.

## 2. Goals & Objectives

*   Increase user engagement and time spent in the app.
*   Educate users on BGN/EUR conversion and value perception.
*   Provide a fun and interactive learning experience.
*   Generate shareable content for organic app marketing.
*   Serve as a foundation for future globalized financial games.

## 3. General Game Requirements (Applicable to all games)

*   **GAMES-GEN-1.1: BGN/EUR Focus:** All games will exclusively use BGN and EUR for conversion and price challenges in Phase 1.
*   **GAMES-GEN-1.2: Exchange Rate:** Use the fixed official exchange rate (1 EUR = 1.95583 BGN) for all calculations.
*   **GAMES-GEN-1.3: Game Selection Screen:** A dedicated "Games" section in the app providing a clear selection of the four mini-games. Each game should have an icon and a brief description.
*   **GAMES-GEN-1.4: Tutorial/Instructions:** A short, optional tutorial or instruction screen before the first play of each game.
*   **GAMES-GEN-1.5: High Score Tracking:** Each game will track and display the user's personal highest score.
*   **GAMES-GEN-1.6: End Game Screen:** After each game round, display:
    *   Score for the just-completed round.
    *   New high score (if achieved).
    *   Buttons for "Play Again," "Go to Games Menu," and "Share Score."
*   **GAMES-GEN-1.7: Share Score Functionality:**
    *   Triggers the native OS share sheet.
    *   Generates a pre-filled message (e.g., "I scored X in [Game Name] on the Global Currency Assistant app! Can you beat me? [App Link]").
    *   **Visual Element:** Include a dynamically generated image containing the game's logo, the score, and the app's logo. `

`

---

## 4. Game 1: Quick Conversion Challenge

### 4.1. Mechanics

*   **Objective:** Convert a given amount from one currency to another as quickly and accurately as possible.
*   **Input/Output:**
    *   **Question:** Display an amount (e.g., "35.50 BGN = ? EUR").
    *   **Answer:** Present 4 multiple-choice options.
*   **Round Structure:** Timed round with a fixed number of questions.

### 4.2. Scoring Rules

*   **Correct Answer:** +100 points.
*   **Incorrect Answer:** -50 points.
*   **Time Bonus:** Additional points awarded based on remaining time when an answer is submitted (e.g., more time left = more bonus points).
*   **Round End:**
    *   When the timer runs out.
    *   When all questions are answered.

### 4.3. Questions / Rounds

*   **Number of Questions:** 10 questions per round.
*   **Timer:** 60 seconds per round (or 6 seconds per question, summed). The timer starts when the first question appears.
*   **Amount Range:** Amounts will be random, covering a realistic range (e.g., 0.50 to 200 BGN/EUR).
*   **Multiple Choice Options:**
    *   One correct answer.
    *   Three incorrect answers:
        *   One "close" answer (e.g., off by ~0.10-0.50 EUR).
        *   One "rough" answer (e.g., off by ~1-3 EUR).
        *   One "distractor" (e.g., a simple calculation error or reversed conversion).
    *   All options displayed to 2 decimal places.
*   **Currency Direction:** Questions will alternate between BGN to EUR and EUR to BGN.

### 4.4. UI/UX

*   **Game Screen:**
    *   Clear display of the current question (e.g., "35.50 BGN").
    *   Large, tappable multiple-choice buttons.
    *   Visible countdown timer/progress bar.
    *   Current score display.
*   **Feedback:** Visual (green check for correct, red 'X' for incorrect) and auditory feedback for each answer.
*   **Progress:** Indicator showing current question out of total (e.g., "Question 3/10").

---

## 5. Game 2: Price Check Panic

### 5.1. Mechanics

*   **Objective:** Quickly judge if a proposed price in EUR for an item originally priced in BGN is a "Good Deal," "Bad Deal," or "About Right," based on the fixed exchange rate.
*   **Input/Output:**
    *   **Question:** Display an item name and its original BGN price (e.g., "Coffee (cup): 2.80 BGN"). Then, a proposed EUR price (e.g., "1.50 EUR").
    *   **Answer:** Three large, distinct buttons: "Good Deal," "Bad Deal," "About Right."
*   **Round Structure:** Fixed number of items within a total time limit.

### 5.2. Scoring Rules

*   **Correct Judgment:** +150 points.
*   **Incorrect Judgment:** -75 points.
*   **Time Bonus:** Smaller time bonus for quick judgments compared to Quick Conversion Challenge.
*   **Round End:** After 10 items or when total time runs out.

### 5.3. Questions / Rounds

*   **Number of Items:** 10 items per round.
*   **Timer:** 75 seconds total per round.
*   **Item List:** A predefined list of 15-20 common items with their typical BGN prices (e.g., bread, milk, coffee, bus ticket, newspaper). Items chosen randomly per round.
*   **Proposed EUR Price Logic:**
    *   **About Right:** Within +/- 5% of the exact converted EUR price.
    *   **Good Deal:** At least 10% lower than the exact converted EUR price.
    *   **Bad Deal:** At least 10% higher than the exact converted EUR price.
    *   The game should ensure a roughly even distribution of "Good," "Bad," and "About Right" scenarios.
*   **Amount Range:** BGN prices reflecting common values for everyday items (e.g., 0.50 BGN to 50 BGN).

### 5.4. UI/UX

*   **Game Screen:**
    *   Clear display of Item Name and BGN Price.
    *   Prominent display of Proposed EUR Price.
    *   Large, tappable "Good Deal," "Bad Deal," "About Right" buttons.
    *   Visual countdown timer/progress bar.
    *   Current score display.
*   **Feedback:** Visual (e.g., button highlights green/red) and auditory feedback.
*   **Justification:** Briefly show the exact conversion after a judgment (e.g., "2.80 BGN = 1.43 EUR").

---

## 6. Game 3: Change Maker Challenge

### 6.1. Mechanics

*   **Objective:** Calculate the correct change owed in EUR, given a total bill in BGN and an amount paid in EUR.
*   **Input/Output:**
    *   **Question:** Display "Bill Total: X BGN" and "Paid with: Y EUR".
    *   **Answer:** User inputs the change in EUR (to 2 decimal places).
*   **Round Structure:** Fixed number of transactions within a total time limit.

### 6.2. Scoring Rules

*   **Exact Correct Answer:** +200 points.
*   **Near Correct (off by up to 0.05 EUR):** +100 points.
*   **Incorrect (more than 0.05 EUR off):** -100 points.
*   **Speed Bonus:** Points for answering quickly.
*   **Round End:** After 8 transactions or when total time runs out.

### 6.3. Questions / Rounds

*   **Number of Transactions:** 8 transactions per round.
*   **Timer:** 90 seconds total per round.
*   **Bill Total (BGN):** Random amounts, realistic for common purchases (e.g., 5.00 BGN to 50.00 BGN).
*   **Paid Amount (EUR):** Round EUR amounts (e.g., 5 EUR, 10 EUR, 20 EUR, 50 EUR, 100 EUR) that are sufficient to cover the bill.
*   **Calculation:**
    1.  Convert BGN Bill Total to EUR.
    2.  Subtract converted bill from EUR Paid Amount to find change.

### 6.4. UI/UX

*   **Game Screen:**
    *   Clear display of "Bill Total" and "Paid with" amounts.
    *   Numeric keypad for entering the change amount.
    *   "Confirm" or "Done" button.
    *   Visible countdown timer/progress bar.
    *   Current score display.
*   **Feedback:** Visual and auditory feedback.
*   **Correction:** Display the correct change if the user's input was incorrect.

---

## 7. Game 4: Budget Buddy Battle

### 7.1. Mechanics

*   **Objective:** Manage a starting budget in EUR by deciding to "Buy" or "Skip" a series of items, some priced in BGN, some in EUR, aiming to maximize purchases without exceeding the budget.
*   **Input/Output:**
    *   **Initial:** Display "Your Budget: X EUR."
    *   **Per Item:** Display "Item: [Name]", "Price: [Amount in BGN or EUR]".
    *   **Answer:** Two buttons: "Buy" or "Skip."
*   **Round Structure:** Fixed number of items.

### 7.2. Scoring Rules

*   **Successful Purchase (within budget):** +100 points.
*   **Skipped Item (to stay within budget):** +50 points (encourages smart skipping).
*   **Exceeding Budget:** -200 points, round ends immediately.
*   **Remaining Budget Bonus:** At the end, bonus points based on remaining budget (e.g., 10 points per 1 EUR left).
*   **Round End:** After 10 items or if budget is exceeded.

### 7.3. Questions / Rounds

*   **Number of Items:** 10 items per round.
*   **Starting Budget:** Random (e.g., 20 EUR to 50 EUR).
*   **Item List:** Same as Price Check Panic, with prices randomly assigned as either BGN or EUR for each item in each round.
*   **Item Presentation:** Items presented one at a time. After a decision, update the remaining budget.

### 7.4. UI/UX

*   **Game Screen:**
    *   Prominent "Remaining Budget: X EUR" display.
    *   Clear display of the current item and its price (with currency symbol).
    *   "Buy" and "Skip" buttons.
    *   Current score display.
*   **Feedback:**
    *   Visual update of remaining budget after each purchase.
    *   Confirmation of purchase (e.g., "Bought [Item Name] for X EUR").
    *   Clear message if budget is exceeded.
*   **Conversion Hint (Optional/Tooltip):** Consider a subtle visual cue or a small tap-to-reveal hint that shows the EUR equivalent for BGN-priced items *before* the user decides, especially for early players.
