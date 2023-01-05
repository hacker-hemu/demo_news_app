import 'package:flutter/material.dart';

class MainNewsPostTitle extends StatelessWidget {
  const MainNewsPostTitle({
    super.key,
    this.onTap,
    this.creatorName,
    this.category,
    this.hourAgo,
    this.creatorImage,
    this.textColor,
  });

  final String? creatorImage;
  final VoidCallback? onTap;
  final String? creatorName;
  final String? category;
  final String? hourAgo;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // news creator image container
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              width: 2,
              color: Theme.of(context).primaryColor,
            ),
            borderRadius: BorderRadius.circular(100.0),
          ),
          margin: const EdgeInsets.fromLTRB(15.0, 10.0, 0, 15.0),
          child: GestureDetector(
            onTap: onTap,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100.0),
              child: Image(
                image: NetworkImage(
                  creatorImage!,
                ),
                // for error handling
                errorBuilder: (context, error, stackTrace) {
                  print(error);
                  return Container(
                    width: 50.0,
                    height: 50.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100.0),
                    ),
                    child: Center(
                      child: Text(
                        creatorName!.substring(0, 1).toUpperCase(),
                        //TODO: styling jari rakhe
                        style: const TextStyle(
                            fontSize: 40.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                },
                width: 50.0,
                height: 50.0,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),

        // about category and ?? hour ago text
        Container(
          margin: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    '$creatorName '.length > 2
                        ? '$creatorName '.split(' ').first.toUpperCase()
                        : '$creatorName '.substring(0, 3) + '...'.toUpperCase(),
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  const Text(
                    ' ने ',
                  ),
                  Text(
                    '$category ताजा खबरो ',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 15.0,
                    ),
                  ),
                ],
              ),
              Text(
                'के बारे में पोस्ट किया | $hourAgo ',
                style: const TextStyle(
                  fontSize: 14.0,
                  color: Colors.black45,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
