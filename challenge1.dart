import 'dart:async';
import 'dart:io';
import 'dart:math';

// Future<String?> readFile(File a) async {
//   return await a.readAsStringSync();
// }

// Future<int?> stringToInt(File b) async {
//   String? a = await readFile(b);
//   if (a == null || a.isEmpty) return null;
//   // int? c = int.parse(a);
//   // if (c == false || c.isNaN) return null;
//   int? c;
//   try {
//     c = int.parse(a.trim());
//   } catch (e) {
//     return null;
//   }
//   return c;
// }

// Future<void> printFile(File a) async {
//   int? b = await stringToInt(a);
//   if (b == null) return;
//   print(b);
// }

// Future<List<int>?> readNumbers(File file) async {
//   List<int> numbers = [];
//   List<String> lines = await file.readAsLines();
//   for (var line in lines) {
//     line = line.trim();
//     if (line.isEmpty) continue;
//     try {
//       int number = int.parse(line);
//       numbers.add(number);
//     } catch (e) {
//       continue;
//     }
//   }
//   return numbers;
// }
Future<List<int>?> readNumbers(File file) async {
  try {
    final lines = await file.readAsLines();
    return lines
        .map((l) => l.trim())
        .where((l) => l.isNotEmpty)
        .map(int.parse)
        .toList();
  } catch (e) {
    print('Error reading file: $e');
    return null;
  }
}













// Future<int?> part1(File file) async {
//   List<int>? numbers = await readNumbers(File('./input1.txt'));
//   if (numbers == null) return null;
//   int T = numbers.removeAt(0);
//   int? a, b;
//   for (int i = 0; i < numbers.length - 1; i++) {
//     if (numbers[i] + numbers[i + 1] == T) {
//       a = numbers[i];
//       b = numbers[i + 1];
//       break;
//     }
//   }
//   if (a == null || b == null) return null;
//   return a * b;
// }
Future<int?> part1(File file) async {
  final numbers = await readNumbers(file);
  if (numbers == null || numbers.isEmpty) return null;

  final T = numbers.removeAt(0);
  final seen = <int, int>{}; 

  for (int i = 0; i < numbers.length; i++) {
    final a = numbers[i];
    final b = T - a;
    if (seen.containsKey(b)) {
      return a * b;
    }
    seen[a] = i;
  }
  return null;
}

int _max(int a, int b, int c) => a > b ? (a > c ? a : c) : (b > c ? b : c);
int _min(int a, int b, int c) => a < b ? (a < c ? a : c) : (b < c ? b : c);


// Future<int?> part2(File file) async {
//   List<int>? numbers = await readNumbers(File('./input1.txt'));
//   if (numbers == null || numbers.isEmpty) return null;
//   int T = numbers.removeAt(0);
//   int a, b, c;
//   for (int i = 0; i < numbers.length; i++) {
//     a = numbers[i];
//     for (int j = i + 1; j < numbers.length; j++) {
//       b = numbers[j];
//       //   c = numbers[j + 1];
//       //   if (a + b + c == T && Max(a, b, c) - Min(a, b, c) >= T) break loop;
//       c = T - a - b;
//       if (c <= 0) continue;
//       final k = numbers.indexOf(c);
//       if (k != -1 && k != i && k != j) {
//         if (Max(a, b, c) - Min(a, b, c) >= T) return a * b * c;
//       }
//     }
//   }
// }
Future<int?> part2(File file) async {
  final numbers = await readNumbers(file);
  if (numbers == null || numbers.isEmpty) return null;

  final T = numbers.removeAt(0);
  
  final Map<int, List<int>> indexMap = {};
  for (int i = 0; i < numbers.length; i++) {
    indexMap.putIfAbsent(numbers[i], () => []).add(i);
  }

  for (int i = 0; i < numbers.length - 1; i++) {
    final a = numbers[i];
    for (int j = i + 1; j < numbers.length; j++) {
      final b = numbers[j];
      final c = T - a - b;
      if (c <= 0) continue;

      final positions = indexMap[c];
      if (positions == null) continue;


      final hasValid = positions.any((k) => k != i && k != j);
      if (hasValid) {
        if (_max(a, b, c) - _min(a, b, c) >= 1000) {
          return a * b * c;
        }
      }
    }
  }
  return null;
}

void main() async {
  int? result1 = await part1(File('./input1.txt'));
  print('Part 1 result: $result1');

  int? result2 = await part2(File('./input1.txt'));
  print('Part 2 result: $result2');
}
