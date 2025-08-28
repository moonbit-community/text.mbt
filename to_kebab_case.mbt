///|
/// Convert string to kebab-case format
/// 
/// Kebab case format characteristics:
/// - All letters are lowercase
/// - Words are separated by hyphens (-)

///|
/// Convert string to kebab-case format
/// 
/// * `input` - The string to convert
/// + Returns the converted kebab-case format string
/// 
/// # Examples
/// ```
/// let _ = to_kebab_case("deno is awesome") // "deno-is-awesome"
/// let _ = to_kebab_case("helloWorld") // "hello-world"
/// let _ = to_kebab_case("HTMLElement") // "html-element"
/// ```
pub fn to_kebab_case(input : String) -> String {
  let trimmed : String = input.trim(" ").to_string()
  if trimmed.length() == 0 {
    return ""
  }
  let words = split_to_words(trimmed)
  let mut result = ""
  for i = 0; i < words.length(); i = i + 1 {
    if i > 0 {
      result = result + "-"
    }
    result = result + to_lowercase_string(words[i])
  }
  result
}

///|
/// Tests
test "to_kebab_case" {
  assert_eq(to_kebab_case("deno is awesome"), "deno-is-awesome")
  assert_eq(to_kebab_case("helloWorld"), "hello-world")
  assert_eq(to_kebab_case("HTMLElement"), "html-element")
  assert_eq(to_kebab_case("  spaces  "), "spaces")
  assert_eq(to_kebab_case(""), "")
  assert_eq(to_kebab_case("single"), "single")
  assert_eq(to_kebab_case("UPPER"), "upper")
  assert_eq(to_kebab_case("test123code"), "test-123-code")
}
