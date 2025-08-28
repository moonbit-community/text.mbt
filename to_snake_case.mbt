///|
/// Convert string to snake_case format
/// 
/// Snake case format characteristics:
/// - All letters are lowercase
/// - Words are separated by underscores (_)

///|
/// Convert string to snake_case format
/// 
/// * `input` - The string to convert
/// + Returns the converted snake_case format string
/// 
/// # Examples
/// ```
/// let _ = to_snake_case("deno is awesome") // "deno_is_awesome"
/// let _ = to_snake_case("helloWorld") // "hello_world"
/// let _ = to_snake_case("HTMLElement") // "html_element"
/// ```
pub fn to_snake_case(input : String) -> String {
  let trimmed : String = input.trim(" ").to_string()
  if trimmed.length() == 0 {
    return ""
  }
  let words = split_to_words(trimmed)
  let mut result = ""
  for i = 0; i < words.length(); i = i + 1 {
    if i > 0 {
      result = result + "_"
    }
    result = result + to_lowercase_string(words[i])
  }
  result
}

///|
/// Tests
test "to_snake_case" {
  assert_eq(to_snake_case("deno is awesome"), "deno_is_awesome")
  assert_eq(to_snake_case("helloWorld"), "hello_world")
  assert_eq(to_snake_case("HTMLElement"), "html_element")
  assert_eq(to_snake_case("  spaces  "), "spaces")
  assert_eq(to_snake_case(""), "")
  assert_eq(to_snake_case("single"), "single")
  assert_eq(to_snake_case("UPPER"), "upper")
  assert_eq(to_snake_case("test123code"), "test_123_code")
}
