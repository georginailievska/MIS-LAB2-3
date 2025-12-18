import 'package:flutter/material.dart';
import '../services/firebase_service.dart';

class FavoriteButton extends StatefulWidget {
  final String mealId;
  final VoidCallback? onToggle;

  const FavoriteButton({Key? key, required this.mealId, this.onToggle}) : super(key: key);

  @override
  _FavoriteButtonState createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  bool _isFavorite = false;
  final FirebaseService _firebase = FirebaseService();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(_isFavorite ? Icons.favorite : Icons.favorite_border, color: Colors.red),
      onPressed: () async {
        await _firebase.toggleFavorite(widget.mealId);
        setState(() => _isFavorite = !_isFavorite);
        widget.onToggle?.call();
      },
    );
  }
}
