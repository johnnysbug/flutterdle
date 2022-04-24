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
    Tuple3('straw', 'straw', <Letter>[
      Letter(index: 0, value: 's', color: GameColor.exact),
      Letter(index: 1, value: 't', color: GameColor.exact),
      Letter(index: 2, value: 'r', color: GameColor.exact),
      Letter(index: 3, value: 'a', color: GameColor.exact),
      Letter(index: 4, value: 'w', color: GameColor.exact)
    ]),
    Tuple3('straw', 'train', <Letter>[
      Letter(index: 0, value: 's', color: GameColor.none),
      Letter(index: 1, value: 't', color: GameColor.partial),
      Letter(index: 2, value: 'r', color: GameColor.partial),
      Letter(index: 3, value: 'a', color: GameColor.partial),
      Letter(index: 4, value: 'w', color: GameColor.none)
    ]),
    Tuple3('straw', 'mulch', <Letter>[
      Letter(index: 0, value: 's', color: GameColor.none),
      Letter(index: 1, value: 't', color: GameColor.none),
      Letter(index: 2, value: 'r', color: GameColor.none),
      Letter(index: 3, value: 'a', color: GameColor.none),
      Letter(index: 4, value: 'w', color: GameColor.none)
    ]),
    Tuple3('class', 'smart', <Letter>[
      Letter(index: 0, value: 'c', color: GameColor.none),
      Letter(index: 1, value: 'l', color: GameColor.none),
      Letter(index: 2, value: 'a', color: GameColor.exact),
      Letter(index: 3, value: 's', color: GameColor.partial),
      Letter(index: 4, value: 's', color: GameColor.none)
    ]),
    Tuple3('smart', 'class', <Letter>[
      Letter(index: 0, value: 's', color: GameColor.partial),
      Letter(index: 1, value: 'm', color: GameColor.none),
      Letter(index: 2, value: 'a', color: GameColor.exact),
      Letter(index: 3, value: 'r', color: GameColor.none),
      Letter(index: 4, value: 't', color: GameColor.none)
    ]),
    Tuple3('quick', 'vivid', <Letter>[
      Letter(index: 0, value: 'q', color: GameColor.none),
      Letter(index: 1, value: 'u', color: GameColor.none),
      Letter(index: 2, value: 'i', color: GameColor.partial),
      Letter(index: 3, value: 'c', color: GameColor.none),
      Letter(index: 4, value: 'k', color: GameColor.none)
    ]),
    Tuple3('silly', 'lilly', <Letter>[
      Letter(index: 0, value: 's', color: GameColor.none),
      Letter(index: 1, value: 'i', color: GameColor.exact),
      Letter(index: 2, value: 'l', color: GameColor.exact),
      Letter(index: 3, value: 'l', color: GameColor.exact),
      Letter(index: 4, value: 'y', color: GameColor.exact)
    ]),
    Tuple3('lilly', 'silly', <Letter>[
      Letter(index: 0, value: 'l', color: GameColor.none),
      Letter(index: 1, value: 'i', color: GameColor.exact),
      Letter(index: 2, value: 'l', color: GameColor.exact),
      Letter(index: 3, value: 'l', color: GameColor.exact),
      Letter(index: 4, value: 'y', color: GameColor.exact)
    ]),
    Tuple3('buddy', 'added', <Letter>[
      Letter(index: 0, value: 'b', color: GameColor.none),
      Letter(index: 1, value: 'u', color: GameColor.none),
      Letter(index: 2, value: 'd', color: GameColor.exact),
      Letter(index: 3, value: 'd', color: GameColor.partial),
      Letter(index: 4, value: 'y', color: GameColor.none)
    ]),
    Tuple3('added', 'buddy', <Letter>[
      Letter(index: 0, value: 'a', color: GameColor.none),
      Letter(index: 1, value: 'd', color: GameColor.partial),
      Letter(index: 2, value: 'd', color: GameColor.exact),
      Letter(index: 3, value: 'e', color: GameColor.none),
      Letter(index: 4, value: 'd', color: GameColor.none)
    ]),
    Tuple3('abate', 'eager', <Letter>[
      Letter(index: 0, value: 'a', color: GameColor.partial),
      Letter(index: 1, value: 'b', color: GameColor.none),
      Letter(index: 2, value: 'a', color: GameColor.none),
      Letter(index: 3, value: 't', color: GameColor.none),
      Letter(index: 4, value: 'e', color: GameColor.partial)
    ]),
    Tuple3('eager', 'abate', <Letter>[
      Letter(index: 0, value: 'e', color: GameColor.partial),
      Letter(index: 1, value: 'a', color: GameColor.partial),
      Letter(index: 2, value: 'g', color: GameColor.none),
      Letter(index: 3, value: 'e', color: GameColor.none),
      Letter(index: 4, value: 'r', color: GameColor.none)
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
