import 'package:flutter_wordle/domain.dart';
import 'package:test/test.dart';
import 'package:flutter_wordle/services/matching_service.dart';
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
      Letter(0, 's', GameColor.exact),
      Letter(1, 't', GameColor.exact),
      Letter(2, 'r', GameColor.exact),
      Letter(3, 'a', GameColor.exact),
      Letter(4, 'w', GameColor.exact)
    ]),
    Tuple3('straw', 'train', <Letter>[
      Letter(0, 's', GameColor.none),
      Letter(1, 't', GameColor.partial),
      Letter(2, 'r', GameColor.partial),
      Letter(3, 'a', GameColor.partial),
      Letter(4, 'w', GameColor.none)
    ]),
    Tuple3('straw', 'mulch', <Letter>[
      Letter(0, 's', GameColor.none),
      Letter(1, 't', GameColor.none),
      Letter(2, 'r', GameColor.none),
      Letter(3, 'a', GameColor.none),
      Letter(4, 'w', GameColor.none)
    ]),
    Tuple3('class', 'smart', <Letter>[
      Letter(0, 'c', GameColor.none),
      Letter(1, 'l', GameColor.none),
      Letter(2, 'a', GameColor.exact),
      Letter(3, 's', GameColor.partial),
      Letter(4, 's', GameColor.none)
    ]),
    Tuple3('smart', 'class', <Letter>[
      Letter(0, 's', GameColor.partial),
      Letter(1, 'm', GameColor.none),
      Letter(2, 'a', GameColor.exact),
      Letter(3, 'r', GameColor.none),
      Letter(4, 't', GameColor.none)
    ]),
    Tuple3('quick', 'vivid', <Letter>[
      Letter(0, 'q', GameColor.none),
      Letter(1, 'u', GameColor.none),
      Letter(2, 'i', GameColor.partial),
      Letter(3, 'c', GameColor.none),
      Letter(4, 'k', GameColor.none)
    ]),
    Tuple3('silly', 'lilly', <Letter>[
      Letter(0, 's', GameColor.none),
      Letter(1, 'i', GameColor.exact),
      Letter(2, 'l', GameColor.exact),
      Letter(3, 'l', GameColor.exact),
      Letter(4, 'y', GameColor.exact)
    ]),
    Tuple3('lilly', 'silly', <Letter>[
      Letter(0, 'l', GameColor.none),
      Letter(1, 'i', GameColor.exact),
      Letter(2, 'l', GameColor.exact),
      Letter(3, 'l', GameColor.exact),
      Letter(4, 'y', GameColor.exact)
    ]),
    Tuple3('buddy', 'added', <Letter>[
      Letter(0, 'b', GameColor.none),
      Letter(1, 'u', GameColor.none),
      Letter(2, 'd', GameColor.exact),
      Letter(3, 'd', GameColor.partial),
      Letter(4, 'y', GameColor.none)
    ]),
    Tuple3('added', 'buddy', <Letter>[
      Letter(0, 'a', GameColor.none),
      Letter(1, 'd', GameColor.partial),
      Letter(2, 'd', GameColor.exact),
      Letter(3, 'e', GameColor.none),
      Letter(4, 'd', GameColor.none)
    ]),
    Tuple3('abate', 'eager', <Letter>[
      Letter(0, 'a', GameColor.partial),
      Letter(1, 'b', GameColor.none),
      Letter(2, 'a', GameColor.none),
      Letter(3, 't', GameColor.none),
      Letter(4, 'e', GameColor.partial)
    ]),
    Tuple3('eager', 'abate', <Letter>[
      Letter(0, 'e', GameColor.partial),
      Letter(1, 'a', GameColor.partial),
      Letter(2, 'g', GameColor.none),
      Letter(3, 'e', GameColor.none),
      Letter(4, 'r', GameColor.none)
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
