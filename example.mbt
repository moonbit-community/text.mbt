///|
/// MoonBit Text 库测试示例
/// 使用 inspect test 验证各种文本处理功能

///|
/// 测试：字符串格式转换
test "string_conversion_tests" {
  let original = "hello_world_example"

  // 测试各种格式转换
  inspect(to_camel_case(original), content="helloWorldExample")
  inspect(to_kebab_case(original), content="hello-world-example")
  inspect(to_pascal_case(original), content="HelloWorldExample")
  inspect(to_snake_case(original), content="hello_world_example")

  // 测试空字符串
  inspect(to_camel_case(""), content="")
  inspect(to_kebab_case(""), content="")
  inspect(to_pascal_case(""), content="")
  inspect(to_snake_case(""), content="")

  // 测试单个单词
  inspect(to_camel_case("hello"), content="hello")
  inspect(to_pascal_case("hello"), content="Hello")
}

///|
/// 测试：复杂字符串转换
test "complex_conversion_tests" {
  let complex = "XMLHttpRequest"

  // 测试单词分割
  let words = split_to_words(complex)
  inspect(
    words,
    content=(
      #|["XML", "Http", "Request"]
    ),
  )

  // 测试转换结果
  inspect(to_camel_case(complex), content="xmlHttpRequest")
  inspect(to_kebab_case(complex), content="xml-http-request")
  inspect(to_pascal_case(complex), content="XmlHttpRequest")
  inspect(to_snake_case(complex), content="xml_http_request")

  // 测试其他复杂情况
  inspect(to_camel_case("API_Version_2"), content="apiVersion2")
  inspect(to_snake_case("getUserInfo"), content="get_user_info")
}

///|
/// 测试：字符串距离计算
test "string_distance_tests" {
  // 测试基本距离计算
  inspect(levenshtein_distance("hello", "hallo"), content="1")
  inspect(levenshtein_distance("kitten", "sitting"), content="3")
  inspect(levenshtein_distance("algorithm", "altruistic"), content="6")
  inspect(levenshtein_distance("", "abc"), content="3")
  inspect(levenshtein_distance("same", "same"), content="0")

  // 测试边界情况
  inspect(levenshtein_distance("", ""), content="0")
  inspect(levenshtein_distance("a", ""), content="1")
  inspect(levenshtein_distance("", "b"), content="1")
  inspect(levenshtein_distance("a", "a"), content="0")
  inspect(levenshtein_distance("a", "b"), content="1")
}

///|
/// 测试：相似度比较和排序
test "similarity_sorting_tests" {
  let words = ["help", "hello", "world", "test", "hi", "heap", "heart"]
  let target = "hep"
  let sorted = sort_by_similarity(words, target, None)

  // 验证排序结果（最相似的应该在前面）
  inspect(sorted[0], content="help") // 距离为1
  inspect(sorted[1], content="heap") // 距离为2

  // 验证完整排序（可能的顺序）
  inspect(sorted.length(), content="7")

  // 测试空数组
  let empty_words : Array[String] = []
  let empty_sorted = sort_by_similarity(empty_words, target, None)
  inspect(
    empty_sorted,
    content=(
      #|[]
    ),
  )
}

///|
/// 测试：最接近字符串查找
test "closest_string_tests" {
  let candidates = ["length", "size", "width", "height", "help", "depth"]

  // 测试单个最接近字符串查找
  inspect(closest_string_simple("hep", candidates), content="help")
  inspect(closest_string_simple("len", candidates), content="length")
  inspect(closest_string_simple("siz", candidates), content="size")
  inspect(closest_string_simple("heigh", candidates), content="height")

  // 测试查找多个最接近的字符串
  let query = "hep"
  let top3 = closest_strings(query, candidates, 3, None)
  inspect(top3[0], content="help")
  inspect(top3.length(), content="3")

  // 测试大小写不敏感
  let mixed_case = ["Help", "HELLO", "world"]
  inspect(closest_string_simple("help", mixed_case), content="Help")

  // 测试区分大小写选项
  let opts = case_sensitive_closest_string_options()
  let case_sensitive_result = closest_string("Help", mixed_case, Some(opts))
  inspect(case_sensitive_result, content="Help")
}

///|
/// 测试：实际应用场景
test "real_world_usage_tests" {
  // 1. API 命名转换测试
  let api_functions = ["getUserProfile", "createNewPost", "deleteOldFiles"]
  inspect(to_snake_case(api_functions[0]), content="get_user_profile")
  inspect(to_kebab_case(api_functions[0]), content="get-user-profile")
  inspect(to_snake_case(api_functions[1]), content="create_new_post")
  inspect(to_kebab_case(api_functions[1]), content="create-new-post")
  inspect(to_snake_case(api_functions[2]), content="delete_old_files")
  inspect(to_kebab_case(api_functions[2]), content="delete-old-files")

  // 2. 配置文件字段转换测试
  let config_fields = ["database_url", "max_connections", "timeout_seconds"]
  inspect(to_camel_case(config_fields[0]), content="databaseUrl")
  inspect(to_pascal_case(config_fields[0]), content="DatabaseUrl")
  inspect(to_camel_case(config_fields[1]), content="maxConnections")
  inspect(to_pascal_case(config_fields[1]), content="MaxConnections")
  inspect(to_camel_case(config_fields[2]), content="timeoutSeconds")
  inspect(to_pascal_case(config_fields[2]), content="TimeoutSeconds")

  // 3. 文件名相似度匹配（拼写错误修正）测试
  let files = ["index.html", "main.css", "app.js", "readme.txt", "config.json"]
  let typos = ["inde.html", "main.cs", "ap.js", "readm.txt"]
  inspect(closest_string_simple(typos[0], files), content="index.html")
  inspect(closest_string_simple(typos[1], files), content="main.css")
  inspect(closest_string_simple(typos[2], files), content="app.js")
  inspect(closest_string_simple(typos[3], files), content="readme.txt")
}

///|
/// 测试：边界条件和错误处理
test "edge_cases_and_error_handling" {
  // 测试空字符串输入
  inspect(to_camel_case("   "), content="")
  inspect(to_snake_case("   "), content="")

  // 测试单字符
  inspect(to_camel_case("a"), content="a")
  inspect(to_pascal_case("a"), content="A")
  inspect(to_kebab_case("A"), content="a")

  // 测试数字和特殊字符
  inspect(to_camel_case("test123code"), content="test123Code")
  inspect(to_snake_case("test-123-code"), content="test_123_code")

  // 测试已经是目标格式的字符串
  inspect(to_camel_case("alreadyCamelCase"), content="alreadyCamelCase")
  inspect(to_snake_case("already_snake_case"), content="already_snake_case")
  inspect(to_kebab_case("already-kebab-case"), content="already-kebab-case")
  inspect(to_pascal_case("AlreadyPascalCase"), content="AlreadyPascalCase")
}

///|
/// 测试：性能相关的边界情况
test "performance_edge_cases" {
  // 测试长字符串
  let long_string = "this_is_a_very_long_string_with_many_words_to_test_performance"
  inspect(
    to_camel_case(long_string),
    content="thisIsAVeryLongStringWithManyWordsToTestPerformance",
  )

  // 测试重复模式
  let repeated = "test_test_test"
  inspect(to_camel_case(repeated), content="testTestTest")
  inspect(to_pascal_case(repeated), content="TestTestTest")

  // 测试相同长度的字符串距离
  inspect(levenshtein_distance("abcd", "efgh"), content="4")
  inspect(levenshtein_distance("abcd", "abcd"), content="0")
  inspect(levenshtein_distance("abcd", "abce"), content="1")
}
