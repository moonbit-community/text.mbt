///|
/// 综合测试 - 验证所有模块功能

///|
test "comprehensive_string_conversion_test" {
  // 测试各种字符串转换功能
  let input = "hello_world_example"
  let camel = to_camel_case(input)
  assert_eq(camel, "helloWorldExample")
  let kebab = to_kebab_case(input)
  assert_eq(kebab, "hello-world-example")
  let pascal = to_pascal_case(input)
  assert_eq(pascal, "HelloWorldExample")
  let snake = to_snake_case(input)
  assert_eq(snake, "hello_world_example")
}

///|
test "comprehensive_mixed_case_conversion_test" {
  // 测试复杂的大小写混合输入
  let input = "XMLHttpRequest"
  let camel = to_camel_case(input)
  assert_eq(camel, "xmlHttpRequest")
  let kebab = to_kebab_case(input)
  assert_eq(kebab, "xml-http-request")
  let pascal = to_pascal_case(input)
  assert_eq(pascal, "XmlHttpRequest")
  let snake = to_snake_case(input)
  assert_eq(snake, "xml_http_request")
}

///|
test "comprehensive_levenshtein_distance_test" {
  // 测试 Levenshtein 距离算法
  assert_eq(levenshtein_distance("", ""), 0)
  assert_eq(levenshtein_distance("hello", "hello"), 0)
  assert_eq(levenshtein_distance("hello", "hallo"), 1)
  assert_eq(levenshtein_distance("kitten", "sitting"), 3)
  assert_eq(levenshtein_distance("abc", "def"), 3)

  // 测试较长字符串
  assert_eq(levenshtein_distance("algorithm", "altruistic"), 6)
}

///|
test "comprehensive_similarity_comparison_test" {
  // 测试相似度比较功能
  let words = ["help", "hello", "world", "test", "hi"]
  let sorted = sort_by_similarity(words, "hep", None)

  // "help" 应该是最相似的
  assert_eq(sorted[0], "help")

  // 测试区分大小写
  let words_case = ["Hello", "HELLO", "hello"]
  let opts = case_sensitive_compare_similarity_options()
  let sorted_case = sort_by_similarity(words_case, "Hello", Some(opts))
  assert_eq(sorted_case[0], "Hello")
}

///|
test "comprehensive_closest_string_test" {
  // 测试最接近字符串查找
  let candidates = ["length", "size", "width", "height", "help"]
  let closest = closest_string_simple("hep", candidates)
  assert_eq(closest, "help")

  // 测试多个最接近的字符串
  let multiple = closest_strings("hep", candidates, 3, None)
  assert_eq(multiple[0], "help")
  assert_eq(multiple.length(), 3)

  // 测试区分大小写
  let case_candidates = ["Test", "test", "TEST", "best"]
  let case_opts = case_sensitive_closest_string_options()
  let case_closest = closest_string("Test", case_candidates, Some(case_opts))
  assert_eq(case_closest, "Test")
}

///|
test "comprehensive_word_splitting_test" {
  // 测试单词分割功能
  let words1 = split_to_words("camelCaseExample")
  assert_eq(words1, ["camel", "Case", "Example"])
  let words2 = split_to_words("XMLHttpRequest")
  assert_eq(words2, ["XML", "Http", "Request"])
  let words3 = split_to_words("test123code")
  assert_eq(words3, ["test", "123", "code"])
  let words4 = split_to_words("simple")
  assert_eq(words4, ["simple"])
}

///|
test "comprehensive_edge_cases_test" {
  // 测试边界情况

  // 空字符串
  assert_eq(to_camel_case(""), "")
  assert_eq(to_kebab_case(""), "")
  assert_eq(to_pascal_case(""), "")
  assert_eq(to_snake_case(""), "")

  // 单字符
  assert_eq(to_camel_case("a"), "a")
  assert_eq(to_kebab_case("A"), "a")
  assert_eq(to_pascal_case("a"), "A")
  assert_eq(to_snake_case("A"), "a")

  // 只有空格
  assert_eq(to_camel_case("   "), "")
  assert_eq(to_kebab_case("   "), "")

  // 单词分割边界情况
  assert_eq(split_to_words(""), [])
  assert_eq(split_to_words("   "), [])
  assert_eq(split_to_words("ABC"), ["ABC"])
}

///|
test "comprehensive_real_world_examples_test" {
  // 测试真实世界的用例

  // API 命名转换
  let api_name = "getUserProfile"
  assert_eq(to_snake_case(api_name), "get_user_profile")
  assert_eq(to_kebab_case(api_name), "get-user-profile")

  // 数据库字段转换
  let db_field = "created_at"
  assert_eq(to_camel_case(db_field), "createdAt")
  assert_eq(to_pascal_case(db_field), "CreatedAt")

  // CSS 类名转换
  let css_class = "btn-primary-large"
  assert_eq(to_camel_case(css_class), "btnPrimaryLarge")
  assert_eq(to_pascal_case(css_class), "BtnPrimaryLarge")

  // 文件名相似度匹配
  let files = ["index.html", "main.css", "app.js", "readme.txt", "help.md"]
  let similar_to_help = closest_string_simple("halp", files)
  assert_eq(similar_to_help, "help.md")
}
