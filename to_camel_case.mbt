///|
/// 将字符串转换为驼峰命名格式 (camelCase)
/// 
/// 驼峰命名格式的特点是：
/// - 第一个单词全小写
/// - 后续单词首字母大写，其余小写
/// - 单词之间没有分隔符

///|
/// 将字符串转换为驼峰命名格式
/// 
/// @param input 要转换的字符串
/// @returns 转换后的驼峰命名格式字符串
/// 
/// # 示例
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
/// 测试
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
