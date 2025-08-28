///|
/// MoonBit Text 库使用示例
/// 展示各种文本处理功能

///|
/// 示例：字符串格式转换
fn example_string_conversion() -> Unit {
  println("=== 字符串格式转换示例 ===")
  let original = "hello_world_example"
  println("原始字符串: \{original}")
  let camel = to_camel_case(original)
  println("驼峰命名: \{camel}")
  let kebab = to_kebab_case(original)
  println("短横线命名: \{kebab}")
  let pascal = to_pascal_case(original)
  println("帕斯卡命名: \{pascal}")
  let snake = to_snake_case(original)
  println("下划线命名: \{snake}")
  println("")
}

///|
/// 示例：复杂字符串转换
fn example_complex_conversion() -> Unit {
  println("=== 复杂字符串转换示例 ===")
  let complex = "XMLHttpRequest"
  println("原始字符串: \{complex}")
  let words = split_to_words(complex)
  let mut word_str = "分割后的单词: "
  for i = 0; i < words.length(); i = i + 1 {
    if i > 0 {
      word_str = word_str + ", "
    }
    word_str = word_str + "\"\{words[i]}\""
  }
  println(word_str)
  println("转换结果:")
  println("  驼峰命名: \{to_camel_case(complex)}")
  println("  短横线命名: \{to_kebab_case(complex)}")
  println("  帕斯卡命名: \{to_pascal_case(complex)}")
  println("  下划线命名: \{to_snake_case(complex)}")
  println("")
}

///|
/// 示例：字符串距离计算
fn example_string_distance() -> Unit {
  println("=== 字符串距离计算示例 ===")
  let examples = [
    ("hello", "hallo"),
    ("kitten", "sitting"),
    ("algorithm", "altruistic"),
    ("", "abc"),
    ("same", "same"),
  ]
  for pair in examples {
    let (str1, str2) = pair
    let distance = levenshtein_distance(str1, str2)
    println("距离(\"\{str1}\", \"\{str2}\") = \{distance}")
  }
  println("")
}

///|
/// 示例：相似度比较和排序
fn example_similarity_sorting() -> Unit {
  println("=== 相似度比较和排序示例 ===")
  let words = ["help", "hello", "world", "test", "hi", "heap", "heart"]
  let target = "hep"
  println("候选单词: \{words}")
  println("目标单词: \"\{target}\"")
  let sorted = sort_by_similarity(words, target, None)
  println("按相似度排序:")
  for i = 0; i < sorted.length(); i = i + 1 {
    let distance = levenshtein_distance(target, sorted[i])
    println("  \{i + 1}. \"\{sorted[i]}\" (距离: \{distance})")
  }
  println("")
}

///|
/// 示例：最接近字符串查找
fn example_closest_string() -> Unit {
  println("=== 最接近字符串查找示例 ===")
  let candidates = ["length", "size", "width", "height", "help", "depth"]
  let queries = ["hep", "len", "siz", "heigh"]
  println("候选字符串: \{candidates}")
  for query in queries {
    let closest = closest_string_simple(query, candidates)
    let distance = levenshtein_distance(query, closest)
    println(
      "查询 \"\{query}\" 的最接近匹配: \"\{closest}\" (距离: \{distance})",
    )
  }
  println("")

  // 查找多个最接近的字符串
  let query = "hep"
  let top3 = closest_strings(query, candidates, 3, None)
  println("查询 \"\{query}\" 的前3个最接近匹配:")
  for i = 0; i < top3.length(); i = i + 1 {
    let distance = levenshtein_distance(query, top3[i])
    println("  \{i + 1}. \"\{top3[i]}\" (距离: \{distance})")
  }
  println("")
}

///|
/// 示例：实际应用场景
fn example_real_world_usage() -> Unit {
  println("=== 实际应用场景示例 ===")

  // 1. API 命名转换
  println("1. API 命名转换:")
  let api_functions = ["getUserProfile", "createNewPost", "deleteOldFiles"]
  for func in api_functions {
    println("  \{func} -> \{to_snake_case(func)} (数据库风格)")
    println("  \{func} -> \{to_kebab_case(func)} (URL 风格)")
  }
  println("")

  // 2. 配置文件字段转换
  println("2. 配置文件字段转换:")
  let config_fields = ["database_url", "max_connections", "timeout_seconds"]
  for field in config_fields {
    println("  \{field} -> \{to_camel_case(field)} (JavaScript 风格)")
    println("  \{field} -> \{to_pascal_case(field)} (C# 风格)")
  }
  println("")

  // 3. 文件名相似度匹配（拼写错误修正）
  println("3. 文件名相似度匹配（拼写错误修正）:")
  let files = ["index.html", "main.css", "app.js", "readme.txt", "config.json"]
  let typos = ["inde.html", "main.cs", "ap.js", "readm.txt"]
  for typo in typos {
    let suggestion = closest_string_simple(typo, files)
    println("  输入错误: \"\{typo}\" -> 建议: \"\{suggestion}\"")
  }
  println("")
}

///|
/// 运行所有示例
fn run_examples() -> Unit {
  println("MoonBit Text 处理库功能演示")
  println("================================")
  println("")
  example_string_conversion()
  example_complex_conversion()
  example_string_distance()
  example_similarity_sorting()
  example_closest_string()
  example_real_world_usage()
  println("所有示例运行完成！")
}

///|
/// 测试示例函数
test "example_functions_work" {
  // 确保所有示例函数都能正常运行而不会崩溃
  example_string_conversion()
  example_complex_conversion()
  example_string_distance()
  example_similarity_sorting()
  example_closest_string()
  example_real_world_usage()
}
