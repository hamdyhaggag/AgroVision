import 'package:flutter/material.dart';
import '../../../core/themes/app_colors.dart';
import '../../../shared/widgets/custom_appbar.dart';

class ChatListScreen extends StatelessWidget {
  ChatListScreen({super.key});

  final List<String> egyptianNames = [
    'Ahmed Mohamed',
    'Ali Mostafa',
    'Karim Khaled',
    'Abdallah Youssef',
    'Saeed Ibrahim',
    'Omar Hussein',
    'Mahmoud Tarek',
    'Ziad Ahmed',
    'Amira Nour',
    'Sara Nermin',
    'Mona Ibrahim',
    'Tamer Salah',
    'Hossam Farouk',
    'Yasmine Khaled',
    'Farida Ahmed',
    'Rania Mohamed',
    'Hassan Abdelrahman',
    'Nada Mahmoud',
    'Layla Samir',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        isHome: false,
        title: 'Chats',
      ),
      body: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            const TabBar(
              dividerColor: Colors.transparent,
              indicatorColor: AppColors.primaryColor,
              tabs: [
                Tab(text: 'Community'),
                Tab(text: 'Chats'),
                Tab(text: 'Chat Bot'),
              ],
              labelColor: AppColors.primaryColor,
              unselectedLabelColor: Colors.grey,
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildChatList(context, 'Community User'),
                  _buildChatList(context, 'Chat User'),
                  _buildChatList(context, 'Chat Bot'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatList(BuildContext context, String userType) {
    return ListView.builder(
      itemCount: egyptianNames.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: const CircleAvatar(
            backgroundImage: AssetImage('assets/images/user.png'),
          ),
          title: Text(egyptianNames[index % egyptianNames.length]),
          subtitle: const Text('Last seen x hours ago'),
          onTap: () {
            Navigator.pushNamed(
              context,
              '/chat-detail',
              arguments: {'title': '$userType $index'},
            );
          },
        );
      },
    );
  }
}
