///|
/// MoonBit Text library test examples
/// Use inspect test to verify various text processing functions

///|
/// Test: String format conversion
test "string_conversion_tests" {
  let original = "hello_world_example"

  // Test various format conversions
  inspect(to_camel_case(original), content="helloWorldExample")
  inspect(to_kebab_case(original), content="hello-world-example")
  inspect(to_pascal_case(original), content="HelloWorldExample")
  inspect(to_snake_case(original), content="hello_world_example")

  // Test empty string
  inspect(to_camel_case(""), content="")
  inspect(to_kebab_case(""), content="")
  inspect(to_pascal_case(""), content="")
  inspect(to_snake_case(""), content="")

  // Test single word
  inspect(to_camel_case("hello"), content="hello")
  inspect(to_pascal_case("hello"), content="Hello")
}

///|
/// Test: Complex string conversion
test "complex_conversion_tests" {
  let complex = "XMLHttpRequest"

  // Test word splitting
  let words = split_to_words(complex)
  inspect(
    words,
    content=(
      #|["XML", "Http", "Request"]
    ),
  )

  // Test conversion results
  inspect(to_camel_case(complex), content="xmlHttpRequest")
  inspect(to_kebab_case(complex), content="xml-http-request")
  inspect(to_pascal_case(complex), content="XmlHttpRequest")
  inspect(to_snake_case(complex), content="xml_http_request")

  // Test other complex cases
  inspect(to_camel_case("API_Version_2"), content="apiVersion2")
  inspect(to_snake_case("getUserInfo"), content="get_user_info")
}

///|
/// Test: String distance calculation
test "string_distance_tests" {
  // Test basic distance calculation
  inspect(levenshtein_distance("hello", "hallo"), content="1")
  inspect(levenshtein_distance("kitten", "sitting"), content="3")
  inspect(levenshtein_distance("algorithm", "altruistic"), content="6")
  inspect(levenshtein_distance("", "abc"), content="3")
  inspect(levenshtein_distance("same", "same"), content="0")

  // Test edge cases
  inspect(levenshtein_distance("", ""), content="0")
  inspect(levenshtein_distance("a", ""), content="1")
  inspect(levenshtein_distance("", "b"), content="1")
  inspect(levenshtein_distance("a", "a"), content="0")
  inspect(levenshtein_distance("a", "b"), content="1")
}

///|
/// Test: Similarity comparison and sorting
test "similarity_sorting_tests" {
  let words = ["help", "hello", "world", "test", "hi", "heap", "heart"]
  let target = "hep"
  let sorted = sort_by_similarity(words, target, None)

  // Verify sorting results (most similar should be first)
  inspect(sorted[0], content="help") // distance is 1
  inspect(sorted[1], content="heap") // distance is 2

  // Verify complete sorting (possible order)
  inspect(sorted.length(), content="7")

  // Test empty array
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
/// Test: Closest string search
test "closest_string_tests" {
  let candidates = ["length", "size", "width", "height", "help", "depth"]

  // Test single closest string search
  inspect(closest_string_simple("hep", candidates), content="help")
  inspect(closest_string_simple("len", candidates), content="length")
  inspect(closest_string_simple("siz", candidates), content="size")
  inspect(closest_string_simple("heigh", candidates), content="height")

  // Test searching for multiple closest strings
  let query = "hep"
  let top3 = closest_strings(query, candidates, 3, None)
  inspect(top3[0], content="help")
  inspect(top3.length(), content="3")

  // Test case insensitive
  let mixed_case = ["Help", "HELLO", "world"]
  inspect(closest_string_simple("help", mixed_case), content="Help")

  // Test case sensitive option
  let opts = case_sensitive_closest_string_options()
  let case_sensitive_result = closest_string("Help", mixed_case, Some(opts))
  inspect(case_sensitive_result, content="Help")
}

///|
/// Test: Real world usage scenarios
test "real_world_usage_tests" {
  // 1. API naming conversion test
  let api_functions = ["getUserProfile", "createNewPost", "deleteOldFiles"]
  inspect(to_snake_case(api_functions[0]), content="get_user_profile")
  inspect(to_kebab_case(api_functions[0]), content="get-user-profile")
  inspect(to_snake_case(api_functions[1]), content="create_new_post")
  inspect(to_kebab_case(api_functions[1]), content="create-new-post")
  inspect(to_snake_case(api_functions[2]), content="delete_old_files")
  inspect(to_kebab_case(api_functions[2]), content="delete-old-files")

  // 2. Configuration field conversion test
  let config_fields = ["database_url", "max_connections", "timeout_seconds"]
  inspect(to_camel_case(config_fields[0]), content="databaseUrl")
  inspect(to_pascal_case(config_fields[0]), content="DatabaseUrl")
  inspect(to_camel_case(config_fields[1]), content="maxConnections")
  inspect(to_pascal_case(config_fields[1]), content="MaxConnections")
  inspect(to_camel_case(config_fields[2]), content="timeoutSeconds")
  inspect(to_pascal_case(config_fields[2]), content="TimeoutSeconds")

  // 3. File name similarity matching (typo correction) test
  let files = ["index.html", "main.css", "app.js", "readme.txt", "config.json"]
  let typos = ["inde.html", "main.cs", "ap.js", "readm.txt"]
  inspect(closest_string_simple(typos[0], files), content="index.html")
  inspect(closest_string_simple(typos[1], files), content="main.css")
  inspect(closest_string_simple(typos[2], files), content="app.js")
  inspect(closest_string_simple(typos[3], files), content="readme.txt")
}

///|
/// Test: Edge cases and error handling
test "edge_cases_and_error_handling" {
  // Test empty string input
  inspect(to_camel_case("   "), content="")
  inspect(to_snake_case("   "), content="")

  // Test single character
  inspect(to_camel_case("a"), content="a")
  inspect(to_pascal_case("a"), content="A")
  inspect(to_kebab_case("A"), content="a")

  // Test numbers and special characters
  inspect(to_camel_case("test123code"), content="test123Code")
  inspect(to_snake_case("test-123-code"), content="test_123_code")

  // Test strings already in target format
  inspect(to_camel_case("alreadyCamelCase"), content="alreadyCamelCase")
  inspect(to_snake_case("already_snake_case"), content="already_snake_case")
  inspect(to_kebab_case("already-kebab-case"), content="already-kebab-case")
  inspect(to_pascal_case("AlreadyPascalCase"), content="AlreadyPascalCase")
}

///|
/// Test: Performance-related edge cases
test "performance_edge_cases" {
  // Test long string
  let long_string = "this_is_a_very_long_string_with_many_words_to_test_performance"
  inspect(
    to_camel_case(long_string),
    content="thisIsAVeryLongStringWithManyWordsToTestPerformance",
  )

  // Test repeated patterns
  let repeated = "test_test_test"
  inspect(to_camel_case(repeated), content="testTestTest")
  inspect(to_pascal_case(repeated), content="TestTestTest")

  // Test distance of same-length strings
  inspect(levenshtein_distance("abcd", "efgh"), content="4")
  inspect(levenshtein_distance("abcd", "abcd"), content="0")
  inspect(levenshtein_distance("abcd", "abce"), content="1")
}
