// lib/src/renderers/array_field.dart

import 'dart:async';
import 'package:dart_json_schema_form/dart_json_schema_form.dart';
import 'package:dart_json_schema_form/generated/l10n.dart' as l10n;
import 'package:dart_json_schema_form/src/renderers/form_renderer.dart';
import 'package:dart_json_schema_form/src/utils/shared_messages.dart';
import 'package:dart_json_schema_form/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

class DjsfArrayField extends StatefulWidget {
  const DjsfArrayField({
    required this.arrayControl,
    required this.arraySchema,
    required this.arrayUiSchema,
    required this.registry,
    required this.messages,
    required this.parentSchema,
    required this.fieldName,
    super.key,
    this.transformErrors,
  });

  final FormArray arrayControl;
  final JsonMap arraySchema;
  final JsonMap arrayUiSchema;
  final DjsfFieldRegistry registry;
  final DjsfMessageBundle messages;
  final TransformErrors? transformErrors;

  final JsonMap parentSchema;
  final String fieldName;

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

    // Escuchar cambios del array para reconstruir la UI
    _sub = widget.arrayControl.valueChanges.listen((_) {
      if (mounted) setState(() {});
    });
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

    final addable = uiOptions['addable'] != false;
    final removable = uiOptions['removable'] != false;
    final orderable = uiOptions['orderable'] != false; // hook futuro

    final addText = (uiOptions['addButtonText'] as String?) ??
        l10n.S.of(context).arrayAddItem;
    final removeText = l10n.S.of(context).arrayRemoveItem;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.arrayControl.controls.length,
          itemBuilder: (context, index) {
            final itemSchema = _asMap(widget.arraySchema['items']);
            final itemUi = _itemUiSchema(widget.arrayUiSchema);
            final control = widget.arrayControl.controls[index];

            Widget itemChild;
            if (control is FormGroup) {
              // ítem objeto → sub-form
              itemChild = _buildObjectItem(index, control, itemSchema, itemUi);
            } else {
              // ítem primitivo → un solo campo
              itemChild =
                  _buildPrimitiveItem(index, control, itemSchema, itemUi);
            }

            return Card(
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
                          onPressed: () => widget.arrayControl.removeAt(index),
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
        ),
        if (addable)
          OutlinedButton.icon(
            onPressed: () {
              final itemSchema = _asMap(widget.arraySchema['items']);
              widget.arrayControl.add(_newControlForItem(itemSchema));
              // setState no es estrictamente necesario porque escuchamos valueChanges,
              // pero no hace daño y da respuesta visual inmediata.
              setState(() {});
            },
            icon: const Icon(Icons.add),
            label: Text(addText),
          ),
      ],
    );
  }

  // Render de item primitivo usando el registry
  Widget _buildPrimitiveItem(
    int index,
    AbstractControl control,
    JsonMap itemSchema,
    JsonMap itemUi,
  ) {
    final type = (itemSchema['type'] as String?) ?? 'string';
    final title = (itemSchema['title'] as String?) ?? 'Item $index';

    final fakeCtx = DjsfFieldContext(
      form: FormGroup({'_': control}),
      schema: {
        'properties': {'_': itemSchema},
      },
      uiSchema: {'_': itemUi},
      path: '_',
      propSchema: itemSchema,
      messages: widget.messages,
      transformErrors: widget.transformErrors,
      type: 'array',
    );

    final ui = readUiFor(fakeCtx);
    final decoration = InputDecoration(
      labelText: title,
      hintText: ui.hint,
      helperText: ui.description ?? ui.helper,
    );

    final messages = messagesForField(fakeCtx, '_', itemSchema);

    switch (type) {
      case 'integer':
        return ReactiveTextField<int>(
          formControl: control as FormControl<int>,
          decoration: decoration,
          keyboardType: TextInputType.number,
          validationMessages: messages,
          onChanged: (c) {
            if ((c.value == null) && ui.emptyValue != null) {
              final v = ui.emptyValue;
              if (v is int) {
                c.updateValue(v, emitEvent: false);
              } else if (v is num) {
                c.updateValue(v.toInt(), emitEvent: false);
              } else if (v is String) {
                final parsed = int.tryParse(v);
                if (parsed != null) c.updateValue(parsed, emitEvent: false);
              }
            }
          },
        );

      case 'number':
        return ReactiveTextField<num>(
          formControl: control as FormControl<num>,
          decoration: decoration,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          validationMessages: messages,
          onChanged: (c) {
            if ((c.value == null) && ui.emptyValue != null) {
              final v = ui.emptyValue;
              if (v is num) {
                c.updateValue(v, emitEvent: false);
              } else if (v is String) {
                final parsed = num.tryParse(v);
                if (parsed != null) c.updateValue(parsed, emitEvent: false);
              }
            }
          },
        );

      case 'string':
      default:
        return ReactiveTextField<String>(
          formControl: control as FormControl<String>,
          decoration: decoration,
          autofocus: ui.autofocus,
          keyboardType: ui.keyboardTypeForString(),
          autofillHints: ui.autocomplete != null ? [ui.autocomplete!] : null,
          obscureText: ui.isPassword,
          minLines: ui.isTextarea ? 3 : 1,
          maxLines: ui.isTextarea ? 6 : 1,
          validationMessages: messages,
          onChanged: (c) {
            if ((c.value == null || c.value!.isEmpty) &&
                ui.emptyValue != null) {
              c.updateValue(ui.emptyValue as String?, emitEvent: false);
            }
          },
        );
    }
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
