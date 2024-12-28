cmake_minimum_required(VERSION 3.19)

project(simple_without_sqlite3_ohos)

include(FetchContent)

# 与 https://github.com/SageMik/simple-native-android/blob/v1.0.2/simple-native-android/src/main/cpp/CMakeLists.txt 同步
FetchContent_Declare(simple_native
    GIT_REPOSITORY https://github.com/SageMik/sqlite3_simple
    GIT_TAG Nv1.0.3
)
FetchContent_MakeAvailable(simple_native)