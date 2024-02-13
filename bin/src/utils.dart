int? binarySearch(int value, List sequence) {
  var min = 0;
  var max = sequence.length - 1;
  while (min <= max) {
    var mid = (min + max) ~/ 2;
    var element = sequence[mid];
    if (element < value) {
      min = mid + 1;
    } else if (element > value) {
      max = mid - 1;
    } else {
      return mid;
    }
  }
  return null;
}
