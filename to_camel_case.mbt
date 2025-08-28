///|
/// Convert string to camelCase format
/// 
/// CamelCase format characteristics:
/// - First word is all lowercase
/// - Subsequent words have their first letter capitalized, rest lowercase
/// - No separators between words

///|
/// Convert string to camelCase format
/// 
/// * `input` - The string to convert
/// + Returns the converted camelCase format string
/// 
/// # Examples
/// ```
/// let _ = to_camel_case("deno is awesome") // "denoIsAwesome"
/// let _ = to_camel_case("hello_world") // "helloWorld"
/// let _ = to_camel_case("HTMLElement") // "htmlElement"
/// ```
pub fn to_camel_case(input : String) -> String {
  let trimmed : String = input.trim(" ").to_string()
  if trimmed.length() == 0 {
    return ""
  }
  let words = split_to_words(trimmed)
  if words.length() == 0 {
    return ""
  }
  let mut result = to_lowercase_string(words[0])
  for i = 1; i < words.length(); i = i + 1 {
    result = result + capitalize_word(words[i])
  }
  result
}

///|
/// Tests
test "to_camel_case" {
  assert_eq(to_camel_case("deno is awesome"), "denoIsAwesome")
  assert_eq(to_camel_case("hello_world"), "helloWorld")
  assert_eq(to_camel_case("HTMLElement"), "htmlElement")
  assert_eq(to_camel_case("  spaces  "), "spaces")
  assert_eq(to_camel_case(""), "")
  assert_eq(to_camel_case("single"), "single")
  assert_eq(to_camel_case("UPPER"), "upper")
  assert_eq(to_camel_case("test123code"), "test123Code")
}
