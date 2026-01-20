import 'package:flutter/material.dart';

InkWell searchBar(void Function() onTapFunc, String hintText) {
  return InkWell(
    onTap: () {
      print('Tapped search bar');
      onTapFunc();
    },
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.search, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Text(
            hintText,
            style: TextStyle(fontSize: 15, color: Colors.grey[600]),
          ),
        ],
      ),
    ),
  );
}
