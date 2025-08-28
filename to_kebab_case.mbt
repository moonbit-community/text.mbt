///|
/// 将字符串转换为短横线命名格式 (kebab-case)
/// 
/// 短横线命名格式的特点是：
/// - 所有字母都是小写
/// - 单词之间用短横线 (-) 分隔

///|
/// 将字符串转换为短横线命名格式
/// 
/// @param input 要转换的字符串
/// @returns 转换后的短横线命名格式字符串
/// 
/// # 示例
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
/// 测试
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
