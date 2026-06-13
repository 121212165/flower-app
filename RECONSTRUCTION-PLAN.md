# Reconstruction Plan: flower-app

> Musk-style first-principles cut. 27 files → 14 files. ~6,500 lines → ~2,500 lines.

## Core Problem Restatement

People who want to send flowers are stuck on which flowers to buy. The entire value is **"tell me what to buy"** — scene + budget → 3 bouquet options → order. Everything else is noise.

---

## Files to DELETE (13 files, ~3,787 lines)

| # | File | Lines | Reason |
|---|------|-------|--------|
| 1 | `pages/MinePage.ets` | 376 | User profile/stats page. "My" page is vanity. Core loop doesn't need it. |
| 2 | `pages/RecipientProfile.ets` | 818 | Recipient personality tracking, hobby/interest forms, timeline. "This is a flower app, not Salesforce." |
| 3 | `pages/PaymentPage.ets` | 276 | Simulated payment with fake delay animation. Adds zero value. |
| 4 | `pages/FlowerLibrary.ets` | 535 | Full flower encyclopedia browser with filters, dialogs, care advice. Users don't browse — they need recommendations. |
| 5 | `pages/OrderDetailPage.ets` | 414 | Order detail with status tracking, progress steps. P1 feature bloated to P0 complexity. |
| 6 | `pages/OrderListPage.ets` | 370 | Order list with tab filtering. P1 feature. Cut entirely. |
| 7 | `pages/LoginPage.ets` | 411 | Full login/register with SMS verification, countdown timer. Auth is P1. Cut entirely. |
| 8 | `pages/CartPage.ets` | 270 | Shopping cart with quantity adjustment, swipe-to-delete. Cart is an intermediate step — merge into order flow. |
| 9 | `pages/OrderConfirmPage.ets` | 492 | Order confirmation with delivery form, greeting card, price breakdown. Merge simplified version into ResultPage. |
| 10 | `components/FlowerCard.ets` | 71 | Used only by FlowerLibrary and HomePage's hot flowers section. Both are cut/simplified. |
| 11 | `components/StepIndicator.ets` | 60 | Visual step indicator for 5-step wizard. Wizard is being reduced to 3 steps — inline the indicator. |
| 12 | `models/UserModel.ets` | 63 | User, login, register, recipient interfaces. All cut features. |
| 13 | `store/CartStore.ets` | 161 | Cart state management with AppStorage + Preferences persistence. Cart is cut. |

---

## Files to KEEP UNCHANGED (4 files, 306 lines)

| # | File | Lines | Why |
|---|------|-------|-----|
| 1 | `entryability/EntryAbility.ets` | 45 | App lifecycle. Boilerplate. No change needed. |
| 2 | `common/Theme.ets` | 63 | Theme constants. Used everywhere. No change needed. |
| 3 | `components/CommonButton.ets` | 120 | Reusable button component. Used everywhere. No change needed. |
| 4 | `components/BouquetCard.ets` | 78 | Bouquet scheme card. Core component for ResultPage. No change needed. |

---

## Files to MODIFY (10 files)

### 1. `pages/Index.ets` (108 → ~55 lines)

**Current:** 4 tabs — 首页, 推荐, 花材库, 我的
**Target:** 2 tabs — 首页, 推荐

Changes:
- Remove `FlowerLibrary` import and TabContent
- Remove `MinePage` import and TabContent
- Remove cart badge logic (`cartItemCount`, `StorageLink`)
- Remove `CartStore.initAppStorage()` and `CartStore.loadFromDisk()`
- Reduce `tabItems` from 4 to 2
- Update `TabBuilder` icons array from 4 to 2
- Update `$r()` resource references to match 2 tabs

### 2. `pages/HomePage.ets` (258 → ~120 lines)

**Current:** Search bar + Banner + Scene selector + Hot flowers grid (FlowerCard)
**Target:** Scene selector + "Start recommendation" button. That's it.

Changes:
- Remove `FlowerCard` import
- Remove `FlowerInfo`, `FlowerCategory`, `FlowerColor` imports
- Remove `ApiService` import
- Remove `CartStore` import
- Remove `searchKeyword` state and search bar UI
- Remove `bannerIndex`, `bannerData`, and Banner/Swiper section
- Remove `hotFlowers` state, `loadHotFlowers()`, `getMockFlowers()`, and hot flowers grid
- Remove `isLoading` state
- Keep SceneSelector — it's the core entry point
- Add a prominent "开始推荐" button below SceneSelector
- Simplify `onSceneSelect` to navigate directly to RecommendPage with scene param

### 3. `pages/RecommendPage.ets` (767 → ~300 lines)

**Current:** 5-step wizard — 送花对象, 场景选择, 关系背景, 对方画像, 预算配送
**Target:** 3-step wizard — 场景选择, 预算与偏好, 生成方案

Changes:
- Remove Step 1 (送花对象): `recipientList`, `selectedRecipientId`, `showNewRecipient`, all new recipient form fields, `loadRecipients()`, `ApiService.getRecipients()`, `ApiService.createRecipient()`
- Remove Step 3 (关系背景): `relationshipDuration`, `sentFlowersBefore`, `recentEvents`, `interactionModes`, `DURATION_OPTIONS`, `FLOWER_EXP_OPTIONS`, `INTERACTION_OPTIONS`
- Remove Step 4 (对方画像): `hobbies`, `personality`, `profession`, `cultureNote`, `HOBBY_OPTIONS`, `PERSONALITY_OPTIONS`, `PROFESSION_OPTIONS`
- Remove `StepIndicator` import — inline a simple text indicator
- Remove `RecipientInfo`, `CreateRecipientParams` imports
- Merge remaining fields into 3 steps:
  - Step 1: Scene selection (SceneSelector + quick description)
  - Step 2: Budget slider + color preference + style preference
  - Step 3: Review + generate button
- Simplify `buildRecommendParams()` — remove recipient ID, remove extra info JSON
- Simplify `submitRecommendation()` — remove recipient creation logic

### 4. `pages/ResultPage.ets` (452 → ~250 lines)

**Current:** Shows 3 schemes with details, "加入购物车" and "直接下单" buttons
**Target:** Shows 3 schemes with details + inline order form at bottom

Changes:
- Remove `CartStore` import — no more cart
- Remove `selectScheme()` method (add to cart)
- Replace `selectSchemeDirect()` with inline order form
- Add `showOrderForm` state (boolean)
- Add order form fields: `recipientName`, `phone`, `deliveryAddress`, `greetingMessage`
- When user taps "立即下单" on a scheme, show inline form below the scheme card
- Add `submitOrder()` method that calls `ApiService.createOrder()` and shows success state
- Add success state with "下单成功" message
- Remove "换一批方案" button (or keep if API supports it)
- Remove `copyGreetingText()` clipboard logic — simplify to just display

### 5. `models/FlowerModel.ets` (60 → ~35 lines)

**Current:** `FlowerCategory` enum (10 values), `FlowerColor` enum (8 values), `FlowerInfo` interface (12 fields), `GetFlowersParams`, `GetFlowersResponse`
**Target:** Keep `FlowerInfo` with essential fields only. Remove request/response types.

Changes:
- Keep `FlowerCategory` but reduce to 6 values: ROSE, LILY, CARNATION, SUNFLOWER, HYDRANGEA, OTHER
- Keep `FlowerColor` but reduce to 5 values: RED, WHITE, YELLOW, PINK, MIXED
- Keep `FlowerInfo` but remove `createdAt`, `updatedAt`, `season`, `popularity`
- Remove `GetFlowersParams` and `GetFlowersResponse` — no more flower browsing API

### 6. `models/RecommendModel.ets` (109 → ~55 lines)

**Current:** SceneType, GenerateRecommendationParams, BouquetScheme, FlowerItem, RecommendationResponse, OrderInfo, OrderListResponse, CreateOrderParams, UpdateOrderStatusParams, FeedbackInfo, SubmitFeedbackParams
**Target:** SceneType, GenerateRecommendationParams, BouquetScheme, FlowerItem, RecommendationResponse, CreateOrderParams

Changes:
- Keep `SceneType` as-is
- Simplify `GenerateRecommendationParams` — remove `recipientId`, `stylePreference`, `specialRequirements`. Keep `scene`, `budget`
- Keep `BouquetScheme` as-is (core data structure)
- Keep `FlowerItem` as-is
- Keep `RecommendationResponse` as-is
- Keep `CreateOrderParams` but simplify — remove `recommendation_id`, `selected_plan_index`, `delivery_time`
- Remove `OrderInfo`, `OrderListResponse`, `UpdateOrderStatusParams`, `FeedbackInfo`, `SubmitFeedbackParams`

### 7. `services/ApiService.ets` (130 → ~55 lines)

**Current:** 12 API methods across auth, flowers, recipients, recommendations, orders, feedback
**Target:** 3 API methods — generateRecommendation, createOrder, getFlowers (for homepage hot picks if kept)

Changes:
- Remove `login()`, `register()` — no auth
- Remove `getRecipients()`, `createRecipient()` — no recipient management
- Remove `getRecommendationHistory()` — no history
- Remove `getOrders()`, `getOrderDetail()`, `updateOrderStatus()`, `cancelOrder()` — no order management
- Remove `submitFeedback()`, `getFeedbackHistory()` — no feedback
- Keep `generateRecommendation()` — core feature
- Keep `createOrder()` — core feature
- Keep `getFlowers()` — optional, for HomePage if we keep hot picks
- Remove `LoginParams`, `LoginResponse`, `RegisterParams`, `RegisterResponse` imports

### 8. `services/HttpUtil.ets` (172 → ~120 lines)

**Current:** Full HTTP utility with token management, auth headers
**Target:** Simplified HTTP utility without auth

Changes:
- Remove `getToken()`, `saveToken()`, `clearToken()` — no auth
- Remove `preferences` import
- Remove `TOKEN_KEY` import
- Remove auth header logic from `request()` method (`needAuth` parameter)
- Simplify `request()` — remove 401 handling
- Keep `get()`, `post()`, `put()`, `delete()` methods but remove `needAuth` parameter

### 9. `utils/Constants.ets` (57 → ~30 lines)

**Current:** BASE_URL, pagination, token keys, timeout, banner interval, scene types/icons/names, order status map
**Target:** BASE_URL, timeout, scene types/icons/names only

Changes:
- Remove `DEFAULT_PAGE_SIZE`, `DEFAULT_PAGE` — no pagination
- Remove `TOKEN_KEY`, `USER_INFO_KEY` — no auth
- Remove `BANNER_INTERVAL` — no banner
- Remove `ORDER_STATUS_MAP` — no order tracking
- Keep `BASE_URL`, `HTTP_TIMEOUT`
- Keep `SCENE_TYPES`, `SCENE_ICONS`, `SCENE_NAMES`

### 10. `components/SceneSelector.ets` (73 → ~70 lines)

**Current:** Grid of 6 scenes with emoji icons
**Target:** Same, minor cleanup

Changes:
- Minor: remove any unused imports if FlowerModel was imported indirectly
- Essentially keep as-is — this component is core to the app

---

## Files to CREATE

**None.** The 14-file target is achieved by keeping 14 existing files and deleting 13.

---

## Execution Order

### Phase 1: Delete non-essential files (safe, no dependencies break yet)
1. Delete `pages/MinePage.ets`
2. Delete `pages/RecipientProfile.ets`
3. Delete `pages/PaymentPage.ets`
4. Delete `pages/FlowerLibrary.ets`
5. Delete `pages/OrderDetailPage.ets`
6. Delete `pages/OrderListPage.ets`
7. Delete `pages/LoginPage.ets`
8. Delete `pages/CartPage.ets`
9. Delete `pages/OrderConfirmPage.ets`
10. Delete `components/FlowerCard.ets`
11. Delete `components/StepIndicator.ets`
12. Delete `models/UserModel.ets`
13. Delete `store/CartStore.ets`

### Phase 2: Trim models and services
14. Modify `models/FlowerModel.ets` — trim enums and interface
15. Modify `models/RecommendModel.ets` — remove order/feedback types
16. Modify `utils/Constants.ets` — remove unused constants
17. Modify `services/HttpUtil.ets` — remove auth logic
18. Modify `services/ApiService.ets` — trim to 3 core methods

### Phase 3: Rebuild pages
19. Modify `pages/Index.ets` — reduce to 2 tabs
20. Modify `pages/HomePage.ets` — strip to scene selector + CTA
21. Modify `pages/RecommendPage.ets` — reduce to 3-step wizard
22. Modify `pages/ResultPage.ets` — add inline order form

### Phase 4: Verify
23. Verify all imports resolve (no dangling references to deleted files)
24. Verify `module.json5` pages list matches remaining pages
25. Verify no unused state/methods remain

---

## Expected Final State

| Metric | Before | After |
|--------|--------|-------|
| Total .ets files | 27 | 14 |
| Total lines (approx) | ~6,500 | ~2,500 |
| Pages | 13 | 4 (Index, HomePage, RecommendPage, ResultPage) |
| Components | 5 | 2 (BouquetCard, CommonButton) + SceneSelector inline |
| Models | 3 | 2 (FlowerModel, RecommendModel) |
| Services | 2 | 2 (ApiService, HttpUtil) |
| Store | 1 | 0 |
| Utils | 1 | 1 (Constants) |

### Final File List (14 files)

```
entry/src/main/ets/
├── common/
│   └── Theme.ets                    (63 lines, unchanged)
├── components/
│   ├── BouquetCard.ets              (78 lines, unchanged)
│   └── CommonButton.ets             (120 lines, unchanged)
├── entryability/
│   └── EntryAbility.ets             (45 lines, unchanged)
├── models/
│   ├── FlowerModel.ets              (35 lines, trimmed)
│   └── RecommendModel.ets           (55 lines, trimmed)
├── pages/
│   ├── Index.ets                    (55 lines, simplified)
│   ├── HomePage.ets                 (120 lines, simplified)
│   ├── RecommendPage.ets            (300 lines, simplified)
│   └── ResultPage.ets               (250 lines, with inline order)
├── services/
│   ├── ApiService.ets               (55 lines, trimmed)
│   └── HttpUtil.ets                 (120 lines, simplified)
└── utils/
    └── Constants.ets                (30 lines, trimmed)
```

---

## The Musk Test

After reconstruction, every file answers: **"Does this help the user pick and buy flowers?"**

- `Theme.ets` → Yes. Consistent UI.
- `BouquetCard.ets` → Yes. Shows the recommendation.
- `CommonButton.ets` → Yes. User interaction.
- `SceneSelector.ets` (in HomePage) → Yes. Entry point for recommendation.
- `RecommendPage.ets` → Yes. Gathers context for recommendation.
- `ResultPage.ets` → Yes. Shows options + enables ordering.
- `FlowerModel.ets` → Yes. Data structure for flower meanings.
- `RecommendModel.ets` → Yes. Data structure for recommendations.
- `ApiService.ets` → Yes. Connects to backend.
- `HttpUtil.ets` → Yes. HTTP transport.
- `Constants.ets` → Yes. Shared config.
- `EntryAbility.ets` → Yes. App lifecycle (required by HarmonyOS).
- `Index.ets` → Yes. Navigation shell (required by HarmonyOS).
- `HomePage.ets` → Yes. First screen user sees.

**Zero waste. Every line serves the core problem.**
