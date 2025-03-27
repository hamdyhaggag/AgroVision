import 'package:flutter/material.dart';
import 'package:agro_vision/core/themes/app_colors.dart';
import 'package:flutter_svg/svg.dart';
import '../../../core/constants/app_assets.dart';
import '../../../shared/widgets/custom_appbar.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(isHome: true, title: 'Chats'),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            _buildEnhancedTabBar(),
            Expanded(
              child: TabBarView(
                children: [
                  _buildChatList(context),
                  _buildChatbotWelcome(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEnhancedTabBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(16),
        ),
        child: SizedBox(
          height: 50,
          child: TabBar(
            unselectedLabelColor: AppColors.greyColor,
            labelColor: AppColors.primaryColor,
            splashFactory: NoSplash.splashFactory,
            overlayColor: WidgetStateProperty.resolveWith<Color?>(
              (Set<WidgetState> states) => Colors.transparent,
            ),
            dividerColor: Colors.transparent,
            labelStyle: const TextStyle(
              fontFamily: 'SYNE',
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            unselectedLabelStyle: const TextStyle(
              fontSize: 14,
            ),
            indicatorColor: AppColors.primaryColor,
            tabs: const [
              Tab(
                text: 'Chats',
                icon: SvgIcon(
                  AppIcons.chatBubbleOutline,
                  size: 20,
                ),
              ),
              Tab(
                text: 'Chatbot',
                icon: SvgIcon(
                  AppIcons.chatbot,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      ),
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
              radius: 24,
              backgroundImage: AssetImage('assets/images/user.png')),
          title: Text('User ${index + 1}',
              style: const TextStyle(
                  fontWeight: FontWeight.w600, fontFamily: 'SYNE')),
          subtitle: const Text('Last message preview...',
              overflow: TextOverflow.ellipsis),
          trailing: const Text('2h', style: TextStyle(color: Colors.grey)),
          contentPadding: const EdgeInsets.symmetric(vertical: 8),
          onTap: () => Navigator.pushNamed(context, '/chat-detail'),
        );
      },
    );
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
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: AppColors.primaryColor.withOpacity(0.03),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withOpacity(0.05),
            blurRadius: 32,
            spreadRadius: 2,
            offset: const Offset(0, 12),
          ),
        ],
        border: Border.all(
          color: AppColors.primaryColor.withOpacity(0.1),
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
                color: AppColors.primaryColor.withOpacity(0.1),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryColor.withOpacity(0.1),
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
                        AppColors.accentColor.withOpacity(0.4),
                        AppColors.primaryColor.withOpacity(0.2),
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
                      colors: [
                        AppColors.primaryColor,
                        AppColors.accentColor,
                      ],
                      stops: [0.4, 0.6],
                    ).createShader(bounds),
                    child: const Text(
                      'Khedr',
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
                        color: AppColors.primaryColor.withOpacity(0.9),
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
                          AppColors.primaryColor.withOpacity(0.2),
                          AppColors.accentColor.withOpacity(0.4),
                          AppColors.primaryColor.withOpacity(0.2),
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
                          color: AppColors.textSecondary.withOpacity(0.95),
                          letterSpacing: 0.15,
                        ),
                        children: const [
                          TextSpan(
                            text:
                                'Welcome to Khedr \nyour AI co-pilot for cultivating success\n',
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          _buildFeatureChips(),
          const SizedBox(
            height: 20,
          ),
          _buildStartButton(context),
        ],
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
                    color: AppColors.primaryColor.withOpacity(0.2),
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
                onTap: () => Navigator.pushNamed(context, '/chat-detail'),
                splashColor: Colors.white.withOpacity(0.2),
                highlightColor: Colors.transparent,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 18,
                  ),
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
              AppColors.primaryColor.withOpacity(_isHovered ? 0.12 : 0.06),
              AppColors.primaryColor.withOpacity(_isHovered ? 0.18 : 0.10),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: AppColors.primaryColor.withOpacity(_isHovered ? 0.25 : 0.12),
            width: _isHovered ? 1.2 : 0.8,
          ),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: AppColors.primaryColor.withOpacity(0.1),
                    blurRadius: 12,
                    spreadRadius: 2,
                    offset: const Offset(0, 3),
                  )
                ]
              : [
                  BoxShadow(
                    color: AppColors.primaryColor.withOpacity(0.05),
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
                color:
                    AppColors.primaryColor.withOpacity(_isHovered ? 0.9 : 0.7)),
            const SizedBox(width: 10),
            Text(
              widget.text,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color:
                    AppColors.primaryColor.withOpacity(_isHovered ? 0.95 : 0.8),
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _FeatureCard(
      {required this.icon, required this.title, required this.subtitle});

  @override
  State<_FeatureCard> createState() => _FeatureCardState();
}

class _FeatureCardState extends State<_FeatureCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (e) => setState(() => _isHovered = true),
      onExit: (e) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutQuad,
        transform: Matrix4.identity()..translate(0.0, _isHovered ? -4 : 0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color:
                  AppColors.primaryColor.withOpacity(_isHovered ? 0.1 : 0.05),
              blurRadius: _isHovered ? 16 : 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Card(
          elevation: 0,
          color: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.all(14),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [AppColors.primaryColor, AppColors.accentColor],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Icon(widget.icon, size: 28, color: Colors.white),
                ),
                const SizedBox(height: 20),
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'SYNE',
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.subtitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary.withOpacity(0.9),
                    fontFamily: 'SYNE',
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BackgroundDotsPainter extends CustomPainter {
  final Color color;

  _BackgroundDotsPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    const spacing = 40.0;
    final dotSize = 4.0;
    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), dotSize, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
