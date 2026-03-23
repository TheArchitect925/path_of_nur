# Phase 21 Prompt — Wudu Trainer Quiz and Learning Reinforcement

PRIMARY OBJECTIVE === BUILDING A LIGHTWEIGHT WUDU QUIZ SYSTEM TO REINFORCE LEARNING AFTER THE WUDU TRAINER

You are working in the existing Flutter codebase for Path of Nūr.

This is a targeted production-ready enhancement phase built on top of the existing Wudu Trainer and Learning systems. DO NOT build a full generic quiz engine. Build a focused, Wudu-specific quiz module that reinforces learning safely and cleanly.

--------------------------------------------------
CORE RULES
--------------------------------------------------
- Audit first before editing
- Preserve Wudu Trainer flow, progress, and completion state
- Keep quiz simple, calm, and educational
- Do not create game-heavy UI
- Do not allow XP farming
- Keep structure reusable for future trainers
- No unnecessary package churn
- At the end, provide audit summary

--------------------------------------------------
PHASE OBJECTIVES
--------------------------------------------------

1. Create a Wudu Quiz module linked to the Wudu Trainer

2. Add 3–4 question types:
   - step ordering
   - what comes next
   - identify valid step
   - adab reinforcement

3. Add quiz entry from Wudu Trainer completion

4. Add safe XP reward logic

--------------------------------------------------
A. AUDIT
--------------------------------------------------

Audit:
- Wudu Trainer completion flow
- current reward logic
- navigation patterns
- existing learning models

--------------------------------------------------
B. CREATE WUDU QUIZ MODEL
--------------------------------------------------

Create structured quiz data:

Each question should include:
- id
- question text
- type (order, multiple choice)
- options
- correct answer
- optional explanation

--------------------------------------------------
C. BUILD QUIZ UI
--------------------------------------------------

Create WuduQuizPage

Requirements:
- one question per screen
- clear question text
- simple answer selection
- next button
- no timer
- no complex animations

--------------------------------------------------
D. QUESTION TYPES
--------------------------------------------------

Implement:

1. Step Order
2. What Comes Next
3. Identify Correct Step
4. Adab Question (clean up after wudu)

--------------------------------------------------
E. QUIZ FLOW
--------------------------------------------------

Flow:
- start quiz
- answer questions
- show feedback
- move to next
- show final summary

--------------------------------------------------
F. REWARD LOGIC
--------------------------------------------------

Requirements:
- XP only on first completion
- no duplicate rewards
- Ocean Drop optional (only once)
- track quiz completion safely

--------------------------------------------------
G. INTEGRATION
--------------------------------------------------

Add entry:
- from Wudu completion screen
- optional "Test Your Knowledge" button

--------------------------------------------------
H. DATA SAFETY
--------------------------------------------------

Preserve:
- Wudu progress
- XP systems
- learning state

--------------------------------------------------
I. TESTING
--------------------------------------------------

Test:
- quiz loads correctly
- answers validate correctly
- reward not duplicated
- completion state saved

--------------------------------------------------
DELIVERABLES
--------------------------------------------------

1. Files changed
2. Quiz model summary
3. UI summary
4. Reward logic summary
5. Integration summary
6. Data safety confirmation
7. Validation results
8. FINAL AUDIT

--------------------------------------------------
SUCCESS CRITERIA
--------------------------------------------------

- quiz reinforces Wudu steps
- clean UX
- no reward abuse
- integrates with trainer
- production-safe

--------------------------------------------------

“And say, ‘My Lord, increase me in knowledge.’” — Qur’an 20:114
