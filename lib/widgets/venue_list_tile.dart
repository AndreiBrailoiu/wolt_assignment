import 'package:flutter/material.dart';
import '../models/venue.dart';
import '../extras/shake_animation.dart';

// creation of specific venue item
class VenueListTile extends StatefulWidget {
  final Venue venue;
  final VoidCallback onFavoriteToggle;

  const VenueListTile({
    super.key,
    required this.venue,
    required this.onFavoriteToggle,
  });

  @override
  // ignore: library_private_types_in_public_api
  _VenueListTileState createState() => _VenueListTileState();
}

class _VenueListTileState extends State<VenueListTile>
    with SingleTickerProviderStateMixin {
  late ShakeAnimation _shakeAnimation;
  bool _isExpanded = false; // track if the venue description is expanded

  @override
  void initState() {
    super.initState();
    _shakeAnimation = ShakeAnimation(vsync: this); // initialize the shake animation
  }

  @override
  void dispose() {
    _shakeAnimation.dispose();
    super.dispose();
  }

  // trigger the shake animation and favorite toggle
  void _onFavoritePressed() {
    _shakeAnimation.trigger();
    widget.onFavoriteToggle();
  }

  @override
  Widget build(BuildContext context) {
    final isLongDescription = widget.venue.shortDescription.length > 49; // char limit before truncating

    return AnimatedBuilder(
      animation: _shakeAnimation.animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_shakeAnimation.animation.value, 0), // apply horizontal shake effect
          child: child,
        );
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                widget.venue.imageUrl,
                width: 75,
                height: 75,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.image, size: 50, color: Colors.grey),
              ),
            ),
            title: Text(
              widget.venue.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.venue.shortDescription,
                  maxLines: _isExpanded ? null : 2, // show 2 lines when not expanded
                  overflow: _isExpanded
                      ? TextOverflow.visible
                      : TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                ),
                if (isLongDescription) ...[
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isExpanded = !_isExpanded; // toggle expanded state
                      });
                    },
                    child: Text(
                      _isExpanded ? 'Show less' : 'Show more',
                      style: const TextStyle(
                        color: Colors.blue,
                        fontSize: 12,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            trailing: IconButton(
              icon: Icon(
                widget.venue.isFavorite
                    ? Icons.favorite
                    : Icons.favorite_border,
                color: widget.venue.isFavorite ? Colors.red : null,
              ),
              onPressed: _onFavoritePressed, // trigger shake on favorite toggle
            ),
          ),
        ),
      ),
    );
  }
}
