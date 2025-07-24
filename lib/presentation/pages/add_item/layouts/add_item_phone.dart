import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:crop_image/crop_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supermarket/core/constants/app_strings.dart';
import 'package:supermarket/core/services/validation_service.dart';
import 'package:supermarket/core/utils/extensions.dart';
import 'package:supermarket/domain/entities/product_entity.dart';
import 'package:supermarket/presentation/blocs/add_item/add_item_cubit.dart';
import 'package:supermarket/presentation/blocs/add_item/state/add_item_state.dart';
import 'package:supermarket/presentation/blocs/inventory/inventory_cubit.dart';
import 'package:supermarket/presentation/pages/add_item/widgets/select_image_source_bottomsheet.dart';
import 'package:supermarket/presentation/pages/add_item/widgets/select_thumbnail.dart';
import 'package:supermarket/presentation/widgets/elevated_loader_button.dart';

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

  late final double devicePixelRatio;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
    });
    if (widget.productToUpdate == null) return;

    _nameController.text = widget.productToUpdate!.name!;
    _priceController.text = widget.productToUpdate!.price.toString();
    _setCropController();
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
    bool? isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    final ProductEntity product = await context.read<AddItemCubit>().onSubmit(
      _nameController.text,
      double.parse(_priceController.text),
      cropController,
      devicePixelRatio,
      widget.productToUpdate?.id,
    );

    if (!mounted) return;

    log(product.toString());

    if (widget.productToUpdate != null) {
      context.read<InventoryCubit>().updateProduct(product);
    } else {
      context.read<InventoryCubit>().addProduct(product);
    }
    context.pop();
  }

  Future<void> _setCropController() async {
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
      appBar: AppBar(
        title: Text(
          widget.productToUpdate != null
              ? AppStrings.updateItem
              : AppStrings.addItem,
        ),
      ),
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
                    onSelectImage:
                        () => context.bottomSheet(
                          SelectImageSourceBottomSheet(
                            isMobilePlatform:
                                Platform.isAndroid || Platform.isIOS,
                            cameraAction: () {
                              context
                                  .read<AddItemCubit>()
                                  .pickImageFromCamera();
                              context.pop();
                            },
                            galleryAction: () {
                              context
                                  .read<AddItemCubit>()
                                  .pickImageFromGallery();
                              context.pop();
                            },
                          ),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
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
              ElevatedLoaderButton(
                onPressed: _submitForm,
                text:
                    widget.productToUpdate != null
                        ? AppStrings.updateItem
                        : AppStrings.addItem,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
