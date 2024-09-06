# fruit_catch_game

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


lib/
│
├── main.dart                  // アプリのエントリーポイント
├── models/                    // データモデルを管理するディレクトリ
│   └── fruit.dart             // 果物のデータモデル
├── screens/                   // 各画面（スクリーン）を管理するディレクトリ
│   └── fruit_catch_game.dart  // ゲームのメイン画面
├── widgets/                   // 再利用可能なウィジェット
│   └── fruit_widget.dart      // 果物のウィジェット
└── utils/                     // ユーティリティ関数やヘルパー関数
    └── game_utils.dart        // ゲームのユーティリティ関数（重力計算など）
