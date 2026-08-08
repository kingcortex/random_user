import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'package:random_user/core/theme/app_colors.dart';

class AppCachedImageNetwork extends StatelessWidget {
  const AppCachedImageNetwork({
    required this.imageUrl,
    super.key,
    this.width,
    this.height,
    this.boxDecoration,
    this.shape,
    this.borderRaduis,
  }) : assert(
         boxDecoration == null || shape == null,
         'You cannot provide a shape if boxDecoration is defined',
       );
  final String? imageUrl;
  final double? width;
  final double? height;
  final BoxDecoration? boxDecoration;
  final BoxShape? shape;
  final BorderRadius? borderRaduis;

  BoxDecoration _buildDecorationForImage(
    BuildContext context,
    ImageProvider imageProvider,
  ) {
    if (boxDecoration != null) {
      return boxDecoration!;
    }
    return BoxDecoration(
      shape: shape ?? BoxShape.rectangle,
      borderRadius: shape == null
          ? borderRaduis ?? BorderRadius.circular(21)
          : null,
      image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
    );
  }

  BoxDecoration _buildDecorationForPlaceholder(
    BuildContext context, {
    Color? color,
  }) {
    return boxDecoration ??
        BoxDecoration(
          shape: shape ?? BoxShape.rectangle,
          borderRadius: shape == null
              ? borderRaduis ?? BorderRadius.circular(24)
              : null,
          color: color,
        );
  }

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null || imageUrl!.isEmpty) {
      return Container(
        width: width ?? double.infinity,
        height: height ?? double.infinity,
        decoration: _buildDecorationForPlaceholder(
          context,
          color: AppColors.primaryTint,
        ),
        child: const Icon(Icons.image, color: AppColors.primaryMoon700),
      );
    }
    if (imageUrl!.toLowerCase().endsWith('.svg')) {
      return Container(
        width: width ?? double.infinity,
        height: height ?? double.infinity,
        decoration: _buildDecorationForPlaceholder(context),
        child: SvgPicture.network(
          imageUrl!,
          width: width,
          height: height,
          fit: BoxFit.cover,
          placeholderBuilder: (context) =>
              const CircularProgressIndicator.adaptive(),
        ),
      );
    }

    return CachedNetworkImage(
      imageUrl: imageUrl!,
      imageBuilder: (context, imageProvider) {
        final decoration = _buildDecorationForImage(context, imageProvider);
        return Container(
          width: width ?? double.infinity,
          height: height ?? double.infinity,
          decoration: decoration,
        );
      },
      placeholder: (context, url) => Skeletonizer(
        child: Skeleton.shade(
          child: Container(
            width: width ?? double.infinity,
            height: height ?? double.infinity,
            decoration: _buildDecorationForPlaceholder(
              context,
              color: AppColors.slate100,
            ),
          ),
        ),
      ),
      errorWidget: (context, url, error) {
        log(error.toString(), name: 'AppCachedImageNetwork');
        return Container(
          width: width ?? double.infinity,
          height: height ?? double.infinity,
          decoration: _buildDecorationForPlaceholder(
            context,
            color: AppColors.primaryTint,
          ),
          child: const Icon(Icons.error, color: AppColors.errorBase),
        );
      },
    );
  }
}
