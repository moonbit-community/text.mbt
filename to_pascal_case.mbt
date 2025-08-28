///|
/// Convert string to PascalCase format
/// 
/// PascalCase format characteristics:
/// - First letter of each word is capitalized
/// - Other letters are lowercase
/// - No separators between words

///|
/// Convert string to PascalCase format
/// 
/// * `input` - The string to convert
/// + Returns the converted PascalCase format string
/// 
/// # Examples
/// ```
/// let _ = to_pascal_case("deno is awesome") // "DenoIsAwesome"
/// let _ = to_pascal_case("hello_world") // "HelloWorld"
/// let _ = to_pascal_case("htmlElement") // "HtmlElement"
/// ```
pub fn to_pascal_case(input : String) -> String {
  let trimmed : String = input.trim(" ").to_string()
  if trimmed.length() == 0 {
    return ""
  }
  let words = split_to_words(trimmed)
  let mut result = ""
  for i = 0; i < words.length(); i = i + 1 {
    result = result + capitalize_word(words[i])
  }
  result
}

///|
/// Tests
test "to_pascal_case" {
  assert_eq(to_pascal_case("deno is awesome"), "DenoIsAwesome")
  assert_eq(to_pascal_case("hello_world"), "HelloWorld")
  assert_eq(to_pascal_case("htmlElement"), "HtmlElement")
  assert_eq(to_pascal_case("  spaces  "), "Spaces")
  assert_eq(to_pascal_case(""), "")
  assert_eq(to_pascal_case("single"), "Single")
  assert_eq(to_pascal_case("UPPER"), "Upper")
  assert_eq(to_pascal_case("test123code"), "Test123Code")
}
