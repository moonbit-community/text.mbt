///|
/// Levenshtein 距离算法实现
/// 
/// 计算两个字符串之间的 Levenshtein 距离（编辑距离）
/// 这是两个字符串之间的最小编辑操作数（插入、删除、替换）

///|
/// 计算两个字符串之间的 Levenshtein 距离
/// 
/// Levenshtein 距离是两个字符串之间的最小编辑操作数（插入、删除、替换）
/// 注意：此函数的复杂度是 O(m * n)，其中 m 和 n 是两个字符串的长度
/// 建议限制输入长度并在接受任意输入时验证输入
/// 
/// @param str1 第一个字符串
/// @param str2 第二个字符串  
/// @returns 两个字符串之间的 Levenshtein 距离
/// 
/// # 示例
/// ```
/// let _ = levenshtein_distance("aa", "bb") // returns 2
/// let _ = levenshtein_distance("hello", "hallo") // returns 1
/// ```
pub fn levenshtein_distance(str1 : String, str2 : String) -> Int {
  let t = str1.to_array()
  let p = str2.to_array()

  // 使用较短的字符串作为 p，以优化空间复杂度
  if t.length() < p.length() {
    return levenshtein_distance_impl(p, t)
  } else {
    return levenshtein_distance_impl(t, p)
  }
}

///|
/// Levenshtein 距离的具体实现
/// 使用动态规划算法
fn levenshtein_distance_impl(t : Array[Char], p : Array[Char]) -> Int {
  let n = t.length()
  let m = p.length()
  if m == 0 {
    return n
  }

  // 对于较短的字符串，使用简化的实现
  if m <= 32 {
    return myers32(t, p)
  } else {
    return classic_levenshtein(t, p)
  }
}

///|
/// Myers 算法实现（适用于短字符串）
/// 这是基于位向量的 Myers 算法实现
fn myers32(t : Array[Char], p : Array[Char]) -> Int {
  let n = t.length()
  let m = p.length()

  // 初始化 peq 数组
  let peq = Array::make(0x110000, 0)
  for i = 0; i < m; i = i + 1 {
    let code = p[i].to_int()
    peq[code] = peq[code] | (1 << i)
  }
  let last = m - 1
  let mut pv = -1
  let mut mv = 0
  let mut score = m
  for j = 0; j < n; j = j + 1 {
    let eq = peq[t[j].to_int()]
    let xv = eq | mv
    let xh = (((eq & pv) + pv) ^ pv) | eq
    let mut ph = mv | (xh | pv).lnot()
    let mut mh = pv & xh
    score = score + ((ph >> last) & 1) - ((mh >> last) & 1)

    // 设置第一行的水平增量为 +1
    ph = (ph << 1) | 1
    mh = mh << 1
    pv = mh | (xv | ph).lnot()
    mv = ph & xv
  }

  // 清理 peq 数组
  for i = 0; i < m; i = i + 1 {
    peq[p[i].to_int()] = 0
  }
  score
}

///|
/// 经典的动态规划 Levenshtein 距离算法
fn classic_levenshtein(t : Array[Char], p : Array[Char]) -> Int {
  let n = t.length()
  let m = p.length()

  // 创建距离矩阵，只需要两行就足够了
  let mut prev_row = Array::make(m + 1, 0)
  let mut curr_row = Array::make(m + 1, 0)

  // 初始化第一行
  for j = 0; j <= m; j = j + 1 {
    prev_row[j] = j
  }
  for i = 1; i <= n; i = i + 1 {
    curr_row[0] = i
    for j = 1; j <= m; j = j + 1 {
      let cost = if t[i - 1] == p[j - 1] { 0 } else { 1 }
      let delete_cost = prev_row[j] + 1
      let insert_cost = curr_row[j - 1] + 1
      let substitute_cost = prev_row[j - 1] + cost
      curr_row[j] = min3(delete_cost, insert_cost, substitute_cost)
    }

    // 交换行
    let temp = prev_row
    prev_row = curr_row
    curr_row = temp
  }
  prev_row[m]
}

///|
/// 计算三个数的最小值
fn min3(a : Int, b : Int, c : Int) -> Int {
  let temp = if a < b { a } else { b }
  if temp < c {
    temp
  } else {
    c
  }
}

///|
/// 测试
test "levenshtein_distance_basic" {
  assert_eq(levenshtein_distance("", ""), 0)
  assert_eq(levenshtein_distance("", "abc"), 3)
  assert_eq(levenshtein_distance("abc", ""), 3)
  assert_eq(levenshtein_distance("abc", "abc"), 0)
}

///|
test "levenshtein_distance_examples" {
  assert_eq(levenshtein_distance("aa", "bb"), 2)
  assert_eq(levenshtein_distance("hello", "hallo"), 1)
  assert_eq(levenshtein_distance("kitten", "sitting"), 3)
  assert_eq(levenshtein_distance("saturday", "sunday"), 3)
}

///|
test "levenshtein_distance_edge_cases" {
  assert_eq(levenshtein_distance("a", "a"), 0)
  assert_eq(levenshtein_distance("a", "b"), 1)
  assert_eq(levenshtein_distance("ab", "ba"), 2)
  assert_eq(levenshtein_distance("abc", "def"), 3)
}
