// import 'package:flutter/material.dart';
//
// import '../../../../../core/themes/app_colors.dart';
// import '../../../../../shared/widgets/custom_appbar.dart';
// import '../order_management.dart';
//
// class CreateOrderScreen extends StatefulWidget {
//   final Function(Order) onOrderCreated;
//
//   const CreateOrderScreen({super.key, required this.onOrderCreated});
//
//   @override
//   State<CreateOrderScreen> createState() => _CreateOrderScreenState();
// }
//
// class _CreateOrderScreenState extends State<CreateOrderScreen> {
//   final _formKey = GlobalKey<FormState>();
//   bool _isEditing = false;
//   late List<TextEditingController> _nameControllers;
//   late List<TextEditingController> _descControllers;
//   late List<TextEditingController> _rateControllers;
//
//   @override
//   void initState() {
//     super.initState();
//     _initializeControllers();
//   }
//
//   @override
//   void dispose() {
//     for (var c in _nameControllers) {
//       c.dispose();
//     }
//     for (var c in _descControllers) {
//       c.dispose();
//     }
//     for (var c in _rateControllers) {
//       c.dispose();
//     }
//     super.dispose();
//   }
//
//   void _initializeControllers() {
//     _nameControllers = List.generate(
//       items.length,
//       (index) => TextEditingController(text: items[index]['name']),
//     );
//     _descControllers = List.generate(
//       items.length,
//       (index) => TextEditingController(text: items[index]['desc']),
//     );
//     _rateControllers = List.generate(
//       items.length,
//       (index) => TextEditingController(text: items[index]['rate']),
//     );
//   }
//
//   void _toggleEditMode() {
//     setState(() {
//       _isEditing = !_isEditing;
//       if (!_isEditing) {
//         for (int i = 0; i < items.length; i++) {
//           items[i]['name'] = _nameControllers[i].text;
//           items[i]['desc'] = _descControllers[i].text;
//           items[i]['rate'] = _rateControllers[i].text;
//         }
//       }
//     });
//   }
//
//   final List<Map<String, String>> items = [
//     {
//       'name': 'Fresh Potato 2025',
//       'desc': 'Fresh Potato 2025 * 100K',
//       'rate': '15.00',
//       'amount': '1500.00 EGP'
//     },
//     {
//       'name': 'Fresh Tomato 2025',
//       'desc': 'Fresh Tomato 2025 * 95K',
//       'rate': '10.00',
//       'amount': '\$15,435.00'
//     },
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: CustomAppBar(
//         title: 'Create Invoice',
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.save),
//             onPressed: _submitForm,
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Form(
//           key: _formKey,
//           child: ListView(
//             children: [
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text('Client Information',
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       )),
//                   const SizedBox(height: 16),
//                   TextFormField(
//                     initialValue: 'Omar Kareem',
//                     decoration: _inputDecoration('Client Name'),
//                   ),
//                   const SizedBox(height: 16),
//                   TextFormField(
//                     initialValue: 'EL_BADR GROUP',
//                     decoration: _inputDecoration('Company Name'),
//                   ),
//                   const SizedBox(height: 16),
//                   TextFormField(
//                     initialValue: 'omar@gmail.com',
//                     decoration: _inputDecoration('Email'),
//                     keyboardType: TextInputType.emailAddress,
//                   ),
//                   const SizedBox(height: 16),
//                   TextFormField(
//                     initialValue: '01065971853',
//                     decoration: _inputDecoration('Phone'),
//                     keyboardType: TextInputType.phone,
//                   ),
//                   const SizedBox(height: 16),
//                   TextFormField(
//                     initialValue:
//                         'Franklin Avenue Street, New York, ABC 5562, United States',
//                     decoration: _inputDecoration('Address'),
//                     maxLines: 2,
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 24),
//               ListTile(
//                 contentPadding: EdgeInsets.zero,
//                 leading: const Icon(Icons.calendar_today,
//                     color: AppColors.primaryColor),
//                 title: _isEditing
//                     ? TextButton(
//                         onPressed: _handleEditDate,
//                         child: const Text('October 31st, 2020',
//                             style: TextStyle(fontWeight: FontWeight.bold)),
//                       )
//                     : const Text('October 31st, 2020',
//                         style: TextStyle(fontWeight: FontWeight.bold)),
//                 trailing: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     IconButton(
//                       icon: Icon(
//                         _isEditing ? Icons.save : Icons.edit_outlined,
//                         color: AppColors.primaryColor,
//                         size: 22,
//                       ),
//                       onPressed: _toggleEditMode,
//                       tooltip: _isEditing ? 'Save Changes' : 'Edit',
//                     ),
//                     const SizedBox(width: 8),
//                     IconButton(
//                       icon: const Icon(Icons.add_circle_outline,
//                           size: 24, color: AppColors.primaryColor),
//                       onPressed: _addNewItem,
//                       tooltip: 'Add New Item',
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 24),
//               Container(
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(12),
//                     border: Border.all(
//                         color: AppColors.primaryColor.withValues(alpha: 0.2)),
//                   ),
//                   child: ClipRRect(
//                       borderRadius: BorderRadius.circular(12),
//                       child: SingleChildScrollView(
//                         scrollDirection: Axis.horizontal,
//                         child: DataTable(
//                             columnSpacing: 32,
//                             headingRowColor: WidgetStateColor.resolveWith(
//                               (states) => AppColors.primaryColor
//                                   .withValues(alpha: 0.05),
//                             ),
//                             dataRowMinHeight: 56,
//                             horizontalMargin: 16,
//                             dividerThickness: 1,
//                             columns: const [
//                               DataColumn(
//                                 label: Text('ITEM NAME',
//                                     style: TextStyle(
//                                       fontWeight: FontWeight.w600,
//                                       color: AppColors.primaryColor,
//                                     )),
//                               ),
//                               DataColumn(
//                                 label: Text('DESCRIPTION',
//                                     style: TextStyle(
//                                       fontWeight: FontWeight.w600,
//                                       color: AppColors.primaryColor,
//                                     )),
//                               ),
//                               DataColumn(
//                                 label: Text('RATE',
//                                     style: TextStyle(
//                                       fontWeight: FontWeight.w600,
//                                       color: AppColors.primaryColor,
//                                     )),
//                               ),
//                               DataColumn(
//                                 label: Text('AMOUNT',
//                                     style: TextStyle(
//                                       fontWeight: FontWeight.w600,
//                                       color: AppColors.primaryColor,
//                                     )),
//                               )
//                             ],
//                             rows: List<DataRow>.generate(
//                                 items.length,
//                                 (index) => DataRow(
//                                       color: WidgetStateColor.resolveWith(
//                                           (states) {
//                                         return index.isEven
//                                             ? Colors.grey.shade50
//                                             : Colors.white;
//                                       }),
//                                       cells: [
//                                         DataCell(
//                                           ConstrainedBox(
//                                             constraints: const BoxConstraints(
//                                                 maxWidth: 200),
//                                             child: _isEditing
//                                                 ? TextFormField(
//                                                     controller:
//                                                         _nameControllers[index],
//                                                     style: TextStyle(
//                                                       color:
//                                                           Colors.grey.shade800,
//                                                       fontSize: 14,
//                                                     ),
//                                                     decoration: InputDecoration(
//                                                       contentPadding:
//                                                           const EdgeInsets
//                                                               .symmetric(
//                                                               horizontal: 12),
//                                                       border:
//                                                           OutlineInputBorder(
//                                                         borderRadius:
//                                                             BorderRadius
//                                                                 .circular(8),
//                                                         borderSide:
//                                                             BorderSide.none,
//                                                       ),
//                                                       filled: true,
//                                                       fillColor:
//                                                           Colors.grey.shade100,
//                                                     ),
//                                                   )
//                                                 : Text(
//                                                     items[index]['name']!,
//                                                     style: TextStyle(
//                                                       fontWeight:
//                                                           FontWeight.w500,
//                                                       color:
//                                                           Colors.grey.shade800,
//                                                     ),
//                                                   ),
//                                           ),
//                                         ),
//                                         DataCell(
//                                           ConstrainedBox(
//                                             constraints: const BoxConstraints(
//                                                 maxWidth: 300),
//                                             child: _isEditing
//                                                 ? TextFormField(
//                                                     controller:
//                                                         _descControllers[index],
//                                                     style: TextStyle(
//                                                       color:
//                                                           Colors.grey.shade800,
//                                                       fontSize: 14,
//                                                     ),
//                                                     maxLines: 2,
//                                                     decoration: InputDecoration(
//                                                       contentPadding:
//                                                           const EdgeInsets
//                                                               .symmetric(
//                                                               horizontal: 12,
//                                                               vertical: 8),
//                                                       border:
//                                                           OutlineInputBorder(
//                                                         borderRadius:
//                                                             BorderRadius
//                                                                 .circular(8),
//                                                         borderSide:
//                                                             BorderSide.none,
//                                                       ),
//                                                       filled: true,
//                                                       fillColor:
//                                                           Colors.grey.shade100,
//                                                     ),
//                                                   )
//                                                 : Text(
//                                                     items[index]['desc']!,
//                                                     style: TextStyle(
//                                                       color:
//                                                           Colors.grey.shade600,
//                                                       fontSize: 14,
//                                                     ),
//                                                   ),
//                                           ),
//                                         ),
//                                         DataCell(
//                                           Container(
//                                             alignment: Alignment.centerRight,
//                                             child: _isEditing
//                                                 ? SizedBox(
//                                                     width: 100,
//                                                     child: TextFormField(
//                                                       controller:
//                                                           _rateControllers[
//                                                               index],
//                                                       textAlign:
//                                                           TextAlign.right,
//                                                       style: TextStyle(
//                                                         color: Colors
//                                                             .grey.shade800,
//                                                         fontSize: 14,
//                                                       ),
//                                                       keyboardType:
//                                                           TextInputType.number,
//                                                       decoration:
//                                                           InputDecoration(
//                                                         contentPadding:
//                                                             const EdgeInsets
//                                                                 .symmetric(
//                                                                 horizontal: 12),
//                                                         border:
//                                                             OutlineInputBorder(
//                                                           borderRadius:
//                                                               BorderRadius
//                                                                   .circular(8),
//                                                           borderSide:
//                                                               BorderSide.none,
//                                                         ),
//                                                         filled: true,
//                                                         fillColor: Colors
//                                                             .grey.shade100,
//                                                         prefixText: '\$ ',
//                                                       ),
//                                                     ),
//                                                   )
//                                                 : Text(
//                                                     '\$${items[index]['rate']}',
//                                                     style: TextStyle(
//                                                       fontWeight:
//                                                           FontWeight.w500,
//                                                       color:
//                                                           Colors.grey.shade800,
//                                                     ),
//                                                   ),
//                                           ),
//                                         ),
//                                         DataCell(
//                                           Container(
//                                             alignment: Alignment.centerRight,
//                                             child: Text(
//                                               items[index]['amount']!,
//                                               style: const TextStyle(
//                                                 fontWeight: FontWeight.w600,
//                                                 color: AppColors.primaryColor,
//                                                 fontSize: 14,
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ))),
//                       ))),
//               const SizedBox(height: 24),
//               Column(
//                 children: [
//                   TextFormField(
//                     initialValue: '#INV-0001234',
//                     decoration: _inputDecoration('Invoice Number'),
//                   ),
//                   const SizedBox(height: 16),
//                   TextFormField(
//                     initialValue: '5,000.00',
//                     decoration: _inputDecoration('Amount (EGP)'),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 32),
//               ElevatedButton.icon(
//                 icon: const Icon(Icons.send),
//                 label: const Text('SEND INVOICE'),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: AppColors.primaryColor,
//                   foregroundColor: Colors.white,
//                   padding: const EdgeInsets.symmetric(vertical: 16),
//                 ),
//                 onPressed: _submitForm,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   InputDecoration _inputDecoration(String label) {
//     return InputDecoration(
//       labelText: label,
//       labelStyle: const TextStyle(color: Colors.grey),
//       floatingLabelStyle: const TextStyle(color: AppColors.primaryColor),
//       border: const OutlineInputBorder(
//         borderSide: BorderSide(color: Colors.grey),
//       ),
//       enabledBorder: const OutlineInputBorder(
//         borderSide: BorderSide(color: Colors.grey),
//       ),
//       focusedBorder: const OutlineInputBorder(
//         borderSide: BorderSide(color: AppColors.primaryColor),
//       ),
//       contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//     );
//   }
//
//   void _addNewItem() {
//     setState(() {
//       items.add({
//         'name': 'New Item',
//         'desc': 'Item description',
//         'rate': '0.00',
//         'amount': '0.00'
//       });
//     });
//   }
//
//   void _submitForm() {
//     if (_formKey.currentState!.validate()) {
//       Navigator.pop(context);
//     }
//   }
//
//   void _handleEditDate() {
//     showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2100),
//     ).then((pickedDate) {
//       if (pickedDate != null) {}
//     });
//   }
// }
