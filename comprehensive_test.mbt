///|
/// Comprehensive tests - Verify all module functionalities

///|
test "comprehensive_string_conversion_test" {
  // Test various string conversion functions
  let input = "hello_world_example"
  let camel = to_camel_case(input)
  @debug.assert_eq(camel, "helloWorldExample")
  let kebab = to_kebab_case(input)
  @debug.assert_eq(kebab, "hello-world-example")
  let pascal = to_pascal_case(input)
  @debug.assert_eq(pascal, "HelloWorldExample")
  let snake = to_snake_case(input)
  @debug.assert_eq(snake, "hello_world_example")
}

///|
test "comprehensive_mixed_case_conversion_test" {
  // Test complex mixed case input
  let input = "XMLHttpRequest"
  let camel = to_camel_case(input)
  @debug.assert_eq(camel, "xmlHttpRequest")
  let kebab = to_kebab_case(input)
  @debug.assert_eq(kebab, "xml-http-request")
  let pascal = to_pascal_case(input)
  @debug.assert_eq(pascal, "XmlHttpRequest")
  let snake = to_snake_case(input)
  @debug.assert_eq(snake, "xml_http_request")
}

///|
test "comprehensive_levenshtein_distance_test" {
  // Test Levenshtein distance algorithm
  @debug.assert_eq(levenshtein_distance("", ""), 0)
  @debug.assert_eq(levenshtein_distance("hello", "hello"), 0)
  @debug.assert_eq(levenshtein_distance("hello", "hallo"), 1)
  @debug.assert_eq(levenshtein_distance("kitten", "sitting"), 3)
  @debug.assert_eq(levenshtein_distance("abc", "def"), 3)

  // Test longer strings
  @debug.assert_eq(levenshtein_distance("algorithm", "altruistic"), 6)
}

///|
test "comprehensive_similarity_comparison_test" {
  // Test similarity comparison functionality
  let words = ["help", "hello", "world", "test", "hi"]
  let sorted = sort_by_similarity(words, "hep", None)

  // "help" should be most similar
  @debug.assert_eq(sorted[0], "help")

  // Test case sensitivity
  let words_case = ["Hello", "HELLO", "hello"]
  let opts = case_sensitive_compare_similarity_options()
  let sorted_case = sort_by_similarity(words_case, "Hello", Some(opts))
  @debug.assert_eq(sorted_case[0], "Hello")
}

///|
test "comprehensive_closest_string_test" {
  // Test closest string search
  let candidates = ["length", "size", "width", "height", "help"]
  let closest = closest_string_simple("hep", candidates)
  @debug.assert_eq(closest, "help")

  // Test multiple closest strings
  let multiple = closest_strings("hep", candidates, 3, None)
  @debug.assert_eq(multiple[0], "help")
  @debug.assert_eq(multiple.length(), 3)

  // Test case sensitivity
  let case_candidates = ["Test", "test", "TEST", "best"]
  let case_opts = case_sensitive_closest_string_options()
  let case_closest = closest_string("Test", case_candidates, Some(case_opts))
  @debug.assert_eq(case_closest, "Test")
}

///|
test "comprehensive_word_splitting_test" {
  // Test word splitting functionality
  let words1 = split_to_words("camelCaseExample")
  @debug.assert_eq(words1, ["camel", "Case", "Example"])
  let words2 = split_to_words("XMLHttpRequest")
  @debug.assert_eq(words2, ["XML", "Http", "Request"])
  let words3 = split_to_words("test123code")
  @debug.assert_eq(words3, ["test", "123", "code"])
  let words4 = split_to_words("simple")
  @debug.assert_eq(words4, ["simple"])
}

///|
test "comprehensive_edge_cases_test" {
  // Test edge cases

  // Empty string
  @debug.assert_eq(to_camel_case(""), "")
  @debug.assert_eq(to_kebab_case(""), "")
  @debug.assert_eq(to_pascal_case(""), "")
  @debug.assert_eq(to_snake_case(""), "")

  // Single character
  @debug.assert_eq(to_camel_case("a"), "a")
  @debug.assert_eq(to_kebab_case("A"), "a")
  @debug.assert_eq(to_pascal_case("a"), "A")
  @debug.assert_eq(to_snake_case("A"), "a")

  // Only spaces
  @debug.assert_eq(to_camel_case("   "), "")
  @debug.assert_eq(to_kebab_case("   "), "")

  // Word splitting edge cases
  @debug.assert_eq(split_to_words(""), [])
  @debug.assert_eq(split_to_words("   "), [])
  @debug.assert_eq(split_to_words("ABC"), ["ABC"])
}

///|
test "comprehensive_real_world_examples_test" {
  // Test real world use cases

  // API naming conversion
  let api_name = "getUserProfile"
  @debug.assert_eq(to_snake_case(api_name), "get_user_profile")
  @debug.assert_eq(to_kebab_case(api_name), "get-user-profile")

  // Database field conversion
  let db_field = "created_at"
  @debug.assert_eq(to_camel_case(db_field), "createdAt")
  @debug.assert_eq(to_pascal_case(db_field), "CreatedAt")

  // CSS class name conversion
  let css_class = "btn-primary-large"
  @debug.assert_eq(to_camel_case(css_class), "btnPrimaryLarge")
  @debug.assert_eq(to_pascal_case(css_class), "BtnPrimaryLarge")

  // File name similarity matching
  let files = ["index.html", "main.css", "app.js", "readme.txt", "help.md"]
  let similar_to_help = closest_string_simple("halp", files)
  @debug.assert_eq(similar_to_help, "help.md")
}
