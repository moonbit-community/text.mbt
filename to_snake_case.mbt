///|
/// 将字符串转换为下划线命名格式 (snake_case)
/// 
/// 下划线命名格式的特点是：
/// - 所有字母都是小写
/// - 单词之间用下划线 (_) 分隔

///|
/// 将字符串转换为下划线命名格式
/// 
/// @param input 要转换的字符串
/// @returns 转换后的下划线命名格式字符串
/// 
/// # 示例
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
/// 测试
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
