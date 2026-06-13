# First-Principles Reconstruction: flower-app

> Applied Elon Musk's first-principles thinking: break to fundamental truths, rebuild from zero.

## Core Problem

People who want to send flowers are stuck on "which flowers?" — buried under a 5-step questionnaire, fake payment, and CRM.

## First Principles Breakdown

1. User doesn't know flower language — "tell me what to buy" IS the product
2. Context determines recommendation: who, occasion, relationship
3. User wants to act, not browse — shortest path to order placed
4. Flower data is static — a lookup table

## Essential Features

| P0 | Scene + budget → recommendation |
| P0 | 3 bouquet options with details |
| P0 | Place order |
| P1 | User auth, order history |

## Over-Engineering

- 768-line recommendation wizard (30 fields → 3 suffice)
- 819-line CRM with allergy tracking and personality profiling
- 277-line fake payment page (2-second spinner + success)
- 377-line MinePage (entirely hardcoded stats)
- Mock data duplicated across 6 locations

## Musk's Razor

14 files, ~2,500 lines (from 28 files, ~6,500). This is a flower app, not Salesforce.
