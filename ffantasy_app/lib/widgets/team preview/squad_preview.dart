// import 'dart:math';

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:ffantasy_app/bloc/squad_event_bloc.dart';

// List<String> sleeves = [
//   "assets/sleeves/black.png",
//   "assets/sleeves/red.png",
//   "assets/avatars/ARG.jpg"
// ];

// class SquadPreview extends StatelessWidget {
//   const SquadPreview({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<SquadEventBloc, SquadEventState>(
//       builder: (context, state) {
//         if (state is SquadAddedState) {
//           List<int> positionsCountList = state.positionPlayers;

//           // Ensure defaults if positionsCountList is not fully populated
//           while (positionsCountList.length < 4) {
//             positionsCountList.add(0);
//           }

//           return GestureDetector(
//             onVerticalDragEnd: (_) {
//               Navigator.pop(context); // End drag, close the bottom sheet
//             },
//             child: BottomSheet(
//               enableDrag: true,
//               showDragHandle: true,
//               onClosing: () {},
//               builder: (context) {
//                 return Padding(
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 15, vertical: 38),
//                   child: Column(
//                     children: [
//                       Expanded(
//                         child: Container(
//                           height: 500,
//                           decoration: const BoxDecoration(
//                             borderRadius: BorderRadius.all(Radius.circular(15)),
//                             image: DecorationImage(
//                               image: AssetImage('assets/avatars/field.jpg'),
//                               fit: BoxFit.fill,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           );
//         } else {
//           return Container(); // Placeholder for initial or loading state
//         }
//       },
//     );
//   }
// }
