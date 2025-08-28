# myfreess/text

A comprehensive MoonBit library for text processing, string manipulation, and fuzzy string matching. This library provides utilities for case conversions, string similarity calculations, and finding closest matches in string collections.

## Features

- **Case Conversion**: Convert strings to camelCase, PascalCase, snake_case, and kebab-case
- **String Similarity**: Calculate Levenshtein distance between strings
- **Fuzzy Matching**: Find closest matches from string arrays with customizable options
- **Sorting by Similarity**: Sort strings by their similarity to a target string
- **Word Processing**: Split strings into words and handle various text manipulations

## Installation

Add this package to your MoonBit project:

```bash
moon add myfreess/text
```

## API Reference

### Case Conversion Functions

#### `to_camel_case(String) -> String`

Converts a string to camelCase format where the first word is lowercase and subsequent words have their first letter capitalized.

```moonbit
test "camelCase conversion" {
  inspect(@text.to_camel_case("hello world"), content="helloWorld")
  inspect(@text.to_camel_case("deno_is_awesome"), content="denoIsAwesome")
  inspect(@text.to_camel_case("HTMLElement"), content="htmlElement")
}
```

#### `to_pascal_case(String) -> String`

Converts a string to PascalCase format where every word starts with a capital letter.

```moonbit
test "PascalCase conversion" {
  inspect(@text.to_pascal_case("hello world"), content="HelloWorld")
  inspect(@text.to_pascal_case("my_variable_name"), content="MyVariableName")
}
```

#### `to_snake_case(String) -> String`

Converts a string to snake_case format where words are separated by underscores and all lowercase.

```moonbit
test "snake_case conversion" {
  inspect(@text.to_snake_case("Hello World"), content="hello_world")
  inspect(@text.to_snake_case("XMLHttpRequest"), content="xml_http_request")
}
```

#### `to_kebab_case(String) -> String`

Converts a string to kebab-case format where words are separated by hyphens and all lowercase.

```moonbit
test "kebab-case conversion" {
  inspect(@text.to_kebab_case("Hello World"), content="hello-world")
  inspect(@text.to_kebab_case("backgroundColor"), content="background-color")
}
```

### String Similarity and Distance

#### `levenshtein_distance(String, String) -> Int`

Calculates the Levenshtein distance (edit distance) between two strings. This represents the minimum number of single-character edits (insertions, deletions, or substitutions) required to change one string into another.

```moonbit
test "Levenshtein distance calculation" {
  inspect(@text.levenshtein_distance("kitten", "sitting"), content="3")
  inspect(@text.levenshtein_distance("hello", "hallo"), content="1")
  inspect(@text.levenshtein_distance("", "abc"), content="3")
  inspect(@text.levenshtein_distance("same", "same"), content="0")
}
```

### Fuzzy String Matching

#### Configuration Types

**`ClosestStringOptions`**: Configuration for closest string matching
- `case_sensitive: Bool` - Whether matching should be case-sensitive
- `compare_fn: (String, String) -> Int` - Custom comparison function

**`CompareSimilarityOptions`**: Configuration for similarity comparison  
- `case_sensitive: Bool` - Whether comparison should be case-sensitive
- `compare_fn: (String, String) -> Int` - Custom comparison function

#### Option Creators

```moonbit
test "create matching options" {
  let default_opts = @text.default_closest_string_options()
  let case_opts = @text.case_sensitive_closest_string_options()
  
  let similarity_opts = @text.default_compare_similarity_options()
  let case_similarity_opts = @text.case_sensitive_compare_similarity_options()
}
```

#### `closest_string(String, Array[String], ClosestStringOptions?) -> String raise StringMatchingError`

Finds the most similar string from an array of candidates using the specified options.

```moonbit
test "find closest string" {
  let candidates = ["length", "size", "help", "world"]
  
  // Simple case - finds "help" as closest to "hep"
  let result = @text.closest_string_simple("hep", candidates)
  inspect(result, content="help")
  
  // With options
  let opts = @text.default_closest_string_options()
  let result2 = @text.closest_string("test", candidates, Some(opts))
  inspect(result2, content="size")
}
```

#### `closest_string_simple(String, Array[String]) -> String raise StringMatchingError`

Simplified version of `closest_string` using default options.

```moonbit
test "simple closest string matching" {
  let words = ["apple", "application", "apply", "apt"]
  let result = @text.closest_string_simple("app", words)
  inspect(result, content="apt")
}
```

#### `closest_strings(String, Array[String], Int, ClosestStringOptions?) -> Array[String]`

Returns multiple closest matches sorted by similarity.

```moonbit
test "multiple closest strings" {
  let candidates = ["help", "hello", "world", "test", "heap"]
  let top3 = @text.closest_strings("hep", candidates, 3, None)
  
  // Should return top 3 matches sorted by similarity
  inspect(top3.length(), content="3")
  inspect(top3[0], content="help")
}
```

### Similarity Comparison and Sorting

#### `compare_similarity(String, CompareSimilarityOptions?) -> (String, String) -> Int`

Creates a comparison function for measuring similarity between strings.

```moonbit
test "similarity comparison function" {
  let compare_fn = @text.compare_similarity("target", None)
  let distance1 = compare_fn("target", "test")
  let distance2 = compare_fn("target", "target")
  
  inspect(distance2, content="0") // exact match
}
```

#### `compare_similarity_simple(String) -> (String, String) -> Int`

Simplified version using default comparison options.

```moonbit
test "simple similarity comparison" {
  let compare_fn = @text.compare_similarity_simple("hello")
  let distance = compare_fn("hello", "hallo")
  inspect(distance, content="1")
}
```

#### `sort_by_similarity(Array[String], String, CompareSimilarityOptions?) -> Array[String]`

Sorts an array of strings by their similarity to a target string.

```moonbit
test "sort by similarity" {
  let words = ["world", "help", "hello", "test"]
  let sorted = @text.sort_by_similarity(words, "hep", None)
  
  // "help" should be first as it's most similar to "hep"
  inspect(sorted[0], content="help")
}
```

### Utility Functions

#### `split_to_words(String) -> Array[String]`

Splits a string into individual words, handling various separators and cases.

```moonbit
test "word splitting" {
  let words = @text.split_to_words("hello_world-test")
  inspect(words, content=["hello", "world", "test"])
  
  let camel_words = @text.split_to_words("camelCaseExample")
  inspect(camel_words, content=["camel", "Case", "Example"])
}
```

#### `capitalize_word(String) -> String`

Capitalizes the first letter of a word while making the rest lowercase.

```moonbit
test "word capitalization" {
  inspect(@text.capitalize_word("hello"), content="Hello")
  inspect(@text.capitalize_word("WORLD"), content="World")
  inspect(@text.capitalize_word("tEST"), content="Test")
}
```

#### `to_lowercase_string(String) -> String`

Converts a string to all lowercase letters.

```moonbit
test "lowercase conversion" {
  inspect(@text.to_lowercase_string("Hello World"), content="hello world")
  inspect(@text.to_lowercase_string("TEST123"), content="test123")
}
```

## Error Handling

The library defines a custom error type `StringMatchingError` for operations that may fail:

```moonbit
test "error handling" {
  let empty_array : Array[String] = []
  let result = try {
    @text.closest_string_simple("test", empty_array)
  } catch {
    @text.StringMatchingError(msg) => "Error: " + msg
  }
  
  inspect(result, content="Error: When using closest_string(), the possible_words array must contain at least one word")
}
```

## Performance Considerations

- The `levenshtein_distance` function has O(m × n) time complexity where m and n are string lengths
- For strings shorter than 32 characters, an optimized Myers algorithm is used
- For longer strings, the classic dynamic programming approach is employed
- Consider input validation for very long strings in production use

## Use Cases

### Command Line Tool Suggestions

```moonbit
test "CLI command suggestions" {
  let commands = ["install", "uninstall", "list", "search", "update"]
  let suggestion = @text.closest_string_simple("instal", commands)
  inspect(suggestion, content="install")
}
```

### API Method Name Matching

```moonbit
test "API method matching" {
  let methods = ["getUserById", "getUserByName", "getAllUsers", "createUser"]
  let closest = @text.closest_string_simple("getUser", methods)
  inspect(closest, content="getAllUsers")
}
```

### Variable Name Formatting

```moonbit
test "variable name formatting" {
  let api_name = "user profile data"
  
  inspect(@text.to_camel_case(api_name), content="userProfileData")
  inspect(@text.to_pascal_case(api_name), content="UserProfileData") 
  inspect(@text.to_snake_case(api_name), content="user_profile_data")
  inspect(@text.to_kebab_case(api_name), content="user-profile-data")
}
```

## License

This project is licensed under the MIT License.