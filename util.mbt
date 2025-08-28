///|
/// String utility functions for handling word splitting and case conversion

///|
/// Split string into word array
/// Supports recognition of the following patterns:
/// - Words starting with uppercase letters (e.g., Apple)
/// - Acronyms (e.g., URL, ID)
/// - Lowercase words (e.g., apple)
/// - Numbers (e.g., 123)
pub fn split_to_words(input : String) -> Array[String] {
  let words = []
  let chars = input.to_array()
  let len = chars.length()
  let mut i = 0
  while i < len {
    let mut current_word = ""

    // Skip non-alphanumeric characters
    while i < len && not(is_alphanumeric(chars[i])) {
      i = i + 1
    }
    if i >= len {
      break
    }

    // Collect current word
    if is_uppercase(chars[i]) {
      // Handle case where it starts with uppercase letter
      current_word = current_word + chars[i].to_string()
      i = i + 1

      // Continue collecting uppercase letters (handle acronyms like HTML)
      while i < len && is_uppercase(chars[i]) {
        current_word = current_word + chars[i].to_string()
        i = i + 1
      }

      // If followed by lowercase letters, the last uppercase letter is the start of the next word
      if i < len && is_lowercase(chars[i]) && current_word.length() > 1 {
        // Leave the last uppercase letter for the next word
        let last_char = current_word.to_array()[current_word.length() - 1]
        current_word = current_word.substring(
          start=0,
          end=current_word.length() - 1,
        )
        words.push(current_word)

        // Start new word
        current_word = last_char.to_string()
        while i < len && is_lowercase(chars[i]) {
          current_word = current_word + chars[i].to_string()
          i = i + 1
        }
      } else {
        // Continue collecting lowercase letters
        while i < len && is_lowercase(chars[i]) {
          current_word = current_word + chars[i].to_string()
          i = i + 1
        }
      }
    } else if is_lowercase(chars[i]) {
      // Handle case where it starts with lowercase letter
      while i < len && is_lowercase(chars[i]) {
        current_word = current_word + chars[i].to_string()
        i = i + 1
      }
    } else if is_digit(chars[i]) {
      // Handle numbers
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
/// Check if character is alphanumeric
fn is_alphanumeric(ch : Char) -> Bool {
  let code = ch.to_int()
  // A-Z: 65-90, a-z: 97-122, 0-9: 48-57
  (code >= 65 && code <= 90) ||
  (code >= 97 && code <= 122) ||
  (code >= 48 && code <= 57)
}

///|
/// Check if it's an uppercase letter
fn is_uppercase(ch : Char) -> Bool {
  let code = ch.to_int()
  code >= 65 && code <= 90
}

///|
/// Check if it's a lowercase letter
fn is_lowercase(ch : Char) -> Bool {
  let code = ch.to_int()
  code >= 97 && code <= 122
}

///|
/// Check if it's a digit
fn is_digit(ch : Char) -> Bool {
  let code = ch.to_int()
  code >= 48 && code <= 57
}

///|
/// Capitalize the first letter of a word, make the rest lowercase
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
/// Convert character to uppercase
fn to_uppercase_char(ch : Char) -> Char {
  let code = ch.to_int()
  if code >= 97 && code <= 122 { // a-z
    (code - 32).unsafe_to_char() // Convert to A-Z
  } else {
    ch
  }
}

///|
/// Convert character to lowercase
fn to_lowercase_char(ch : Char) -> Char {
  let code = ch.to_int()
  if code >= 65 && code <= 90 { // A-Z
    (code + 32).unsafe_to_char() // Convert to a-z
  } else {
    ch
  }
}

///|
/// Convert string to lowercase
pub fn to_lowercase_string(s : String) -> String {
  let chars = s.to_array()
  let mut result = ""
  for i = 0; i < chars.length(); i = i + 1 {
    result = result + to_lowercase_char(chars[i]).to_string()
  }
  result
}

///|
/// Test functions
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
