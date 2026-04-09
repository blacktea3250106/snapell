import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/card_model.dart';

/// 玩家卡片列表（本地存儲版，未來改 Firestore StreamProvider）
class CardsNotifier extends StateNotifier<List<CardModel>> {
  CardsNotifier() : super([]);

  void addCard(CardModel card) {
    state = [card, ...state];
  }

  void removeCard(String cardId) {
    state = state.where((c) => c.id != cardId).toList();
  }

  List<CardModel> get sortedByRarity {
    final sorted = [...state];
    sorted.sort((a, b) => b.rarity.index.compareTo(a.rarity.index));
    return sorted;
  }

  List<CardModel> get sortedByDate {
    final sorted = [...state];
    sorted.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return sorted;
  }
}

final cardsProvider =
    StateNotifierProvider<CardsNotifier, List<CardModel>>((ref) {
  return CardsNotifier();
});
