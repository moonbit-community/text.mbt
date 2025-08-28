///|
/// Levenshtein distance algorithm implementation
/// 
/// Calculate the Levenshtein distance (edit distance) between two strings
/// This is the minimum number of edit operations (insert, delete, replace) between two strings

///|
/// Calculate the Levenshtein distance between two strings
/// 
/// Levenshtein distance is the minimum number of edit operations (insert, delete, replace) between two strings
/// Note: This function has O(m * n) complexity, where m and n are the lengths of the two strings
/// It is recommended to limit input length and validate input when accepting arbitrary input
/// 
/// * `str1` - The first string
/// * `str2` - The second string
/// + Returns the Levenshtein distance between the two strings
/// 
/// # Examples
/// ```
/// let _ = levenshtein_distance("aa", "bb") // returns 2
/// let _ = levenshtein_distance("hello", "hallo") // returns 1
/// ```
pub fn levenshtein_distance(str1 : String, str2 : String) -> Int {
  let t = str1.to_array()
  let p = str2.to_array()

  // Use the shorter string as p to optimize space complexity
  if t.length() < p.length() {
    return levenshtein_distance_impl(p, t)
  } else {
    return levenshtein_distance_impl(t, p)
  }
}

///|
/// Concrete implementation of Levenshtein distance
/// Uses dynamic programming algorithm
fn levenshtein_distance_impl(t : Array[Char], p : Array[Char]) -> Int {
  let n = t.length()
  let m = p.length()
  if m == 0 {
    return n
  }

  // For shorter strings, use simplified implementation
  if m <= 32 {
    return myers32(t, p)
  } else {
    return classic_levenshtein(t, p)
  }
}

///|
/// Myers algorithm implementation (suitable for short strings)
/// This is a bit-vector based Myers algorithm implementation
fn myers32(t : Array[Char], p : Array[Char]) -> Int {
  let n = t.length()
  let m = p.length()

  // Initialize peq array
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

    // Set horizontal increment of first row to +1
    ph = (ph << 1) | 1
    mh = mh << 1
    pv = mh | (xv | ph).lnot()
    mv = ph & xv
  }

  // Clean up peq array
  for i = 0; i < m; i = i + 1 {
    peq[p[i].to_int()] = 0
  }
  score
}

///|
/// Classic dynamic programming Levenshtein distance algorithm
fn classic_levenshtein(t : Array[Char], p : Array[Char]) -> Int {
  let n = t.length()
  let m = p.length()

  // Create distance matrix, only two rows are sufficient
  let mut prev_row = Array::make(m + 1, 0)
  let mut curr_row = Array::make(m + 1, 0)

  // Initialize first row
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

    // Swap rows
    let temp = prev_row
    prev_row = curr_row
    curr_row = temp
  }
  prev_row[m]
}

///|
/// Calculate the minimum of three numbers
fn min3(a : Int, b : Int, c : Int) -> Int {
  let temp = if a < b { a } else { b }
  if temp < c {
    temp
  } else {
    c
  }
}

///|
/// Tests
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
