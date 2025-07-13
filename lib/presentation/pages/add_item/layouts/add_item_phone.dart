import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:crop_image/crop_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supermarket/core/constants/app_strings.dart';
import 'package:supermarket/core/services/validation_service.dart';
import 'package:supermarket/core/utils/extensions.dart';
import 'package:supermarket/domain/entities/product_entity.dart';
import 'package:supermarket/presentation/blocs/add_item/add_item_cubit.dart';
import 'package:supermarket/presentation/blocs/inventory/inventory_bloc.dart';
import 'package:supermarket/presentation/blocs/inventory/events/inventory_event.dart';

class AddItemPhone extends StatefulWidget {
  const AddItemPhone({super.key, this.productToUpdate});
  final ProductEntity? productToUpdate;

  @override
  State<AddItemPhone> createState() => _AddItemPhoneState();
}

class _AddItemPhoneState extends State<AddItemPhone> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _priceFocusNode = FocusNode();

  final CropController cropController = CropController(
    aspectRatio: 1,
    defaultCrop: const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9),
  );

  @override
  void initState() {
    super.initState();
    if (widget.productToUpdate == null) return;

    _nameController.text = widget.productToUpdate!.name!;
    _priceController.text = widget.productToUpdate!.price.toString();
    setCropController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();

    _nameFocusNode.dispose();
    _priceFocusNode.dispose();

    cropController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    final pixelRatio = MediaQuery.of(context).devicePixelRatio;

    if (_formKey.currentState?.validate() ?? false) {
      final ProductEntity product = await context.read<AddItemCubit>().onSubmit(
        _nameController.text,
        double.parse(_priceController.text),
        cropController,
        pixelRatio,
        widget.productToUpdate?.id,
      );

      if (!mounted) return;

      if (widget.productToUpdate == null) {
        context.read<InventoryBloc>().add(InventoryAddItemEvent(product));
      } else {
        log(product.id.toString());
        log(product.name.toString());
        log(product.price.toString());
        log(product.quantity.toString());
        log(product.imagePath.toString());
        context.read<InventoryBloc>().add(InventoryEditItemEvent(product));
      }
      context.pop();
    }
  }

  Future<void> setCropController() async {
    if (widget.productToUpdate!.imagePath == null) return;

    final File file = File(widget.productToUpdate!.imagePath!);

    final Uint8List bytes = await file.readAsBytes();

    final ui.Codec codec = await ui.instantiateImageCodec(bytes);

    final ui.FrameInfo frameInfo = await codec.getNextFrame();

    cropController.image = frameInfo.image;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: Text(AppStrings.addItem)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            spacing: 12.h,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              BlocBuilder<AddItemCubit, AddItemState>(
                builder: (context, state) {
                  return SelectThumbnailWidget(
                    cropController: cropController,
                    onSelectImage: () {
                      context.bottomSheet(
                        SelectImageSourceBottomSheet(
                          cameraAction: () {
                            context.read<AddItemCubit>().pickImageFromCamera();
                            context.pop();
                          },
                          galleryAction: () {
                            context.read<AddItemCubit>().pickImageFromGallery();
                            context.pop();
                          },
                        ),
                        borderRadius: BorderRadius.circular(8.r),
                      );
                    },
                    onRemoveImage: () {
                      context.read<AddItemCubit>().removeImage();
                    },
                    imagePath:
                        state is AddItemThumbnailChanged
                            ? state.imagePath
                            : widget.productToUpdate?.imagePath,
                  );
                },
              ),
              TextFormField(
                controller: _nameController,
                focusNode: _nameFocusNode,
                onFieldSubmitted: (_) {
                  _priceFocusNode.requestFocus();
                },
                decoration: InputDecoration(
                  labelText: AppStrings.itemName,
                  constraints: BoxConstraints(maxWidth: 358.w, minHeight: 72.h),
                ),
                validator: ValidationService.validateItemName,
              ),
              TextFormField(
                controller: _priceController,
                focusNode: _priceFocusNode,
                decoration: InputDecoration(
                  labelText: AppStrings.price,
                  constraints: BoxConstraints(maxWidth: 358.w, minHeight: 72.h),
                ),
                keyboardType: TextInputType.number,
                validator: ValidationService.validatePrice,
              ),
              SizedBox(height: 24.h),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text(AppStrings.addItem),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SelectThumbnailWidget extends StatelessWidget {
  const SelectThumbnailWidget({
    super.key,
    this.imagePath,
    required this.onSelectImage,
    required this.onRemoveImage,
    required this.cropController,
  });

  final String? imagePath;
  final VoidCallback onSelectImage;
  final VoidCallback onRemoveImage;
  final CropController cropController;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        log(imagePath.toString());
        if (imagePath == null) {
          onSelectImage();
          return;
        } else {
          onRemoveImage();
          return;
        }
      },
      child: Container(
        height: MediaQuery.sizeOf(context).width - 32,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          color: context.colorScheme.surface,
        ),
        child:
            imagePath != null
                ? CropImage(
                  controller: cropController,
                  image: Image.file(File(imagePath!)),
                  alwaysMove: true,
                )
                : Column(
                  spacing: 8.h,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.airplay_rounded,
                      size: 64.r,
                      color: context.theme.scaffoldBackgroundColor,
                    ),
                    Text(
                      AppStrings.clickToAddThumbnail,
                      style: context.theme.textTheme.bodyMedium!.copyWith(
                        color: context.colorScheme.onSecondary,
                      ),
                    ),
                  ],
                ),
      ),
    );
  }
}

class SelectImageSourceBottomSheet extends StatelessWidget {
  const SelectImageSourceBottomSheet({
    super.key,
    required this.galleryAction,
    required this.cameraAction,
  });
  final VoidCallback galleryAction;
  final VoidCallback cameraAction;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          leading: const Icon(Icons.photo_library),
          title: Text(AppStrings.gallery),
          onTap: galleryAction,
        ),
        ListTile(
          leading: const Icon(Icons.camera_alt),
          title: Text(AppStrings.camera),
          onTap: cameraAction,
        ),
      ],
    );
  }
}
