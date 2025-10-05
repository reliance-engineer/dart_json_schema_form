// lib/src/renderers/array_field.dart

import 'dart:async';

import 'package:dart_json_schema_form/dart_json_schema_form.dart';
import 'package:dart_json_schema_form/generated/l10n.dart' as l10n;
import 'package:dart_json_schema_form/src/containers/containers.dart';
import 'package:dart_json_schema_form/src/renderers/form_renderer.dart';
import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

class DjsfArrayField extends StatefulWidget {
  const DjsfArrayField({
    required this.ctx,
    required this.onDelete,
    super.key,
  });

  final DjsfArrayContext ctx;

  FormArray get arrayControl => ctx.control;

  JsonMap get arraySchema => ctx.arraySchema;

  JsonMap get arrayUiSchema => ctx.arrayUiSchema;

  DjsfFieldRegistry get registry => ctx.fieldRegistry;

  DjsfMessageBundle get messages => ctx.messages;

  TransformErrors? get transformErrors => ctx.transformErrors;

  JsonMap get parentSchema => ctx.parentSchema;

  String get fieldName => ctx.fieldName;

  final ValueChanged<int> onDelete;

  @override
  State<DjsfArrayField> createState() => _DjsfArrayFieldState();
}

class _DjsfArrayFieldState extends State<DjsfArrayField> {
  StreamSubscription<dynamic>? _sub;

  @override
  void initState() {
    super.initState();

    // Si minItems > 0 y el array está vacío, pre-crear ítems “en blanco”.
    final minItems = widget.arraySchema['minItems'] is int
        ? widget.arraySchema['minItems'] as int
        : 0;

    if (minItems > 0 && widget.arrayControl.controls.isEmpty) {
      final itemSchema = _asMap(widget.arraySchema['items']);
      for (var i = 0; i < minItems; i++) {
        widget.arrayControl.add(_newControlForItem(itemSchema));
      }
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final title = (widget.arraySchema['title'] as String?) ?? widget.fieldName;

    final uiOptions = (widget.arrayUiSchema['ui:options'] is Map)
        ? Map<String, dynamic>.from(widget.arrayUiSchema['ui:options'] as Map)
        : const <String, dynamic>{};

    /// If the [arraySchema['items']] is a List we don't support add or remove
    /// as is a fixed length list.
    final addable =
        widget.arraySchema['items'] is! List && uiOptions['addable'] != false;
    final removable =
        widget.arraySchema['items'] is! List && uiOptions['removable'] != false;
    final orderable =
        widget.arraySchema['items'] is! List && uiOptions['orderable'] != false;

    final addText = (uiOptions['addButtonText'] as String?) ??
        l10n.S.of(context).arrayAddItem;
    final removeText = l10n.S.of(context).arrayRemoveItem;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        StreamBuilder<List<AbstractControl>>(
          stream: widget.arrayControl.collectionChanges,
          builder: (context, snap) {
            var list = snap.data ?? widget.arrayControl.controls;
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: list.length,
              itemBuilder: (context, index) {
                final itemSchema = _asMap(widget.arraySchema['items']);
                final itemUi = _itemUiSchema(widget.arrayUiSchema);
                final control = list[index];

                Widget itemChild;
                if (control is FormGroup) {
                  // sub formular
                  itemChild =
                      _buildObjectItem(index, control, itemSchema, itemUi);
                } else {
                  // single field
                  itemChild = FormRenderer.buildWithRegistry(
                    index.toString(),
                    itemSchema,
                    widget.registry,
                    schema: widget.parentSchema,
                    control: control,
                    messages: widget.messages,
                    transformErrors: widget.transformErrors,
                  );
                }

                return Card(
                  key: ObjectKey(control.hashCode),
                  margin: const EdgeInsets.only(bottom: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        itemChild,
                        if (removable)
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton.icon(
                              onPressed: () {
                                widget.onDelete(index);
                              },
                              icon: const Icon(Icons.delete_outline),
                              label: Text(removeText),
                            ),
                          ),
                        if (!orderable) const SizedBox.shrink(),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
        if (addable)
          OutlinedButton.icon(
            onPressed: () {
              final itemSchema = _asMap(widget.arraySchema['items']);
              widget.arrayControl.add(_newControlForItem(itemSchema));
            },
            icon: const Icon(Icons.add),
            label: Text(addText),
          ),
      ],
    );
  }

  Widget _buildObjectItem(
    int index,
    FormGroup fg,
    JsonMap itemSchema,
    JsonMap itemUi,
  ) {
    final title = (itemSchema['title'] as String?) ?? 'Item #$index';
    return FormRenderer(
      form: fg,
      schema: itemSchema,
      uiSchema: itemUi,
      messages: widget.messages,
      transformErrors: widget.transformErrors,
      fieldRegistry: widget.registry,
      sectionTitle: title,
    );
  }

  AbstractControl _newControlForItem(JsonMap itemSchema) {
    final type = (itemSchema['type'] as String?) ?? 'string';
    switch (type) {
      case 'object':
        {
          // crear FormGroup según properties (sin valores iniciales)
          final props = _asMap(itemSchema['properties']);
          final req = (itemSchema['required'] is List)
              ? List<String>.from(itemSchema['required'] as List)
              : const <String>[];
          final map = <String, AbstractControl>{};
          props.forEach((k, v) {
            final sch = _asMap(v);
            final isReq = req.contains(k);
            map[k] = _newControlForItem(sch);
            if (isReq && map[k] is FormControl) {
              (map[k] as FormControl).setValidators(
                [...(map[k] as FormControl).validators, Validators.required],
                autoValidate: false,
              );
            }
          });
          return FormGroup(map);
        }

      case 'integer':
        return FormControl<int>();

      case 'number':
        return FormControl<num>();

      case 'boolean':
        return FormControl<bool>();

      case 'string':
      default:
        return FormControl<String>();
    }
  }

  JsonMap _itemUiSchema(JsonMap root) {
    // uiSchema para los ítems de un array suele estar bajo "<field>.items"
    final items = root['items'];
    return (items is Map)
        ? Map<String, dynamic>.from(items)
        : const <String, dynamic>{};
  }

  static Map<String, dynamic> _asMap(dynamic v) {
    if (v is Map) return Map<String, dynamic>.from(v);
    return const <String, dynamic>{};
  }
}
