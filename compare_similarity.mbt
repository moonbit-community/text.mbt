///|
/// String similarity comparison functionality
/// 
/// Provides similarity comparison functionality based on string distance algorithms
/// Uses Levenshtein distance algorithm by default

///|
/// Similarity comparison options
pub struct CompareSimilarityOptions {
  /// Whether to be case sensitive
  /// Default value: false
  case_sensitive : Bool
  /// Custom comparison function
  /// Parameters: (a, b) -> distance between two strings
  /// Default value: levenshtein_distance
  compare_fn : (String, String) -> Int
}

///|
/// Create default similarity comparison options
pub fn default_compare_similarity_options() -> CompareSimilarityOptions {
  CompareSimilarityOptions::{
    case_sensitive: false,
    compare_fn: levenshtein_distance,
  }
}

///|
/// Create case-sensitive similarity comparison options
pub fn case_sensitive_compare_similarity_options() -> CompareSimilarityOptions {
  CompareSimilarityOptions::{
    case_sensitive: true,
    compare_fn: levenshtein_distance,
  }
}

///|
/// Get string similarity comparison function
/// 
/// Generate a comparator function to determine which of two strings is more similar to a given string
/// Uses Levenshtein distance algorithm by default to calculate distance between words
/// 
/// * `given_word` - The string for measuring distance
/// * `options` - Comparison options
/// + Returns a comparator function that returns negative if a is more similar than b, positive if b is more similar, 0 if same
/// 
/// # Examples
/// Most similar words will be sorted at the front of the array
/// ```
/// let words = ["hi", "hello", "help"]
/// let sorted_words = sort_by_similarity(words, "hep", None)
/// // sorted_words will be ["help", "hi", "hello"]
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
/// Simplified version using default options
pub fn compare_similarity_simple(
  given_word : String,
) -> (String, String) -> Int {
  compare_similarity(given_word, None)
}

///|
/// Sort string array by similarity
/// 
/// * `words` - The string array to sort
/// * `given_word` - The reference string for similarity comparison
/// * `options` - Comparison options
/// + Returns a new array sorted by similarity (higher similarity first)
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

  // Simple insertion sort
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
/// Tests
test "compare_similarity_basic" {
  let cmp = compare_similarity_simple("hep")

  // "help" should be more similar to "hep" than "hello"
  assert_true(cmp("help", "hello") < 0)

  // "hi" should be more similar to "hep" than "hello"
  assert_true(cmp("hi", "hello") < 0)

  // Same strings should have distance 0
  assert_eq(cmp("test", "test"), 0)
}

///|
test "compare_similarity_case_sensitive" {
  let opts = case_sensitive_compare_similarity_options()
  let cmp = compare_similarity("Test", Some(opts))

  // When case sensitive, "Test" should be more similar to "Test" than "test"
  assert_true(cmp("Test", "test") < 0)
}

///|
test "sort_by_similarity" {
  let words = ["hi", "hello", "help"]
  let sorted = sort_by_similarity(words, "hep", None)

  // "help" should be most similar
  assert_eq(sorted[0], "help")

  // Original array should not be modified
  assert_eq(words, ["hi", "hello", "help"])
}

///|
/// Helper function: assert boolean value is true
fn assert_true(value : Bool) -> Unit {
  if not(value) {
    abort("Expected true, got false")
  }
}
