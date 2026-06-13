# First-Principles Reconstruction: flower-app

> Applied Elon Musk's first-principles thinking: break to fundamental truths, rebuild from zero.

## Core Problem

People who want to send flowers are stuck on which flowers to buy.

## First Principles Breakdown

1. The user doesn't know flower language. The entire value is tell me what to buy.
2. Context determines the recommendation. Who, what occasion, relationship.
3. Flower meaning data is static. A lookup table.

## Essential Features

| Priority | Feature |
|----------|---------|
| P0 | Scene + budget -> bouquet recommendation |
| P0 | Show 3 options with flower list, meaning, price |
| P0 | Place order |
| P1 | User auth |
| P1 | Order history |

## Reconstruction Blueprint

14 files, ~2,500 lines (down from 28 files, ~6,500 lines).

## Musk\'s Razor

Cut payment simulation, MinePage, recipient personality tracking. This is a flower app, not Salesforce.
