//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import '../controller/api_controller.dart';
// import '../model/api.dart';
//
// class getapi extends StatefulWidget {
//   const getapi({Key? key});
//   @override
//   State<getapi> createState() => _getapiState();
// }
// class _getapiState extends State<getapi> {
//   final ApiService _apiService = ApiService();
//   List<UserApi>? _users = [];
//   bool _isLoading = false;
//   ScrollController _scrollController = ScrollController();
//
//   @override
//   void initState() {
//     super.initState();
//     _loadMoreData();
//     _scrollController.addListener(_scrollListener);
//   }
//
//   void _loadMoreData() async {
//     if (_isLoading) return;
//     setState(() {
//       _isLoading = true;
//     });
//
//     List<UserApi>? newUsers = await _apiService.getUsers();
//     setState(() {
//       _isLoading = false;
//       if (newUsers != null) {
//         _users!.addAll(newUsers);
//       }
//     });
//   }
//
//   void _scrollListener() {
//     if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
//       _loadMoreData();
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: ListView.builder(
//         controller: _scrollController,
//         itemCount: _users!.length + 1,
//         itemBuilder: (context, index) {
//           if (index < _users!.length) {
//             return ListTile(
//               title: Text(_users![index].username),
//             );
//           } else {
//             return _isLoading
//                 ? Center(child: CircularProgressIndicator())
//                 : SizedBox();
//           }
//         },
//       ),
//     );
//   }
// }
