import 'package:flutterdle/domain.dart';
import 'package:test/test.dart';
import 'package:flutterdle/services/matching_service.dart';
import 'package:tuple/tuple.dart';

bool compareMatches(List<Letter> first, List<Letter> second) {
  for (var i = 0; i < 5; i++) {
    if (first[i].index != second[i].index ||
        first[i].value != second[i].value ||
        first[i].color != second[i].color) {
      return false;
    }
  }
  return true;
}

void main() {
  var testData = <Tuple3<String, String, List<Letter>>>[
    Tuple3('STRAW', 'STRAW', <Letter>[
      Letter(index: 0, value: 'S', color: GameColor.correct),
      Letter(index: 1, value: 'T', color: GameColor.correct),
      Letter(index: 2, value: 'R', color: GameColor.correct),
      Letter(index: 3, value: 'A', color: GameColor.correct),
      Letter(index: 4, value: 'W', color: GameColor.correct)
    ]),
    Tuple3('STRAW', 'TRAIN', <Letter>[
      Letter(index: 0, value: 'S', color: GameColor.absent),
      Letter(index: 1, value: 'T', color: GameColor.present),
      Letter(index: 2, value: 'R', color: GameColor.present),
      Letter(index: 3, value: 'A', color: GameColor.present),
      Letter(index: 4, value: 'W', color: GameColor.absent)
    ]),
    Tuple3('STRAW', 'MULCH', <Letter>[
      Letter(index: 0, value: 'S', color: GameColor.absent),
      Letter(index: 1, value: 'T', color: GameColor.absent),
      Letter(index: 2, value: 'R', color: GameColor.absent),
      Letter(index: 3, value: 'A', color: GameColor.absent),
      Letter(index: 4, value: 'W', color: GameColor.absent)
    ]),
    Tuple3('CLASS', 'SMART', <Letter>[
      Letter(index: 0, value: 'C', color: GameColor.absent),
      Letter(index: 1, value: 'L', color: GameColor.absent),
      Letter(index: 2, value: 'A', color: GameColor.correct),
      Letter(index: 3, value: 'S', color: GameColor.present),
      Letter(index: 4, value: 'S', color: GameColor.absent)
    ]),
    Tuple3('SMART', 'CLASS', <Letter>[
      Letter(index: 0, value: 'S', color: GameColor.present),
      Letter(index: 1, value: 'M', color: GameColor.absent),
      Letter(index: 2, value: 'A', color: GameColor.correct),
      Letter(index: 3, value: 'R', color: GameColor.absent),
      Letter(index: 4, value: 'T', color: GameColor.absent)
    ]),
    Tuple3('QUICK', 'VIVID', <Letter>[
      Letter(index: 0, value: 'Q', color: GameColor.absent),
      Letter(index: 1, value: 'U', color: GameColor.absent),
      Letter(index: 2, value: 'I', color: GameColor.present),
      Letter(index: 3, value: 'C', color: GameColor.absent),
      Letter(index: 4, value: 'K', color: GameColor.absent)
    ]),
    Tuple3('SILLY', 'LILLY', <Letter>[
      Letter(index: 0, value: 'S', color: GameColor.absent),
      Letter(index: 1, value: 'I', color: GameColor.correct),
      Letter(index: 2, value: 'L', color: GameColor.correct),
      Letter(index: 3, value: 'L', color: GameColor.correct),
      Letter(index: 4, value: 'Y', color: GameColor.correct)
    ]),
    Tuple3('LILLY', 'SILLY', <Letter>[
      Letter(index: 0, value: 'L', color: GameColor.absent),
      Letter(index: 1, value: 'I', color: GameColor.correct),
      Letter(index: 2, value: 'L', color: GameColor.correct),
      Letter(index: 3, value: 'L', color: GameColor.correct),
      Letter(index: 4, value: 'Y', color: GameColor.correct)
    ]),
    Tuple3('BUDDY', 'ADDED', <Letter>[
      Letter(index: 0, value: 'B', color: GameColor.absent),
      Letter(index: 1, value: 'U', color: GameColor.absent),
      Letter(index: 2, value: 'D', color: GameColor.correct),
      Letter(index: 3, value: 'D', color: GameColor.present),
      Letter(index: 4, value: 'Y', color: GameColor.absent)
    ]),
    Tuple3('ADDED', 'BUDDY', <Letter>[
      Letter(index: 0, value: 'A', color: GameColor.absent),
      Letter(index: 1, value: 'D', color: GameColor.present),
      Letter(index: 2, value: 'D', color: GameColor.correct),
      Letter(index: 3, value: 'E', color: GameColor.absent),
      Letter(index: 4, value: 'D', color: GameColor.absent)
    ]),
    Tuple3('ABATE', 'EAGER', <Letter>[
      Letter(index: 0, value: 'A', color: GameColor.present),
      Letter(index: 1, value: 'B', color: GameColor.absent),
      Letter(index: 2, value: 'A', color: GameColor.absent),
      Letter(index: 3, value: 'T', color: GameColor.absent),
      Letter(index: 4, value: 'E', color: GameColor.present)
    ]),
    Tuple3('EAGER', 'ABATE', <Letter>[
      Letter(index: 0, value: 'E', color: GameColor.present),
      Letter(index: 1, value: 'A', color: GameColor.present),
      Letter(index: 2, value: 'G', color: GameColor.absent),
      Letter(index: 3, value: 'E', color: GameColor.absent),
      Letter(index: 4, value: 'R', color: GameColor.absent)
    ]),
  ];

  for (var t in testData) {
    test(
        'MatchingService should return correct results for ${t.item1} and ${t.item2}',
        () {
      var actualResult = MatchingService.matches(t.item1, t.item2).toList();
      expect(compareMatches(actualResult, t.item3), true);
    });
  }
}
