import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:agro_vision/core/themes/app_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import '../../../core/constants/app_assets.dart';
import '../../../models/chat_session.dart';
import '../Logic/chat_cubit.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _currentTabIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showSessionOptions(BuildContext context, ChatSession session) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.delete),
            title: const Text('Delete Session'),
            onTap: () {
              context.read<ChatCubit>().deleteSession(session.id);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Rename Session'),
            onTap: () {
              Navigator.pop(context);
              _showRenameDialog(context, session);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            _buildEnhancedTabBar(_tabController),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildChatList(context),
                  BlocBuilder<ChatCubit, ChatState>(
                    builder: (context, state) {
                      return state.sessions.isEmpty
                          ? _buildChatbotWelcome(context)
                          : _buildSessionList(context, state.sessions);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: _currentTabIndex == 1
            ? BlocBuilder<ChatCubit, ChatState>(
                builder: (context, state) {
                  return state.sessions.isNotEmpty
                      ? FloatingActionButton(
                          onPressed: () =>
                              context.read<ChatCubit>().createNewSession(),
                          child: const Icon(Icons.add),
                        )
                      : const SizedBox.shrink();
                },
              )
            : null,
      ),
    );
  }

  Widget _buildSessionList(BuildContext context, List<ChatSession> sessions) {
    return ListView.separated(
      addAutomaticKeepAlives: true,
      cacheExtent: 1000,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      physics: const BouncingScrollPhysics(),
      itemCount: sessions.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final session = sessions[index];
        final lastMessage = session.messages.isNotEmpty
            ? session.messages.last.text
            : 'Start the conversation';
        final hasUnread = session.unreadCount > 0;

        return Dismissible(
          key: Key(session.id),
          background: Container(
            color: AppColors.errorColor,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 20),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          secondaryBackground: Container(
            color: AppColors.primaryColor,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            child: const Icon(Icons.edit, color: Colors.white),
          ),
          confirmDismiss: (direction) async {
            if (direction == DismissDirection.startToEnd) {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Delete Session'),
                  content:
                      const Text('Are you sure you want to delete this chat?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Delete',
                          style: TextStyle(color: AppColors.errorColor)),
                    ),
                  ],
                ),
              );
              return confirm ?? false;
            } else if (direction == DismissDirection.endToStart) {
              _showRenameDialog(context, session);
              return false;
            }
            return false;
          },
          onDismissed: (direction) {
            if (direction == DismissDirection.startToEnd) {
              context.read<ChatCubit>().deleteSession(session.id);
            }
          },
          child: Material(
            borderRadius: BorderRadius.circular(16),
            color: AppColors.surfaceColor,
            elevation: 1,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                context.read<ChatCubit>().setCurrentSession(session.id);
                Navigator.pushNamed(context, '/chatBotDetail');
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: hasUnread
                      ? const Border(
                          left: BorderSide(
                              color: AppColors.primaryColor, width: 4))
                      : null,
                ),
                child: Row(
                  children: [
                    _buildLeadingAvatar(context, index, hasUnread),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  session.title ?? 'New Chat',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: AppColors.textPrimary,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Text(
                                DateFormat('HH:mm', context.locale.toString())
                                    .format(session.createdAt),
                                style: const TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            lastMessage,
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 14,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (hasUnread)
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryColor,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '${session.unreadCount} new',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.more_vert,
                          color: AppColors.textSecondary),
                      onPressed: () => _showSessionOptions(context, session),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLeadingAvatar(BuildContext context, int index, bool hasUnread) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primaryColor, AppColors.accentColor],
            ),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              '${index + 1}',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        if (hasUnread)
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: AppColors.errorColor,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.surfaceColor, width: 2),
            ),
          ),
      ],
    );
  }

  Widget _buildEnhancedTabBar(TabController controller) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(0x1A),
            blurRadius: 8,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: AppColors.surfaceColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: SizedBox(
          height: 50,
          child: TabBar(
            controller: controller,
            unselectedLabelColor: AppColors.greyColor,
            labelColor: AppColors.primaryColor,
            splashFactory: NoSplash.splashFactory,
            overlayColor: const WidgetStatePropertyAll(Colors.transparent),
            dividerColor: Colors.transparent,
            labelStyle: const TextStyle(
                fontFamily: 'SYNE', fontSize: 14, fontWeight: FontWeight.w500),
            unselectedLabelStyle:
                const TextStyle(fontFamily: 'SYNE', fontSize: 14),
            indicatorColor: AppColors.primaryColor,
            tabs: const [
              Tab(
                  text: 'Chats',
                  icon: SvgIcon(AppIcons.chatBubbleOutline, size: 20)),
              Tab(text: 'Chatbot', icon: SvgIcon(AppIcons.chatbot, size: 20)),
            ],
          ),
        ),
      ),
    );
  }

  void _showRenameDialog(BuildContext context, ChatSession session) {
    final controller = TextEditingController(text: session.title);
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => Dialog(
        insetPadding: const EdgeInsets.all(24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Rename Session',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w600, fontFamily: 'SYNE'),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 24),
                    onPressed: () => Navigator.pop(context),
                    splashRadius: 20,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Form(
                key: formKey,
                child: TextFormField(
                  style: const TextStyle(fontFamily: 'SYNE'),
                  controller: controller,
                  autofocus: true,
                  textInputAction: TextInputAction.done,
                  maxLength: 30,
                  decoration: InputDecoration(
                    labelText: 'Session name',
                    hintText: 'Enter new session name',
                    labelStyle: const TextStyle(fontFamily: 'SYNE'),
                    hintStyle: const TextStyle(fontFamily: 'SYNE'),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Theme.of(context).dividerColor,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                        width: 2,
                      ),
                    ),
                    counter: Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        '${controller.text.length}/30',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).hintColor,
                            ),
                      ),
                    ),
                  ),
                  onChanged: (value) => formKey.currentState?.validate(),
                  validator: (value) {
                    final trimmed = value?.trim() ?? '';
                    if (trimmed.isEmpty) {
                      return 'Please enter a session name';
                    }
                    return null;
                  },
                  onFieldSubmitted: (_) =>
                      _saveName(context, session, controller),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FilledButton.tonal(
                    onPressed: () => _saveName(context, session, controller),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      minimumSize: const Size(100, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Save Changes',
                      style: TextStyle(color: Colors.white, fontFamily: 'SYNE'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveName(BuildContext context, ChatSession session,
      TextEditingController controller) {
    final trimmed = controller.text.trim();
    if (trimmed.isNotEmpty) {
      context.read<ChatCubit>().renameSession(session.id, trimmed);
      Navigator.pop(context);
    }
  }
}

Widget _buildChatbotWelcome(BuildContext context) {
  return SingleChildScrollView(
    physics: const BouncingScrollPhysics(),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildHeaderSection(context),
        const SizedBox(height: 32),
      ],
    ),
  );
}

Widget _buildHeaderSection(BuildContext context) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 25),
    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 6),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(24),
      color: AppColors.primaryColor.withValues(alpha: 0.03),
      boxShadow: [
        BoxShadow(
          color: AppColors.primaryColor.withValues(alpha: 0.05),
          blurRadius: 32,
          spreadRadius: 2,
          offset: const Offset(0, 12),
        ),
      ],
      border: Border.all(
        color: AppColors.primaryColor.withValues(alpha: 0.1),
        width: 1,
      ),
    ),
    child: Column(
      children: [
        Container(
          height: 200,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.primaryColor.withValues(alpha: 0.1),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryColor.withValues(alpha: 0.1),
                blurRadius: 24,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: const DecorationImage(
                    image: AssetImage('assets/images/khedr.jpg'),
                    fit: BoxFit.cover,
                  ),
                  border: Border.all(
                    color: Colors.white,
                    width: 4,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Stack(
          alignment: Alignment.topCenter,
          children: [
            Positioned(
              top: -20,
              child: Container(
                width: 120,
                height: 4,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  gradient: LinearGradient(
                    colors: [
                      AppColors.accentColor.withValues(alpha: 0.4),
                      AppColors.primaryColor.withValues(alpha: 0.2),
                    ],
                  ),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [AppColors.primaryColor, AppColors.accentColor],
                    stops: [0.4, 0.6],
                  ).createShader(bounds),
                  child: const Text(
                    'Khedr Ai',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'SYNE',
                      letterSpacing: -0.5,
                      height: 0.9,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    'Agricultural Intelligence',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'SYNE',
                      color: AppColors.primaryColor.withValues(alpha: 0.9),
                      letterSpacing: 0.3,
                      height: 1.2,
                    ),
                  ),
                ),
                Container(
                  width: 72,
                  height: 2,
                  margin: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primaryColor.withValues(alpha: 0.2),
                        AppColors.accentColor.withValues(alpha: 0.4),
                        AppColors.primaryColor.withValues(alpha: 0.2),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 15.0,
                        height: 1.7,
                        fontFamily: 'SYNE',
                        fontWeight: FontWeight.w400,
                        color: AppColors.textSecondary.withValues(alpha: 0.95),
                        letterSpacing: 0.15,
                      ),
                      children: const [
                        TextSpan(
                            text:
                                'Welcome to Khedr \nyour AI co-pilot for cultivating success\n'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        _buildFeatureChips(),
        const SizedBox(height: 20),
        _buildStartButton(context),
      ],
    ),
  );
}

Widget _buildStartButton(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8),
    child: MouseRegion(
      cursor: SystemMouseCursors.click,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.95, end: 1.0),
        duration: const Duration(milliseconds: 200),
        builder: (context, value, child) =>
            Transform.scale(scale: value, child: child),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                  color: AppColors.primaryColor.withValues(alpha: 0.2),
                  blurRadius: 12,
                  offset: const Offset(0, 4))
            ],
            gradient: const LinearGradient(
              colors: [AppColors.primaryColor, AppColors.accentColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(24),
              onTap: () => context.read<ChatCubit>().createNewSession(),
              splashColor: Colors.white.withValues(alpha: 0.2),
              highlightColor: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 18),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.auto_awesome_outlined,
                        size: 22, color: Colors.white),
                    SizedBox(width: 12),
                    Text(
                      'Start Smart Session',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        fontFamily: 'SYNE',
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

Widget _buildFeatureChips() {
  return const Wrap(
    spacing: 16,
    runSpacing: 16,
    alignment: WrapAlignment.center,
    children: [
      FeatureChip(text: 'Crop Analytics'),
      FeatureChip(text: 'AI Predictions'),
      FeatureChip(text: 'Sustainability'),
      FeatureChip(text: '24/7 Support'),
    ],
  );
}

Widget _buildChatList(BuildContext context) {
  return ListView.separated(
    padding: const EdgeInsets.all(16),
    itemCount: 15,
    separatorBuilder: (context, index) =>
        Divider(height: 1, color: Colors.grey.shade200),
    itemBuilder: (context, index) {
      return ListTile(
        leading: const CircleAvatar(
            radius: 24, backgroundImage: AssetImage('assets/images/user.png')),
        title: Text('User ${index + 1}',
            style: const TextStyle(
                fontWeight: FontWeight.w600, fontFamily: 'SYNE')),
        subtitle: const Text('Last message preview...',
            overflow: TextOverflow.ellipsis),
        trailing: const Text('2h', style: TextStyle(color: Colors.grey)),
        contentPadding: const EdgeInsets.symmetric(vertical: 8),
        onTap: () => Navigator.pushNamed(context, '/farmerChatScreen'),
      );
    },
  );
}

class SvgIcon extends StatelessWidget {
  final String assetPath;
  final double size;
  final Color? color;

  const SvgIcon(
    this.assetPath, {
    super.key,
    this.size = 24,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final iconColor = color ?? IconTheme.of(context).color;
    return SvgPicture.asset(
      assetPath,
      width: size,
      height: size,
      colorFilter: iconColor != null
          ? ColorFilter.mode(iconColor, BlendMode.srcIn)
          : null,
    );
  }
}

class FeatureChip extends StatefulWidget {
  final String text;

  const FeatureChip({super.key, required this.text});

  @override
  State<FeatureChip> createState() => _FeatureChipState();
}

class _FeatureChipState extends State<FeatureChip> {
  bool _isHovered = false;

  IconData _getIcon() {
    switch (widget.text) {
      case 'Crop Analytics':
        return Icons.analytics;
      case 'AI Predictions':
        return Icons.psychology;
      case 'Sustainability':
        return Icons.eco;
      case '24/7 Support':
        return Icons.support_agent;
      default:
        return Icons.widgets;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (e) => setState(() => _isHovered = true),
      onExit: (e) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primaryColor
                  .withValues(alpha: _isHovered ? 0.12 : 0.06),
              AppColors.primaryColor
                  .withValues(alpha: _isHovered ? 0.18 : 0.10),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: AppColors.primaryColor
                .withValues(alpha: _isHovered ? 0.25 : 0.12),
            width: _isHovered ? 1.2 : 0.8,
          ),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: AppColors.primaryColor.withValues(alpha: 0.1),
                    blurRadius: 12,
                    spreadRadius: 2,
                    offset: const Offset(0, 3),
                  )
                ]
              : [
                  BoxShadow(
                    color: AppColors.primaryColor.withValues(alpha: 0.05),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  )
                ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(_getIcon(),
                size: 18,
                color: AppColors.primaryColor
                    .withValues(alpha: _isHovered ? 0.9 : 0.7)),
            const SizedBox(width: 10),
            Text(
              widget.text,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryColor
                    .withValues(alpha: _isHovered ? 0.95 : 0.8),
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
