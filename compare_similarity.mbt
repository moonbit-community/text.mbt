///|
/// 字符串相似度比较功能
/// 
/// 提供基于字符串距离算法的相似度比较功能
/// 默认使用 Levenshtein 距离算法

///|
/// 相似度比较选项
pub struct CompareSimilarityOptions {
  /// 是否区分大小写
  /// 默认值: false
  case_sensitive : Bool
  /// 自定义比较函数
  /// 参数: (a, b) -> 两个字符串之间的距离
  /// 默认值: levenshtein_distance
  compare_fn : (String, String) -> Int
}

///|
/// 创建默认的相似度比较选项
pub fn default_compare_similarity_options() -> CompareSimilarityOptions {
  CompareSimilarityOptions::{
    case_sensitive: false,
    compare_fn: levenshtein_distance,
  }
}

///|
/// 创建区分大小写的相似度比较选项
pub fn case_sensitive_compare_similarity_options() -> CompareSimilarityOptions {
  CompareSimilarityOptions::{
    case_sensitive: true,
    compare_fn: levenshtein_distance,
  }
}

///|
/// 获取字符串相似度比较函数
/// 
/// 生成一个比较器函数，用于确定两个字符串中哪个与给定字符串更相似
/// 默认使用 Levenshtein 距离算法计算单词之间的距离
/// 
/// @param given_word 用于测量距离的字符串
/// @param options 比较选项
/// @returns 比较器函数，如果 a 比 b 更相似返回负数，如果 b 更相似返回正数，相同返回 0
/// 
/// # 示例
/// 最相似的单词将排在数组的前面
/// ```
/// let words = ["hi", "hello", "help"]
/// let sorted_words = sort_by_similarity(words, "hep", None)
/// // sorted_words 将是 ["help", "hi", "hello"]
/// ```
pub fn compare_similarity(
  given_word : String,
  options : CompareSimilarityOptions?,
) -> (String, String) -> Int {
  let opts = match options {
    Some(opts) => opts
    None => default_compare_similarity_options()
  }
  let compare_fn = opts.compare_fn
  if opts.case_sensitive {
    fn(a : String, b : String) -> Int {
      compare_fn(given_word, a) - compare_fn(given_word, b)
    }
  } else {
    let given_lower = to_lowercase_string(given_word)
    fn(a : String, b : String) -> Int {
      let a_lower = to_lowercase_string(a)
      let b_lower = to_lowercase_string(b)
      compare_fn(given_lower, a_lower) - compare_fn(given_lower, b_lower)
    }
  }
}

///|
/// 使用默认选项的简化版本
pub fn compare_similarity_simple(
  given_word : String,
) -> (String, String) -> Int {
  compare_similarity(given_word, None)
}

///|
/// 按相似度对字符串数组进行排序
/// 
/// @param words 要排序的字符串数组
/// @param given_word 用于比较相似度的基准字符串
/// @param options 比较选项
/// @returns 按相似度排序后的新数组（相似度高的在前面）
pub fn sort_by_similarity(
  words : Array[String],
  given_word : String,
  options : CompareSimilarityOptions?,
) -> Array[String] {
  let comparator = compare_similarity(given_word, options)
  let sorted_words = Array::new()
  for word in words {
    sorted_words.push(word)
  }

  // 简单的插入排序
  for i = 1; i < sorted_words.length(); i = i + 1 {
    let key = sorted_words[i]
    let mut j = i - 1
    while j >= 0 && comparator(sorted_words[j], key) > 0 {
      sorted_words[j + 1] = sorted_words[j]
      j = j - 1
    }
    sorted_words[j + 1] = key
  }
  sorted_words
}

///|
/// 测试
test "compare_similarity_basic" {
  let cmp = compare_similarity_simple("hep")

  // "help" 应该比 "hello" 更相似于 "hep"
  assert_true(cmp("help", "hello") < 0)

  // "hi" 应该比 "hello" 更相似于 "hep"  
  assert_true(cmp("hi", "hello") < 0)

  // 相同字符串应该距离为 0
  assert_eq(cmp("test", "test"), 0)
}

///|
test "compare_similarity_case_sensitive" {
  let opts = case_sensitive_compare_similarity_options()
  let cmp = compare_similarity("Test", Some(opts))

  // 区分大小写时，"Test" 应该比 "test" 更相似于 "Test"
  assert_true(cmp("Test", "test") < 0)
}

///|
test "sort_by_similarity" {
  let words = ["hi", "hello", "help"]
  let sorted = sort_by_similarity(words, "hep", None)

  // "help" 应该是最相似的
  assert_eq(sorted[0], "help")

  // 原数组不应该被修改
  assert_eq(words, ["hi", "hello", "help"])
}

///|
/// 辅助函数：断言布尔值为真
fn assert_true(value : Bool) -> Unit {
  if not(value) {
    abort("Expected true, got false")
  }
}
