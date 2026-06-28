<div align="center">

# Expense Tracker Pro

**A production-grade, offline-first Flutter expense tracker.**

[![CI](https://github.com/nikhilrpadhiyar/expense_tracker_pro/actions/workflows/ci.yml/badge.svg)](https://github.com/nikhilrpadhiyar/expense_tracker_pro/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Flutter](https://img.shields.io/badge/Flutter-3.11.5+-02569B?logo=flutter)](https://flutter.dev)
[![GetX](https://img.shields.io/badge/GetX-4.6.6-blueviolet)](https://pub.dev/packages/get)

Track expenses and income, set category budgets, visualise spending with charts, export reports to CSV/PDF, and sync everything to Firebase — all with full offline support via Hive.

</div>

---

## Features

| Category | Details |
|---|---|
| Offline-first | All data stored locally in Hive; works without internet |
| Cloud Sync | Unsynced records batch-uploaded to Firestore on demand |
| Authentication | Firebase Auth (email/password) |
| Expense Tracking | Add, edit, delete income and expense records with 10 categories |
| Budget Goals | Set monthly limits per category with real-time progress bars |
| Budget Alerts | Local notifications when 80% of any budget is consumed |
| Charts | Pie chart (category breakdown), bar chart (top spending), summary cards |
| Reports | Monthly income vs expense summary with savings rate |
| Export | Export to CSV or PDF and share via native share sheet |
| Dark Mode | Material 3, light/dark mode, persisted preference |
| Monthly Notifications | Scheduled reminder on the 1st of each month |

---

## Architecture

Feature-first Clean Architecture with GetX:

```
UI (Page)
   ↓
Controller       (GetX — reactive state, user actions)
   ↓
Use Case         (domain — single-responsibility business rules)
   ↓
Repository       (domain interface / data layer implementation)
   ↓
LocalDataSource  (Hive — offline-first)
RemoteDataSource (Firestore — cloud sync)
```

### Folder Structure

```
lib/
├── core/
│   ├── constants/       AppConstants, AppSpacing, ExpenseCategories
│   ├── error/           Exceptions and Failures (typed per layer)
│   ├── services/        NotificationService, ExportService
│   ├── storage/         HiveStorage wrapper
│   ├── theme/           AppTheme, AppColors, AppTextStyles
│   └── utils/           CurrencyFormatter, AppDateUtils, Validators, Extensions
│
├── features/
│   ├── auth/            Firebase Auth — login, register, splash
│   ├── expense/
│   │   ├── data/        ExpenseModel (Hive), Local/Remote DataSources, RepositoryImpl
│   │   ├── domain/      ExpenseEntity, ExpenseRepository, 4 UseCases
│   │   └── presentation/ ExpenseController, ExpenseBinding, AddExpensePage
│   ├── budget/
│   │   ├── data/        BudgetModel (Hive), LocalDataSource, RepositoryImpl
│   │   ├── domain/      BudgetEntity, BudgetRepository
│   │   └── presentation/ BudgetController, BudgetListPage, AddBudgetPage
│   ├── dashboard/       DashboardController, DashboardPage, BalanceCard, SpendingChart
│   ├── reports/         ReportsController, ReportsPage (charts + category breakdown)
│   └── settings/        SettingsController, SettingsPage
│
├── routes/              AppRoutes, AppPages
├── shared/widgets/      AppButton, AppTextField, AppLogo, AppEmptyWidget, SectionHeader
└── main.dart
```

---

## Getting Started

### Prerequisites

- Flutter SDK >= 3.11.5
- Firebase project with Email/Password Auth and Firestore enabled

### 1. Clone and install

```bash
git clone https://github.com/your-username/expense_tracker_pro.git
cd expense_tracker_pro
flutter pub get
```

### 2. Configure environment

```bash
cp .env.example .env
```

### 3. Configure Firebase

```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

### 4. Run

```bash
flutter run
```

---

## Data Model

### ExpenseModel (Hive typeId: 0)

| Field | Type | Description |
|---|---|---|
| `id` | String | UUID v4 |
| `title` | String | Transaction title |
| `amount` | double | Positive value |
| `categoryId` | String | One of 10 predefined categories |
| `date` | DateTime | Transaction date |
| `typeIndex` | int | 0 = expense, 1 = income |
| `note` | String? | Optional note |
| `isSynced` | bool | Cloud sync status |

### BudgetModel (Hive typeId: 1)

| Field | Type | Description |
|---|---|---|
| `id` | String | UUID v4 |
| `categoryId` | String | Budget target category |
| `limit` | double | Monthly spending limit |
| `month` | int | 1–12 |
| `year` | int | e.g. 2024 |

---

## Expense Categories

Food & Dining, Transport, Shopping, Health, Entertainment, Bills & Utilities, Education, Travel, Groceries, Other.

---

## Running Tests

```bash
flutter test
flutter test --coverage
```

Tests in `test/unit/`:
- `validators_test.dart` — email and amount validation
- `expense_entity_test.dart` — entity logic, copyWith, equality
- `currency_formatter_test.dart` — format and compact formatting

---

## Export

| Format | Content |
|---|---|
| CSV | Date, Title, Category, Amount, Note |
| PDF | Summary header with totals + full transaction table |

Both are shared via the native OS share sheet.

---

## Tech Stack

| Package | Purpose |
|---|---|
| get | State, DI, routing |
| hive_flutter | Offline-first local database |
| firebase_auth | Authentication |
| cloud_firestore | Cloud sync |
| fl_chart | Pie and bar charts |
| pdf / printing | PDF report generation |
| csv | CSV export |
| share_plus | Native share sheet |
| flutter_local_notifications | Budget alerts and monthly reminders |
| dartz | Functional Either error handling |
| uuid | Unique ID generation |

---

## License

MIT License. See [LICENSE](LICENSE).

## Getting Started (Flutter default)

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
