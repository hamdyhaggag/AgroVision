import 'package:agro_vision/features/home/Ui/drawer/edit_member_screen.dart';
import 'package:flutter/material.dart';
import 'package:agro_vision/shared/widgets/custom_appbar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/themes/app_colors.dart';

class TeamScreen extends StatefulWidget {
  const TeamScreen({super.key});

  @override
  TeamScreenState createState() => TeamScreenState();
}

class TeamScreenState extends State<TeamScreen> {
  List<Map<String, dynamic>> members = [
    {
      'memberName': 'Mohamed El-Gohry',
      'position': 'Ceo',
      'email': 'Gohry@gmail.com',
      'phone': '01098971853',
      'type': true,
      'image': 'assets/images/user.png',
    },
  ];

  List<Map<String, dynamic>> filteredMembers = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredMembers = members;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterMembers(String query) {
    final filtered = members.where((member) {
      final memberName = member['memberName']?.toLowerCase() ?? '';
      return memberName.contains(query.toLowerCase());
    }).toList();

    setState(() {
      filteredMembers = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Team'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSearchBar(),
            const SizedBox(height: 16.0),
            Expanded(child: _buildMemberList()),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        onChanged: _filterMembers,
        decoration: InputDecoration(
          hintText: 'Search member name',
          prefixIcon: const Icon(Icons.search, color: AppColors.primaryColor),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, color: AppColors.primaryColor),
                  onPressed: () {
                    _searchController.clear();
                    _filterMembers('');
                  },
                )
              : null,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildMemberList() {
    return ListView.builder(
      itemCount: filteredMembers.length,
      itemBuilder: (context, index) {
        final member = filteredMembers[index];
        return _buildMemberCard(member, index);
      },
    );
  }

  Widget _buildMemberCard(Map<String, dynamic> member, int index) {
    return Card(
      color: Colors.green.shade50,
      elevation: 4.0,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                member['image'],
                height: 70,
                width: 70,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    member['memberName'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Position: ${member['position']}',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Email: ${member['email']}',
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Phone: ${member['phone']}',
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Gender: ${member['type'] ? 'Male' : 'Female'}',
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: AppColors.primaryColor),
                  onPressed: () =>
                      _navigateToEditScreen(context, member, index),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _showDeleteDialog(context, index),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            children: [
              const Text('Are you sure?'),
              SvgPicture.asset(
                'assets/images/cleanup.svg',
                height: 300,
                width: 300,
              ),
            ],
          ),
          content: const Text(
            'Are you sure you want to remove this member?',
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  members.removeAt(index);
                  filteredMembers = members;
                });
                Navigator.pop(context);
              },
              child: const Text('Remove', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _navigateToEditScreen(
      BuildContext context, Map<String, dynamic> member, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditMemberScreen(
          member: member,
          index: index,
          onSave: (updatedMember) {
            setState(() {
              members[index] = updatedMember;
              filteredMembers = members;
            });
          },
        ),
      ),
    );
  }
}
