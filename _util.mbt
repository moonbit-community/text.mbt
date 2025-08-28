///|
/// 字符串工具函数，用于处理单词分割和大小写转换

///|
/// 将字符串分割成单词数组
/// 支持以下模式的识别：
/// - 大写字母开头的单词（如 Apple）
/// - 首字母缩略词（如 URL, ID）
/// - 小写单词（如 apple）
/// - 数字（如 123）
pub fn split_to_words(input : String) -> Array[String] {
  let words = []
  let chars = input.to_array()
  let len = chars.length()
  let mut i = 0
  while i < len {
    let mut current_word = ""

    // 跳过非字母数字字符
    while i < len && not(is_alphanumeric(chars[i])) {
      i = i + 1
    }
    if i >= len {
      break
    }

    // 收集当前单词
    if is_uppercase(chars[i]) {
      // 处理大写字母开头的情况
      current_word = current_word + chars[i].to_string()
      i = i + 1

      // 继续收集大写字母（处理缩略词如 HTML）
      while i < len && is_uppercase(chars[i]) {
        current_word = current_word + chars[i].to_string()
        i = i + 1
      }

      // 如果后面跟着小写字母，说明最后一个大写字母是下个单词的开头
      if i < len && is_lowercase(chars[i]) && current_word.length() > 1 {
        // 将最后一个大写字母留给下个单词
        let last_char = current_word.to_array()[current_word.length() - 1]
        current_word = current_word.substring(
          start=0,
          end=current_word.length() - 1,
        )
        words.push(current_word)

        // 开始新单词
        current_word = last_char.to_string()
        while i < len && is_lowercase(chars[i]) {
          current_word = current_word + chars[i].to_string()
          i = i + 1
        }
      } else {
        // 继续收集小写字母
        while i < len && is_lowercase(chars[i]) {
          current_word = current_word + chars[i].to_string()
          i = i + 1
        }
      }
    } else if is_lowercase(chars[i]) {
      // 处理小写字母开头的情况
      while i < len && is_lowercase(chars[i]) {
        current_word = current_word + chars[i].to_string()
        i = i + 1
      }
    } else if is_digit(chars[i]) {
      // 处理数字
      while i < len && is_digit(chars[i]) {
        current_word = current_word + chars[i].to_string()
        i = i + 1
      }
    }
    if current_word.length() > 0 {
      words.push(current_word)
    }
  }
  words
}

///|
/// 检查字符是否为字母或数字
fn is_alphanumeric(ch : Char) -> Bool {
  let code = ch.to_int()
  // A-Z: 65-90, a-z: 97-122, 0-9: 48-57
  (code >= 65 && code <= 90) ||
  (code >= 97 && code <= 122) ||
  (code >= 48 && code <= 57)
}

///|
/// 检查是否为大写字母
fn is_uppercase(ch : Char) -> Bool {
  let code = ch.to_int()
  code >= 65 && code <= 90
}

///|
/// 检查是否为小写字母
fn is_lowercase(ch : Char) -> Bool {
  let code = ch.to_int()
  code >= 97 && code <= 122
}

///|
/// 检查是否为数字
fn is_digit(ch : Char) -> Bool {
  let code = ch.to_int()
  code >= 48 && code <= 57
}

///|
/// 将单词的首字母大写，其余字母小写
pub fn capitalize_word(word : String) -> String {
  if word.length() == 0 {
    return word
  }
  let chars = word.to_array()
  let first_char = chars[0]
  let first_upper = to_uppercase_char(first_char)
  let mut result = first_upper.to_string()
  for i = 1; i < chars.length(); i = i + 1 {
    result = result + to_lowercase_char(chars[i]).to_string()
  }
  result
}

///|
/// 将字符转换为大写
fn to_uppercase_char(ch : Char) -> Char {
  let code = ch.to_int()
  if code >= 97 && code <= 122 { // a-z
    (code - 32).unsafe_to_char() // 转换为 A-Z
  } else {
    ch
  }
}

///|
/// 将字符转换为小写
fn to_lowercase_char(ch : Char) -> Char {
  let code = ch.to_int()
  if code >= 65 && code <= 90 { // A-Z
    (code + 32).unsafe_to_char() // 转换为 a-z
  } else {
    ch
  }
}

///|
/// 将字符串转换为小写
pub fn to_lowercase_string(s : String) -> String {
  let chars = s.to_array()
  let mut result = ""
  for i = 0; i < chars.length(); i = i + 1 {
    result = result + to_lowercase_char(chars[i]).to_string()
  }
  result
}

///|
/// 测试函数
test "split_to_words" {
  let words1 = split_to_words("helloWorld")
  assert_eq(words1, ["hello", "World"])
  let words2 = split_to_words("HTMLElement")
  assert_eq(words2, ["HTML", "Element"])
  let words3 = split_to_words("deno_is_awesome")
  assert_eq(words3, ["deno", "is", "awesome"])
  let words4 = split_to_words("test123code")
  assert_eq(words4, ["test", "123", "code"])
}

///|
test "capitalize_word" {
  assert_eq(capitalize_word("hello"), "Hello")
  assert_eq(capitalize_word("WORLD"), "World")
  assert_eq(capitalize_word(""), "")
}

///|
test "to_lowercase_string" {
  assert_eq(to_lowercase_string("Hello"), "hello")
  assert_eq(to_lowercase_string("WORLD"), "world")
  assert_eq(to_lowercase_string("Test123"), "test123")
}
