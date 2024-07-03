String getFirstTwoWords(String sentence) {
  // Split the sentence into words
  List<String> words = sentence.split(' ');

  // Check if the sentence has at least two words
  if (words.length >= 2) {
    // Join the first two words
    return '${words[0]} ${words[1]}';
  } else {
    // If the sentence has less than two words, return the original sentence
    return sentence;
  }
}
