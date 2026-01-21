// lib/data/models/slider_data.dart

import 'package:flutter/material.dart';

class SliderData {
  final String title;
  final String description;
  final String buttonText;
  final String backgroundImageUrl;
  final String? overlayImageUrl;
  final List<Color> gradientColors;
  final VoidCallback? onButtonPressed;

  SliderData({
    required this.title,
    required this.description,
    required this.buttonText,
    required this.backgroundImageUrl,
    this.overlayImageUrl,
    required this.gradientColors,
    this.onButtonPressed,
  });
}

// Data statis untuk slider - mudah diubah
class SliderDataSource {
  static List<SliderData> getSliderData() {
    return [
      // Slide 1 - Temukan Herbal Terpercaya
      SliderData(
        title: 'Temukan Herbal\nTerpercaya',
        description: 'Get discounts up to 75% for\nnew herbal product.',
        buttonText: 'Lihat Produk',
        backgroundImageUrl:
            'https://images.unsplash.com/photo-1526947425960-945c6e72858f?w=800',
        overlayImageUrl:
            'https://images.unsplash.com/photo-1608571423902-eed4a5ad8108?w=400',
        gradientColors: [
          const Color(0xFF0A400C),
          const Color(0xFF0A400C).withOpacity(0.8),
        ],
      ),

      // Slide 2 - Konsultasi dengan Praktisi
      SliderData(
        title: 'Konsultasi dengan\nPraktisi Herbal',
        description: 'Dapatkan saran kesehatan dari\npraktisi berpengalaman.',
        buttonText: 'Cari Praktisi',
        backgroundImageUrl:
            'https://images.unsplash.com/photo-1505751172876-fa1923c5c528?w=800',
        overlayImageUrl: null,
        gradientColors: [Colors.green[600]!, Colors.green[700]!],
      ),
    ];
  }
}
