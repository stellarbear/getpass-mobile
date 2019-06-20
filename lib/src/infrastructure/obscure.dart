String obscure(String input, int count) {
  if (count == 8) {
    return input;
  }

  final scopedCount = count > input.length ? input.length : count;
  final padding = new List.filled(input.length - scopedCount, "*").join();
  return '${input.substring(0, scopedCount)}$padding';
}
