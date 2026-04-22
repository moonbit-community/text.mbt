///|
test "debug split_to_words type" {
  let words = split_to_words("hello_world-test")
  let first_word : String = words[0] // This should work if words is Array[String]
  println("First word: " + first_word)
  println("Type check passed - words is Array[String]")
}
