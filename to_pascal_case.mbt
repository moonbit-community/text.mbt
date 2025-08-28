///|
/// 将字符串转换为帕斯卡命名格式 (PascalCase)
/// 
/// 帕斯卡命名格式的特点是：
/// - 每个单词的首字母都大写
/// - 其余字母小写
/// - 单词之间没有分隔符

///|
/// 将字符串转换为帕斯卡命名格式
/// 
/// @param input 要转换的字符串
/// @returns 转换后的帕斯卡命名格式字符串
/// 
/// # 示例
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
/// 测试
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
