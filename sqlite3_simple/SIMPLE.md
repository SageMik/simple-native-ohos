# [Simple](https://github.com/wangfenjin/simple) 家族

[Simple (支持中文和拼音的 SQLite fts5 全文搜索扩展)](https://github.com/wangfenjin/simple) 相关实现、相关库的具体说明。

## [sqlite3_simple](https://github.com/SageMik/sqlite3_simple) / Flutter 库

[![Pub Package](https://img.shields.io/pub/v/sqlite3_simple?style=for-the-badge&logo=flutter)](https://pub.dev/packages/sqlite3_simple)

基于 [Simple](https://github.com/wangfenjin/simple) 和 [sqlite3.dart](https://github.com/simolus3/sqlite3.dart) 的 Flutter 库，支持 ~~HarmonyOS~~、Android、iOS、Windows、MacOS、Linux 平台。

### 仓库中的 [simple-native 分支](https://github.com/SageMik/sqlite3_simple/tree/simple-native) / 原生库编译代码

[![simple-native](https://img.shields.io/github/actions/workflow/status/SageMik/sqlite3_simple/simple.yml?branch=simple-native&label=simple-native&style=for-the-badge&logo=github&logoColor=white)](https://github.com/SageMik/sqlite3_simple/tree/simple-native)

该分支用于编译和维护用于主分支的 Simple 原生库，以支持 **[sqlite3_simple](https://github.com/SageMik/sqlite3_simple) / Flutter 库** 在不同平台的实现。除 **HarmonyOS NEXT** 和 **Android** 外，**其他平台均通过 Github Action 进行持续集成 (CI)** 。

#### [simple-native-android](https://github.com/SageMik/simple-native-android) / Android 原生库编译代码
[![Maven Central](https://img.shields.io/maven-central/v/io.github.sagemik/simple-native-android?label=Maven%20Central&style=flat-square)](https://central.sonatype.com/artifact/io.github.sagemik/simple-native-android)

#### [simple-native-ohos](https://github.com/SageMik/simple-ohos/tree/main/simple_native_ohos) / HarmonyOS NEXT 原生库编译代码

[![OpenHarmony 三方库中心仓](https://img.shields.io/badge/v1.0.2-007ec6?label=OpenHarmony%20%E4%B8%89%E6%96%B9%E5%BA%93%E4%B8%AD%E5%BF%83%E4%BB%93&style=flat-square)](https://ohpm.openharmony.cn/#/cn/detail/simple-native-ohos)

## [**simple-ohos**](https://github.com/SageMik/simple-ohos) / HarmonyOS NEXT 鸿蒙库

基于 [Simple](https://github.com/wangfenjin/simple) 的 HarmonyOS NEXT 鸿蒙库，用于关系型数据库的中文和拼音全文搜索。由 [**simple-native-ohos**](#simple-native-ohos--harmonyos-next-原生库编译代码) 提供原生库支持。

## [sqlite3-ohos.dart](https://github.com/SageMik/sqlite3-ohos.dart) / [sqlite.dart](https://github.com/simolus3/sqlite3.dart) 的 HarmonyOS NEXT 适配版

[sqlite.dart](https://github.com/simolus3/sqlite3.dart) 的分支版本之一，基于 **[鸿蒙突击队 Flutter 3.22.0](https://gitee.com/harmonycommando_flutter/flutter/tree/oh-3.22.0)** 对 HarmonyOS NEXT 进行了适配，提供了在鸿蒙平台上通过 Flutter 访问数据库的功能。本意是为 **[sqlite3_simple](https://github.com/SageMik/sqlite3_simple) / Flutter 库** 提供鸿蒙适配，但目前出现 [崩溃问题](https://github.com/SageMik/sqlite3-ohos.dart/issues/1)，暂不可用。

### [sqlite3-native-library](https://github.com/SageMik/sqlite3.arkts/tree/main/sqlite3_native_library) / SQLite3 的 HarmonyOS 原生库

为 **[sqlite3-ohos.dart](https://github.com/SageMik/sqlite3-ohos.dart) / [sqlite.dart](https://github.com/simolus3/sqlite3.dart) 的 HarmonyOS NEXT 适配版** 提供原生库支持。